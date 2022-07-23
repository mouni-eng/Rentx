import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rentx/infrastructure/exceptions.dart';
import 'package:rentx/infrastructure/local_storage.dart';
import 'package:rentx/models/login.dart';
import 'package:rentx/models/user.dart';
import 'package:rentx/services/rentx_service.dart';

class AuthService extends RentXService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static bool isLoggedIn = false;
  static UserRole? loggedUserRole;

  Future<LoginResponse> login(final LoginRequest loginRequest) async {
    var resp = await httpService.doPost(
        url: '/user/signIn', rentXRequest: loginRequest);
    final LoginResponse loginResponse = LoginResponse.fromJson(resp["result"]);
    await localStorage.setString(LocalStorageKeys.authKey, loginResponse.token);
    await localStorage.setString(LocalStorageKeys.loginProvider, 'rentx');
    isLoggedIn = true;
    loggedUserRole = loginResponse.role;
    return loginResponse;
  }

  Future<LoginResponse> loginWithGoogle() async {
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.disconnect();
    }

    var loginData = await _googleSignIn.signIn();
    if (loginData == null) {
      throw ApiException.authenticationError();
    }
    var auth = await loginData.authentication;
    return _providerLogin(auth.idToken, 'google');
  }

  Future<LoginResponse> loginWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.i.login();
    if (loginResult.status == LoginStatus.success) {
      return _providerLogin(loginResult.accessToken!.token, 'facebook');
    } else {
      throw ApiException.authenticationError();
    }
  }

  Future<bool> register(final UserSignUpRequest request) async {
    await httpService.doPost(url: '/user/signUp', rentXRequest: request);
    return true;
  }

  Future<bool> companyRegister(final CompanySignUpRequest request) async {
    await httpService.doPost(url: '/company', rentXRequest: request);
    return true;
  }

  Future<LoginResponse> confirmAccount(
      final String username, final String confirmationCode) async {
    dynamic resp = await httpService.doGet(
        '/user/email/confirm?confirmationCode=$confirmationCode&username=$username');
    final loginResponse = LoginResponse.fromJson(resp['result']);
    await localStorage.setString(LocalStorageKeys.authKey, loginResponse.token);
    await localStorage.setString(LocalStorageKeys.loginProvider, 'rentx');
    return loginResponse;
  }

  Future<UserDetails> loggedUserDetails({bool? forceRefresh = false}) async {
    var resp = await _getUserDetails(forceRefresh!).catchError((err) {
      isLoggedIn = false;
      throw err;
    });

    var userDetails = UserDetails.fromJson(resp['result']);
    isLoggedIn = userDetails.username != null;
    loggedUserRole = userDetails.role!;
    return userDetails;
  }

  Future<Map<String, dynamic>> _getUserDetails(bool forceRefresh) async {
    return forceRefresh
        ? await httpService.doGet('/user/details/')
        : await cacheOrGet(LocalStorageKeys.userDetails,
            () => httpService.doGet('/user/details/'));
  }

  Future<Authentication> getAuthentication() async {
    var auth = await localStorage.getJson(LocalStorageKeys.authentication);
    if (auth.isNotEmpty) {
      return Authentication.fromJson(auth);
    }
    var userDetails = await loggedUserDetails();
    var authentication =
        Authentication.withAuthorities([userDetails.role?.value]);
    await localStorage.setJson(
        LocalStorageKeys.authentication, authentication.toJson());
    return authentication;
  }

  Future<void> logout() async {
    var platform = await localStorage.getString(LocalStorageKeys.loginProvider);
    await localStorage.clear();
    if (platform == 'google' && await _googleSignIn.isSignedIn()) {
      await _googleSignIn.disconnect();
    }
    if (platform == 'facebook') {
      await FacebookAuth.i.logOut();
    }
    isLoggedIn = false;
    loggedUserRole = null;
  }

  Future<void> requestPasswordReset(String email) async {
    await httpService.doPost(
        url: '/user/password/reset/sendConfirmationCode?userName=$email');
  }

  Future<bool> validateOtp(String email, String otp) async {
    var resp = await httpService.doPost(
        url:
            '/user/password/reset/validateCode?userName=$email&confirmationCode=$otp');
    return resp['success'];
  }

  Future<void> resetPassword(PasswordResetRequest request) async {
    await httpService.doPost(
        url: '/user/password/reset', rentXRequest: request);
  }

  Future<LoginResponse> _providerLogin(
      String? accessToken, String provider) async {
    await localStorage.setString(LocalStorageKeys.loginProvider, provider);
    final LoginResponse loginResponse = LoginResponse.fromJson(
        await httpService.doPost(
            url: '/user/signIn/$provider',
            rentXRequest: ExternalLoginRequest(accessToken!)));

    await localStorage.setString(LocalStorageKeys.authKey, loginResponse.token);
    return loginResponse;
  }
}
