import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:git_explorer/models/Repository.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'detailsPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  final _warningBox = TextEditingController();
  final _output = TextEditingController();
  var repos = new List<Repository>();
  bool error = false;

  void _SearchRepo() async {
    FocusScope.of(context).unfocus();
    if (_controller.text.trim().length > 0) {
      var url = 'https://api.github.com/repos/${_controller.text.trim()}';
      _controller.text = '';
      try {
        var response = await http.get(url);
        var jsonResponse = convert.jsonDecode(response.body);
        setState(() {
          if (response.statusCode == 200) {
            Repository repo = Repository(
                name: jsonResponse['name'],
                fullName: jsonResponse['full_name'],
                description: jsonResponse['description'],
                starts: jsonResponse['stargazers_count'],
                issues: jsonResponse['open_issues_count'],
                owner: jsonResponse['owner']['url']);
            print(containsRepo(repo.name));
            if (!containsRepo(repo.name)) {
              repos.add(repo);
            } else {
              showError('Este repositório já está na sua lista.');
            }
          } else {
            showError('Nenhum Repositório encontrado.');
          }
        });
        // _output.text = repos[1].toJson().toString();
      } catch (ex) {
        setState(() {
          _output.text = ex.toString();
        });
      }
    }
  }

  void showError(String message, { time: 2 }) {
    setState(() {
      _warningBox.text = '${message}';
      error = true;
      Future.delayed(Duration(seconds: time), () {
        setState(() {
          error = false;
        });
      });
    });
  }

  bool containsRepo(String repo_name) {
    if ((repos.singleWhere((it) => it.name == repo_name, orElse: () => null)) !=
        null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          padding: EdgeInsets.only(top: 40, left: 20, right: 20),
          color: Colors.white,
          child: ListView(
            children: [
              SizedBox(
                height: 100,
                child: Image.asset("assets/logo.png"),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: TextField(
                        controller: _controller,
                        //unform/unform
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            labelText: 'repositório/projeto',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black45,
                                fontSize: 20)),
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 45,
                        width: 45,
                        child: FlatButton(
                          onPressed: () => _SearchRepo(),
                          padding: EdgeInsets.all(0),
                          child: Icon(
                            Icons.search,
                            size: 35,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              error
                  ? Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    _warningBox.text,
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              )
                  : SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      repos.length > 0
                          ? repos.length > 1
                          ? '${repos.length} Repositórios'
                          : '1 Repositório'
                          : ' ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              ListView.builder(
                itemCount: repos.length,
                shrinkWrap: true,
                itemBuilder: (ctx, ind) => Container(
                  height: 80,
                  margin: EdgeInsets.only(bottom: 5),
                  padding: EdgeInsets.only(
                    left: 10,
                    top: 6,
                    bottom: 6,
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xfff0f2f5),
                      border: Border.all(width: 0.5),
                      borderRadius: BorderRadius.all(
                        Radius.circular(7),
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Projeto:',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 67,
                              ),
                              Text(repos[ind].name == null
                                  ? 'null'
                                  : repos[ind].name),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Issues:',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 70,
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Text('${repos[ind].issues} '),
                                    Icon(
                                      Icons.file_copy,
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Stars:',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 78,
                              ),
                              Text('${repos[ind].starts} '),
                              Icon(
                                Icons.star,
                                size: 15,
                              ),
                            ],
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            child: FlatButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsPage(
                                      repos[ind],
                                    ),
                                  ),
                                );
                              },
                              padding: EdgeInsets.all(0),
                              child: Icon(
                                Icons.keyboard_arrow_right,
                                size: 35,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}