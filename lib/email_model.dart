class EmailModel {
  String? serviceId;
  String? templateId;
  String? userId;
  String? accessToken;
  TemplateParams? templateParams;

  EmailModel(
      {this.serviceId,
        this.templateId,
        this.userId,
        this.accessToken,
        this.templateParams});

  EmailModel.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    templateId = json['template_id'];
    userId = json['user_id'];
    accessToken = json['accessToken'];
    templateParams = json['template_params'] != null
        ? TemplateParams.fromJson(json['template_params'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_id'] = serviceId;
    data['template_id'] = templateId;
    data['user_id'] = userId;
    data['accessToken'] = accessToken;
    if (templateParams != null) {
      data['template_params'] = templateParams!.toJson();
    }
    return data;
  }
}

class TemplateParams {
  String? fromName;
  String? toName;
  String? message;

  TemplateParams({this.fromName, this.toName, this.message});

  TemplateParams.fromJson(Map<String, dynamic> json) {
    fromName = json['from_name'];
    toName = json['to_name'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['from_name'] = fromName;
    data['to_name'] = toName;
    data['message'] = message;
    return data;
  }
}
