class BaseResponse<T> {
  bool success;
  T? body;
  String? message;

  BaseResponse({required this.success, this.message, this.body});
}
