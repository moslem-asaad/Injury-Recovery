class Response{
  String? errorMessage;
  bool? errorOccured;
  Response(this.errorMessage,this.errorOccured);

   Response.empty() {
    this.errorMessage = null;
    this.errorOccured = false;
  }
}

class ResponseT<T> extends Response{
  T? val ;
  ResponseT(String? errorMessage, bool? errorOccurred) : super(errorMessage, errorOccurred);
  ResponseT.empty(this.val) : super.empty();
  T getVal(){
    return val!;
  }
}
  
