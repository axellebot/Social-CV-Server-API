import 'dart:async';

import 'package:angel_framework/angel_framework.dart';
import 'package:angel_orm/angel_orm.dart';
import 'package:meta/meta.dart';
import 'package:social_cv_api/src/models/models.dart';

final _rgxBearer = RegExp(r'^[Bb]earer ([^\n\s]+)$');

class AuthorizationMiddleware {
  const AuthorizationMiddleware({@required this.executor})
      : assert(executor != null, 'No $QueryExecutor given');

  final QueryExecutor executor;

  RequestHandler get requireAuth => chain([
        requireToken,
        authenticate,
      ]);

  FutureOr<bool> requireToken(RequestContext req, ResponseContext res) async {
    final String authorizationToken =
        req.headers.value('authorization')?.replaceAll(_rgxBearer, '')?.trim();

    if (authorizationToken == null) {
      throw AngelHttpException.forbidden();
    }

    req.params['authenticationToken'] = authorizationToken;

    return true;
  }

  FutureOr<bool> authenticate(RequestContext req, ResponseContext res) async {
    final authorizationToken = req.params['authenticationToken'] as String;
    final q = AuthTokenQuery()..where.token.equals(authorizationToken);

    final authToken = await q.getOne(executor);

    if (authToken == null) {
      throw AngelHttpException.badRequest();
    }

    req.params['authenticatedUser'] = authToken.user;
    req.params['authenticatedClient'] = authToken.client;

    return true;
  }
}
