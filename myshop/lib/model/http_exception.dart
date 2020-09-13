// implements Exception means:
/// we have to implement function in Exception class
class HttpException implements Exception {
  // this class handle what we want to do if there is error
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
    // return super.toString(); // instance of HttpException
  }
}