class Issue {
  int id;
  String title;
  String state;
  String owner;

  Issue(
      {this.id, this.title, this.state, this.owner});

  Issue.fromJson(Map<String, dynamic> json) {
    id = json['number'];
    title = json['title'];
    state = json['state'];
    owner = json['user']['login'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.id;
    data['title'] = this.title;
    data['state'] = this.state;
    data['user']['login'] = this.owner;
    return data;
  }
}