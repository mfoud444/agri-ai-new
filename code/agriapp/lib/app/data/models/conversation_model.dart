class Conversation {
  String? id;
  String? userId;
  String? title;
  String? createdAt;
  String? updatedAt;
  String? type;
  bool? isPin;
  dynamic isLike;
  bool? isEdit;
  bool? isFavorite;
  List<Question>? question;

  Conversation(
      {this.id,
      this.userId,
      this.title,
      this.createdAt,
      this.updatedAt,
      this.type,
      this.isPin,
      this.isLike,
      this.isEdit,
      this.isFavorite,
      this.question});

  Conversation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    type = json['type'];
    isPin = json['is_pin'];
    isLike = json['is_like'];
    isEdit = json['is_edit'];
    isFavorite = json['is_favorite'];
    if (json['question'] != null) {
      question = <Question>[];
      json['question'].forEach((v) {
        question?.add(Question.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['title'] = title;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['type'] = type;
    data['is_pin'] = isPin;
    data['is_like'] = isLike;
    data['is_edit'] = isEdit;
    data['is_favorite'] = isFavorite;
    if (question != null) {
      data['question'] = question?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Question {
  String? id;
  String? conversationId;
  String? content;
  String? createdAt;
  String? updatedAt;
  List<QuestionMedia>? questionMedia;
  List<Answer>? answer;

  Question(
      {this.id,
      this.conversationId,
      this.content,
      this.createdAt,
      this.updatedAt,
      this.questionMedia,
      this.answer});

  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    conversationId = json['conversation_id'];
    content = json['content'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['question_media'] != null) {
      questionMedia = <QuestionMedia>[];
      json['question_media'].forEach((v) {
        questionMedia?.add(QuestionMedia.fromJson(v));
      });
    }
    if (json['answer'] != null) {
      answer = <Answer>[];
      json['answer'].forEach((v) {
        answer?.add(Answer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['conversation_id'] = conversationId;
    data['content'] = content;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (questionMedia != null) {
      data['question_media'] = questionMedia?.map((v) => v.toJson()).toList();
    }
    if (answer != null) {
      data['answer'] = answer?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuestionMedia {
  String? id;
  String? questionId;
  String? mediaUrl;
  String? mediaType;
  String? createdAt;
  String? updatedAt;

  QuestionMedia(
      {this.id,
      this.questionId,
      this.mediaUrl,
      this.mediaType,
      this.createdAt,
      this.updatedAt});

  QuestionMedia.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionId = json['question_id'];
    mediaUrl = json['media_url'];
    mediaType = json['media_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['question_id'] = questionId;
    data['media_url'] = mediaUrl;
    data['media_type'] = mediaType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Answer {
  String? id;
  String? questionId;
  String? content;
  bool? isLoading;
  bool? isError;
  dynamic isLike;
  String? status;
  String? createdAt;
  String? updatedAt;
  List<AnswerMedia>? answerMedia;

  Answer(
      {this.id,
      this.questionId,
      this.content,
      this.isLoading,
      this.isError,
      this.isLike,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.answerMedia});

  Answer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionId = json['question_id'];
    content = json['content'];
    isLoading = json['isLoading'];
    isError = json['is_error'];
    isLike = json['is_like'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['answer_media'] != null) {
      answerMedia = <AnswerMedia>[];
      json['answer_media'].forEach((v) {
        answerMedia?.add(AnswerMedia.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['question_id'] = questionId;
    data['content'] = content;
    data['isLoading'] = isLoading;
    data['is_error'] = isError;
    data['is_like'] = isLike;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (answerMedia != null) {
      data['answer_media'] = answerMedia?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AnswerMedia {
  String? id;
  String? answerId;
  String? mediaUrl;
  String? mediaType;
  String? createdAt;
  String? updatedAt;

  AnswerMedia(
      {this.id,
      this.answerId,
      this.mediaUrl,
      this.mediaType,
      this.createdAt,
      this.updatedAt});

  AnswerMedia.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    answerId = json['answer_id'];
    mediaUrl = json['media_url'];
    mediaType = json['media_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['answer_id'] = answerId;
    data['media_url'] = mediaUrl;
    data['media_type'] = mediaType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
