
// login Exceptions
class UserNotFoundAuthException implements Exception{}

class WrongPasswordAuthException implements Exception{}

// register Exceptions
class WeakPasswordAuthException implements Exception{}

class EmailAlreadyInUseAuthException implements Exception{}

class InvalidEmailAuthException implements Exception{}

// generic Exceptions
class GenericAuthException implements Exception{}

class UserNotLoggedInAuthException implements Exception{}

class MissingEmailAuthException implements Exception{}

class RegisterFailedException implements Exception{}

class CategoryAlreadyExistException implements Exception{}
class VideoAlreadyExistException implements Exception{}
class VideoDoesNotExistException implements Exception{}
class CustomerUserDoesNotExistException implements Exception{}
class OneOrMoreExerciseVideoDoesNotExistException implements Exception{}
class TreatmentAlreadyExistException implements Exception{}

class SystemManagerEmailIsNotDefined implements Exception{}




