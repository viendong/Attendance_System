class AuthInvalidCredentialException implements Exception {
  final String message = '[Auth] invalid credential';
  @override
  String toString() {
    return message;
  }
}

class AuthAccountIsExistException implements Exception {
  final String message = '[Auth] account is exist';
  @override
  String toString() {
    return message;
  }
}

class AuthUserDisabledException implements Exception {
  final String message = '[Auth] user is disable';
  @override
  String toString() {
    return message;
  }
}

class AuthUserNotFoundException implements Exception {
  final String message = '[Auth] user not found';
  @override
  String toString() {
    return message;
  }
}

class AuthInvalidCustomTokenException implements Exception {
  final String message = '[Auth] invalid custom token';
  @override
  String toString() {
    return message;
  }
}

class AuthCustomTokenMismatchException implements Exception {
  final String message = '[Auth] custom token mismatch';
  @override
  String toString() {
    return message;
  }
}

class AuthIdTokenEmptyException implements Exception {
  final String message = '[Auth] Id token is required but missing';
  @override
  String toString() {
    return message;
  }
}

class AuthIdTokenInvalidException implements Exception {
  final String message = '[Auth] Id token is required but missing';
  @override
  String toString() {
    return message;
  }
}

class AuthWorkspaceIdEmptyException implements Exception {
  final String message =
      '[Auth] (get custom token) workspace id is required but missing';
  @override
  String toString() {
    return message;
  }
}

class AuthGetCustomTokenException implements Exception {
  final String message = '[Auth] (get custom token) exception';
  @override
  String toString() {
    return message;
  }
}

class AuthTenantIdIsRequiredException implements Exception {
  final String message =
      '[Auth] (get id token with custom token) tenant id missing';
  @override
  String toString() {
    return message;
  }
}

class AuthGetIdTokenNotEnoughParamsException implements Exception {
  final String message = '[Auth] get id token for tenant not enough params';
  @override
  String toString() {
    return message;
  }
}

class AuthSignInWithGoogleException implements Exception {
  final String message = '[Auth] sign in with Google exception';
  @override
  String toString() {
    return message;
  }
}

class AuthSignInWithAppleException implements Exception {
  final String message = '[Auth] sign in with Apple exception';
  @override
  String toString() {
    return message;
  }
}

class AuthGetIdTokenNoneTenantException implements Exception {
  final String message = '[Auth] get id token none tenant exception';
  @override
  String toString() {
    return message;
  }
}

class AuthGetIdTokenTenantException implements Exception {
  final String message = '[Auth] get id token tenant exception';
  @override
  String toString() {
    return message;
  }
}

class AuthGetCustomTokenReturnNullException implements Exception {
  final String message = '[Auth] get custom token return null';
  @override
  String toString() {
    return message;
  }
}

class AuthSignInUserToWorkspaceException implements Exception {
  final String message = '[Auth] sign in user to workspace failed';
  @override
  String toString() {
    return message;
  }
}

class AuthUserNotLogInException implements Exception {
  final String message = '[Auth] User not log in. Please log in!';
  @override
  String toString() {
    return message;
  }
}
