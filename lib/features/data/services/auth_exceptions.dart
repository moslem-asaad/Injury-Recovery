
// login Exceptions
class UserNotFoundAuthException implements Exception{

  @override
  String toString() {
    return 'user not found';
  }
  
}

class WrongPasswordAuthException implements Exception{
  @override
  String toString() {
    return 'Wrong Email Or Password';
  }
}

// register Exceptions
class WeakPasswordAuthException implements Exception{}

class EmailAlreadyInUseAuthException implements Exception{}

class InvalidEmailAuthException implements Exception{}

// generic Exceptions
class GenericAuthException implements Exception{
  @override
  String toString() {
    return 'Authintication Error';
  }
}

class UserNotLoggedInAuthException implements Exception{}

class MissingEmailAuthException implements Exception{}

class RegisterFailedException implements Exception{}




