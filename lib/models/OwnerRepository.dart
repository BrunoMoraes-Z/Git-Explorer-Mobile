class OwnerRepository {
  String avatar;
  String name;
  String blog;
  String email;
  String bio;
  int repos;

  OwnerRepository(
      {this.avatar, this.name, this.blog, this.email, this.bio, this.repos});

  OwnerRepository.fromJson(Map<String, dynamic> json) {
    avatar = json['name'];
    name = json['avatar_url'];
    blog = json['blog'];
    email = json['email'];
    bio = json['bio'];
    repos = json['public_repos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar'] = this.avatar;
    data['name'] = this.name;
    data['blog'] = this.blog;
    data['email'] = this.email;
    data['bio'] = this.bio;
    data['repos'] = this.repos;
    return data;
  }
}