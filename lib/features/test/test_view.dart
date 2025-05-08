import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'dart:convert';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WebRTC Video Call',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CallScreen(),
    );
  }
}

class CallScreen extends StatefulWidget {
  const CallScreen({Key? key}) : super(key: key);

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final _localVideoRenderer = RTCVideoRenderer();
  final _remoteVideoRenderer = RTCVideoRenderer();

  MediaStream? _localStream;
  RTCPeerConnection? _peerConnection;
  io.Socket? _socket;

  bool _isConnected = false;
  bool _inCall = false;
  String _roomId = '';
  String _userId = '';
  String _partnerId = '';
  String _callStatus = 'Disconnected';

  final TextEditingController _roomController = TextEditingController();
  final TextEditingController _serverController = TextEditingController(
      text: 'http://localhost:3000'
  );

  @override
  void initState() {
    super.initState();
    _initializeRenderers();
  }

  @override
  void dispose() {
    _localVideoRenderer.dispose();
    _remoteVideoRenderer.dispose();
    _localStream?.dispose();
    _peerConnection?.dispose();
    _socket?.disconnect();
    super.dispose();
  }

  Future<void> _initializeRenderers() async {
    await _localVideoRenderer.initialize();
    await _remoteVideoRenderer.initialize();
  }

  void _connectToSignalingServer() {
    if (_serverController.text.isEmpty) {
      _showSnackBar('Please enter a server URL');
      return;
    }

    setState(() {
      _callStatus = 'Connecting to server...';
    });

    // Generate a random user ID
    _userId = DateTime.now().millisecondsSinceEpoch.toString();

    _socket = io.io(
      _serverController.text,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      setState(() {
        _isConnected = true;
        _callStatus = 'Connected to signaling server';
      });
      _showSnackBar('Connected to signaling server');

      // Register user ID with server
      _socket!.emit('register', {'userId': _userId});
    });

    _socket!.onDisconnect((_) {
      setState(() {
        _isConnected = false;
        _callStatus = 'Disconnected from server';
      });
      _showSnackBar('Disconnected from server');
    });

    // Handle incoming call
    _socket!.on('incoming-call', (data) async {
      _partnerId = data['from'];
      _showIncomingCallDialog();
    });

