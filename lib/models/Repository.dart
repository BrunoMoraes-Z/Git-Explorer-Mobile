class Repository {
  String name;
  String fullName;
  String description;
  int starts;
  int issues;

  String owner;

  Repository(
      {this.name, this.fullName, this.description, this.starts, this.issues, this.owner});

  Repository.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    fullName = json['full_name'];
    description = json['description'];
    starts = json['stargazers_count'];
    issues = json['open_issues_count'];
    owner = json['owner']['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['full_name'] = this.fullName;
    data['description'] = this.description;
    data['stargazers_count'] = this.starts;
    data['open_issues_count'] = this.issues;
    data['owner'] = this.owner;
    return data;
  }
}