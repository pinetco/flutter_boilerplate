class APIDataClass {
  bool isSuccess;
  dynamic data;
  String? message;
  bool? validation;

  APIDataClass({required this.isSuccess, this.data, this.message, this.validation});

  factory APIDataClass.fromJson(Map<String, dynamic> json) {
    return APIDataClass(
      message: json['message'] as String?,
      isSuccess: json['isSuccess'] as bool,
      data: json['data'] as String?,
      validation: json['validation'] as bool?,
    );
  }
}
