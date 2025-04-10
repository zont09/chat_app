enum AppText {
  titleResetPasswordSuccess,
  titleYourGroup,

  textRouteLogin,
  textRouteChat,
  textRouteOverview,
  textRouteProfile,

  textLogin,
  textSignUp,
  textNoAccount,
  textCreateAccountNow,
  textForgotPassword,
  textSignInWithGG,
  textSignUpSuccess,
  textSignUpFail,
  textHasError,
  textCheckVerifyEmail,
  textEmailAlreadyInUse,
  textHasErrorAndTryAgain,
  textPleaseVerify,
  textEmailNoSignUp,
  textNoSpamAndTryAgain,
  textLoginFail,
  textResetPasswordSuccess,
  textProfile,
  textOwner,
  textMembers,
  textActive,
  textInactive,

  textHintUsername,
  textHintPassword,
  textHintReEnterPassword,
  textHintEmailForgotPassword,
  textPleaseDoNotLeaveItBlank,
  textInvalidEmail,
  textRePasswordNotMatch,
  textPasswordIncorrect,

  btnConfirm,
  btnCancel,
  btnOk,
  btnSendRequest,
  btnSignOut,
}

Map<AppText, String> texts = {
  AppText.textRouteLogin: "/login",
  AppText.textRouteChat: "/chat",
  AppText.textRouteOverview: "/overview",
  AppText.textRouteProfile: "/profile",

  AppText.titleResetPasswordSuccess: "Đặt lại thành công",
  AppText.titleYourGroup: "Nhóm của bạn",

  AppText.textLogin: "Đăng nhập",
  AppText.textSignUp: "Đăng ký",
  AppText.textHintReEnterPassword: "Nhập lại mật khẩu",
  AppText.textNoAccount: "Bạn chưa có tài khoản? ",
  AppText.textCreateAccountNow: "Đăng ký ngay!",
  AppText.textForgotPassword: "Quên mật khẩu",
  AppText.textSignInWithGG: "Đăng nhập với tài khoản google",
  AppText.textPleaseDoNotLeaveItBlank: "Vui lòng không để trống",
  AppText.textInvalidEmail: "Email không hợp lệ",
  AppText.textRePasswordNotMatch: "Mật khẩu nhập lại không trùng khớp",
  AppText.textSignUpSuccess: "Đăng ký thành công",
  AppText.textCheckVerifyEmail: "Đăng ký thành công! Vui lòng kiểm tra email của bạn để xác nhận tài khoản",
  AppText.textSignUpFail: "Đăng ký thất bại",
  AppText.textHasError: "Xảy ra lỗi",
  AppText.textEmailAlreadyInUse: "Email này đã được sử dụng, vui lòng đăng nhập hoặc thử đăng ký bằng một email khác",
  AppText.textHasErrorAndTryAgain: "Đã có lỗi xảy ra, vui lòng thử lại",
  AppText.textPleaseVerify: 'Vui lòng xác nhận email trước khi đăng nhập',
  AppText.textEmailNoSignUp: 'Email chưa được đăng ký',
  AppText.textPasswordIncorrect: 'Mật khẩu không chính xác',
  AppText.textNoSpamAndTryAgain: 'Bạn đã nhập sai quá nhiều lần. Vui lòng thử lại sau',
  AppText.textLoginFail: "Đăng nhập thất bại",
  AppText.textHintEmailForgotPassword: "Nhập email muốn lấy lại mật khẩu",
  AppText.textResetPasswordSuccess: "Mật khẩu đã được đặt lại thành công, vui lòng kiểm tra email để đặt lại mật khẩu",
  AppText.textProfile: "Thông tin cá nhân",
  AppText.textHintUsername: "Nhập email đăng nhập",
  AppText.textHintPassword: "Nhập mật khẩu",
  AppText.textOwner: 'Người tạo',
  AppText.textMembers: "Thành viên",
  AppText.textActive: "Đang hoạt động",
  AppText.textInactive: "Ngưng hoạt động",

  AppText.btnConfirm: "Xác nhận",
  AppText.btnCancel: "Huỷ",
  AppText.btnOk: "Ok",
  AppText.btnSendRequest: "Gửi yêu cầu",
  AppText.btnSignOut: "Đăng xuất",
};

extension AppTexts on AppText {
  static String getStringValue(String value) {
    return value;
  }

  String get text => texts[this] ?? '--TextNotFound--';
}