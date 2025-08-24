class NotificationItem {
  String? id;
  String? title;
  String? icon;
  String? body;
  String? createdAt;
  bool? isRead;

  NotificationItem(
      {this.id, this.title, this.icon, this.body, this.createdAt, this.isRead});

  NotificationItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    icon = json['icon'];
    body = json['body'];
    createdAt = json['createdAt'];
    isRead = json['isRead'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['icon'] = icon;
    data['body'] = body;
    data['createdAt'] = createdAt;
    data['isRead'] = isRead;
    return data;
  }
}
