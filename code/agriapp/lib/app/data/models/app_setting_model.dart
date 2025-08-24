class AppSetting {
  DefaultAiModel? defaultAiModel;
  String? defaultMessage;
  String? termsOfUseUrl;
  String? privacyPolicyUrl;
  String? urlGooglplay;
  String? urlAppstore;
  String? urlFacebook;
  String? urlYoutube;
  String? urlWhatsapp;
  String? email;
  String? urlInstagram;
  String? urlTiktok;
  String? phonenumber;
  String? createdAt;
  String? updatedAt;

  AppSetting(
      {this.defaultAiModel,
      this.defaultMessage,
      this.termsOfUseUrl,
      this.privacyPolicyUrl,
      this.urlGooglplay,
      this.urlAppstore,
      this.urlFacebook,
      this.urlYoutube,
      this.urlWhatsapp,
      this.email,
      this.urlInstagram,
      this.urlTiktok,
      this.phonenumber,
      this.createdAt,
      this.updatedAt});

  AppSetting.fromJson(Map<String, dynamic> json) {
    defaultAiModel = json['default_ai_model'] != null
        ? DefaultAiModel?.fromJson(json['default_ai_model'])
        : null;
    defaultMessage = json['default_message'];
    termsOfUseUrl = json['terms_of_use_url'];
    privacyPolicyUrl = json['privacy_policy_url'];
    urlGooglplay = json['url_googlplay'];
    urlAppstore = json['url_appstore'];
    urlFacebook = json['url_facebook'];
    urlYoutube = json['url_youtube'];
    urlWhatsapp = json['url_whatsapp'];
    email = json['email'];
    urlInstagram = json['url_instagram'];
    urlTiktok = json['url_tiktok'];
    phonenumber = json['phonenumber'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (defaultAiModel != null) {
      data['default_ai_model'] = defaultAiModel?.toJson();
    }
    data['default_message'] = defaultMessage;
    data['terms_of_use_url'] = termsOfUseUrl;
    data['privacy_policy_url'] = privacyPolicyUrl;
    data['url_googlplay'] = urlGooglplay;
    data['url_appstore'] = urlAppstore;
    data['url_facebook'] = urlFacebook;
    data['url_youtube'] = urlYoutube;
    data['url_whatsapp'] = urlWhatsapp;
    data['email'] = email;
    data['url_instagram'] = urlInstagram;
    data['url_tiktok'] = urlTiktok;
    data['phonenumber'] = phonenumber;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class DefaultAiModel {
  String? id;
  String? companyId;
  Company? company;
  String? name;
  String? modelCode;
  String? description;
  bool? isActivate;
  String? version;
  List<String>? inputData;
  List<String>? outputData;
  int? maxTokens;
  double? temperature;
  double? topP;
  int? topK;
  int? repetitionPenalty;
  List<String>? stop;
  bool? stream;
  String? createdAt;
  String? updatedAt;

  DefaultAiModel(
      {this.id,
      this.companyId,
      this.company,
      this.name,
      this.modelCode,
      this.description,
      this.isActivate,
      this.version,
      this.inputData,
      this.outputData,
      this.maxTokens,
      this.temperature,
      this.topP,
      this.topK,
      this.repetitionPenalty,
      this.stop,
      this.stream,
      this.createdAt,
      this.updatedAt});

  DefaultAiModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    company =
        json['company'] != null ? Company?.fromJson(json['company']) : null;
    name = json['name'];
    modelCode = json['model_code'];
    description = json['description'];
    isActivate = json['is_activate'];
    version = json['version'];
    inputData = json['input_data']?.cast<String>();
    outputData = json['output_data']?.cast<String>();
    maxTokens = json['max_tokens'];
    temperature = (json['temperature'] as num?)?.toDouble();
    topP = (json['top_p'] as num?)?.toDouble();
    topK = json['top_k'];
    repetitionPenalty = json['repetition_penalty'];
    stop = json['stop']?.cast<String>();
    stream = json['stream'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['company_id'] = companyId;
    if (company != null) {
      data['company'] = company?.toJson();
    }
    data['name'] = name;
    data['model_code'] = modelCode;
    data['description'] = description;
    data['is_activate'] = isActivate;
    data['version'] = version;
    data['input_data'] = inputData;
    data['output_data'] = outputData;
    data['max_tokens'] = maxTokens;
    data['temperature'] = temperature;
    data['top_p'] = topP;
    data['top_k'] = topK;
    data['repetition_penalty'] = repetitionPenalty;
    data['stop'] = stop;
    data['stream'] = stream;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Company {
  String? id;
  String? name;
  String? companyUrl;
  String? logoUrl;
  String? apiUrl;
  bool? isActivate;
  String? apiKey;
  String? createdAt;
  String? updatedAt;

  Company(
      {this.id,
      this.name,
      this.companyUrl,
      this.logoUrl,
      this.apiUrl,
      this.isActivate,
      this.apiKey,
      this.createdAt,
      this.updatedAt});

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    companyUrl = json['company_url'];
    logoUrl = json['logo_url'];
    apiUrl = json['api_url'];
    isActivate = json['is_activate'];
    apiKey = json['api_key'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['company_url'] = companyUrl;
    data['logo_url'] = logoUrl;
    data['api_url'] = apiUrl;
    data['is_activate'] = isActivate;
    data['api_key'] = apiKey;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
