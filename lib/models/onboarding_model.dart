class OnboardingPageData {
  final String? title;
  final String? description;
  final String? image;
  final bool showLogo;
  final bool isWelcomePage;
  final bool isBubblePage;

  OnboardingPageData({
    this.title,
    this.description,
    this.image,
    this.showLogo = false,
    this.isWelcomePage = false,
    this.isBubblePage = false,
  });
}

final List<OnboardingPageData> onboardingPages = [
  // First screen - Welcome with logo
  OnboardingPageData(
    isWelcomePage: true,
    showLogo: false,
  ),

  // Second screen - Real Friends Real Stories
  OnboardingPageData(
    showLogo: true,
    isBubblePage: true,
  ),

  // Third screen - Group Chat
  OnboardingPageData(
    title: 'Nhóm Chat',
    description: 'Kết nối với nội nhóm người bạn thân của bạn',
    image: 'assets/images/group_chat.png',
    showLogo: false,
  ),

  // Fourth screen - Audio and Video Calls
  OnboardingPageData(
    title: 'Gọi Âm Thanh Và Video',
    description: 'Gặp mặt mọi người thông qua các cuộc gọi',
    image: 'assets/images/video_call.png',
    showLogo: false,
  ),

  // Fifth screen - Security
  OnboardingPageData(
    title: 'Bảo Mật Thông Tin',
    description: 'Đảm bảo thông tin của bạn luôn được bảo mật, riêng tư',
    image: 'assets/images/security.png',
    showLogo: false,
  ),

  // Sixth screen - Multimedia
  OnboardingPageData(
    title: 'Đa Phương Tiện',
    description: 'Kết nối với nhiều thiết bị của bạn cùng lúc để chat với bạn bè',
    image: 'assets/images/video_call.png',
    showLogo: false,
  ),
];
