import 'dart:async';

import 'package:angel_framework/angel_framework.dart';
import 'package:social_cv_api/src/config/plugins/oauth.dart';

@Expose('/auth')
class OAuthController extends Controller {
  OAuthAuthorizationServer oauth2;

  @Expose('/authorize', method: 'GET')
  FutureOr authorize() async {
    return oauth2.authorizationEndpoint;
  }

  @Expose('/token', method: 'POST')
  FutureOr token() async {
    return oauth2.tokenEndpoint;
  }
}
