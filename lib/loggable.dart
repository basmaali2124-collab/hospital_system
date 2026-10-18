mixin Loggable {
  void log(String message){
    print("${DateTime.now()} : $message  ");
  }
}