    // Handle offer from peer
    _socket!.on('offer', (data) async {
      if (_peerConnection == null) {
        await _createPeerConnection();
      }

      await _peerConnection!.setRemoteDescription(
        RTCSessionDescription(
          data['offer']['sdp'],
          data['offer']['type'],
        ),
      );

      RTCSessionDescription answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);

      _socket!.emit('answer', {
        'answer': answer.toMap(),
        'to': data['from'],
      });

      setState(() {
        _inCall = true;
        _partnerId = data['from'];
        _callStatus = 'Call in progress';
      });
    });

    // Handle answer to our offer
    _socket!.on('answer', (data) async {
      await _peerConnection?.setRemoteDescription(
        RTCSessionDescription(
          data['answer']['sdp'],
          data['answer']['type'],
        ),
      );
    });

    // Handle ICE candidate
    _socket!.on('ice-candidate', (data) async {
      if (_peerConnection != null) {
        await _peerConnection!.addCandidate(
          RTCIceCandidate(
            data['candidate']['candidate'],
            data['candidate']['sdpMid'],
            data['candidate']['sdpMLineIndex'],
          ),
        );
      }
    });

    // Handle call rejected
    _socket!.on('call-rejected', (data) {
      _endCall();
      _showSnackBar('Call was rejected');
    });

    // Handle call ended
    _socket!.on('call-ended', (data) {
      _endCall();
      _showSnackBar('Call ended by peer');
    });
  }

  Future<void> _createPeerConnection() async {
    Map<String, dynamic> configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
        // You might want to add TURN servers for production
      ]
    };

    _peerConnection = await createPeerConnection(configuration);

    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      _socket!.emit('ice-candidate', {
        'candidate': candidate.toMap(),
        'to': _partnerId,
      });
    };

    _peerConnection!.onTrack = (RTCTrackEvent event) {
      if (event.track.kind == 'video') {
        _remoteVideoRenderer.srcObject = event.streams[0];
      }
    };

    // Get user media
    _localStream = await navigator.mediaDevices.getUserMedia({
      'video': true,
      'audio': true,
    });

    _localVideoRenderer.srcObject = _localStream;

    // Add local tracks to peer connection
    _localStream!.getTracks().forEach((track) {
      _peerConnection!.addTrack(track, _localStream!);
    });
  }

  Future<void> _makeCall() async {
    if (!_isConnected) {
      _showSnackBar('Not connected to server');
      return;
    }

    if (_roomController.text.isEmpty) {
      _showSnackBar('Please enter recipient ID');
      return;
    }

    setState(() {
      _callStatus = 'Initiating call...';
      _partnerId = _roomController.text;
    });

    // Create peer connection if not already created
    if (_peerConnection == null) {
      await _createPeerConnection();
    }

    // Notify the server we want to call someone
    _socket!.emit('start-call', {
      'to': _partnerId,
      'from': _userId,
    });

    // Create and send offer
    RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    _socket!.emit('offer', {
      'offer': offer.toMap(),
      'to': _partnerId,
    });
  }

  void _endCall() {
    // Send end call signal to peer
    if (_socket != null && _partnerId.isNotEmpty) {
      _socket!.emit('end-call', {'to': _partnerId});
    }

    // Close and clean up WebRTC connection
    _peerConnection?.close();
    _peerConnection = null;

    // Stop local stream
    _localStream?.getTracks().forEach((track) => track.stop());
    _localStream = null;

    // Reset video renderers
    _localVideoRenderer.srcObject = null;
    _remoteVideoRenderer.srcObject = null;

    setState(() {
      _inCall = false;
      _partnerId = '';
      _callStatus = _isConnected ? 'Connected to server' : 'Disconnected';
    });
  }

  void _acceptCall() async {
    Navigator.of(context).pop(); // Close the dialog

    // Create peer connection if not already created
    if (_peerConnection == null) {
      await _createPeerConnection();
    }

    setState(() {
      _inCall = true;
      _callStatus = 'Call in progress';
    });

    // Signal to the caller that we've accepted
    _socket!.emit('call-accepted', {'to': _partnerId});
  }

  void _rejectCall() {
    Navigator.of(context).pop(); // Close the dialog

    // Signal to the caller that we've rejected
    _socket!.emit('call-rejected', {'to': _partnerId});

    setState(() {
      _partnerId = '';
    });
  }

  void _showIncomingCallDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Incoming Call'),
        content: Text('Call from: $_partnerId'),
        actions: [
          TextButton(
            onPressed: _rejectCall,
            child: const Text('Reject'),
          ),
          ElevatedButton(
            onPressed: _acceptCall,
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebRTC Video Call'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Status: $_callStatus'),
                if (_isConnected) Text('Your ID: $_userId'),
                const SizedBox(height: 10),
                TextField(
                  controller: _serverController,
                  decoration: const InputDecoration(
                    labelText: 'Server URL',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _isConnected ? null : _connectToSignalingServer,
                  child: Text(_isConnected ? 'Connected' : 'Connect to Server'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _roomController,
                  decoration: const InputDecoration(
                    labelText: 'Recipient ID',
                    border: OutlineInputBorder(),
                  ),
                  enabled: _isConnected && !_inCall,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: (_isConnected && !_inCall) ? _makeCall : null,
                  child: const Text('Make Call'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Stack(
                children: [
                  RTCVideoView(
                    _remoteVideoRenderer,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    width: 100,
                    height: 150,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      child: RTCVideoView(
                        _localVideoRenderer,
                        mirror: true,
                        objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_inCall)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _endCall,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('End Call'),
              ),
            ),
        ],
      ),
    );
  }
}