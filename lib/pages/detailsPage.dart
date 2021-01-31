import 'package:flutter/material.dart';
import 'package:git_explorer/components/loading.dart';
import 'package:git_explorer/models/Issue.dart';
import 'package:git_explorer/models/OwnerRepository.dart';
import 'package:git_explorer/models/Repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class DetailsPage extends StatefulWidget {
  Repository repository;
  OwnerRepository owner;
  List<Issue> issues;

  DetailsPage(Repository repo) {
    this.repository = repo;
    this.issues = new List();
  }

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  _DetailsPageState() {
    Future.delayed(Duration(seconds: 1), () {
      if (widget.repository != null) {
        getInformation(widget.repository.owner);
      }
    });
    Future.delayed(Duration(seconds: 1), () {
      getIssues(
        buildIssueURL(widget.repository),
      );
    });
  }

  String buildIssueURL(Repository repo, {page: 1, state = 'open'}) {
    return repo == null
        ? ''
        : 'https://api.github.com/repos/${repo.fullName}/issues?per_page=100&state=${state}&page=${page}';
  }

  void getIssues(String url) async {
    if (url != null && url.trim().length > 0) {
      try {
        var response = await http.get(url);
        Iterable l = convert.jsonDecode(response.body);
        if (response.statusCode == 200) {
          List<Issue> posts = List<Issue>.from(
            l.map(
              (model) => Issue.fromJson(model),
            ),
          );
          setState(() {
            widget.issues = posts;
          });
        } else {
          //todo
        }
      } catch (ex) {}
    }
  }

  void getInformation(String url) async {
    if (url != null && url.trim().length > 0) {
      try {
        var response = await http.get(url);
        var jsonResponse = convert.jsonDecode(response.body);
        if (response.statusCode == 200) {
          setState(() {
            widget.owner = OwnerRepository(
              name: jsonResponse['name'],
              avatar: jsonResponse['avatar_url'],
              bio: jsonResponse['bio'],
              blog: jsonResponse['blog'],
              email: jsonResponse['email'],
              repos: jsonResponse['public_repos'],
            );
          });
        } else {
          //todo
        }
      } catch (ex) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget == null ||
        widget.repository == null ||
        widget.owner == null ||
        widget.issues == null) {
      return Loading();
    } else {
      return Scaffold(
        body: Container(
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 50,
                      alignment: Alignment.center,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.keyboard_arrow_left,
                        ),
                      ),
                    ),
                    Container(
                      child: Text('${widget.repository.name}'),
                    ),
                    SizedBox(
                      width: 50,
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      margin: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(100),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(
                            '${widget.owner.avatar}',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 20,
                          right: 25,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Nome',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  widget.owner.name.length > 22
                                      ? '${widget.owner.name.substring(0, 22)}...'
                                      : widget.owner.name,
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Repositórios',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  // '215',
                                  '${widget.owner.repos}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              textDirection: TextDirection.ltr,
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.owner.email == null
                                        ? widget.owner.blog != null
                                            ? widget.owner.blog
                                            : ''
                                        : widget.owner.email,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  child: Text(
                    widget.issues.length > 0
                        ? '${widget.issues.length} Issues'
                        : '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: widget.issues.length > 0 ? 25 : 0,
                ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20, left: 30, right: 30),
                    child: ListView.builder(
                      // itemCount: 10,
                      itemCount: widget.issues.length,
                      itemBuilder: (ctx, ind) => Container(
                        height: 65,
                        margin: EdgeInsets.only(
                          bottom: ind == (widget.issues.length - 1) ? 0 : 5,
                        ),
                        padding: EdgeInsets.only(right: 6, left: 10, top: 5, bottom: 5,),
                        // padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Color(0xfff0f2f5),
                          border: Border.all(
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      widget.issues[ind].title.trim().length >
                                              36
                                          ? '${widget.issues[ind].title.substring(0, 36).trim()}...'
                                          : widget.issues[ind].title.trim(),
                                      style: TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'ID',
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            '${widget.issues[ind].id}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Text(
                                            'Autor:',
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            widget.issues[ind].owner,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  width: 25,
                                  child: FlatButton(
                                    onPressed: () {},
                                    padding: EdgeInsets.all(0),
                                    child: Icon(
                                      Icons.keyboard_arrow_right,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
