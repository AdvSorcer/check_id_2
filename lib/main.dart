import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'bad_ids.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text(
              '帳號顯示',
            ),
          ),
          body: Home()),
    );
  }
}

//widget 1
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String queryString = "";

  void update(String qs) {
    setState(() {
      queryString = qs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          onChanged: (text) {
            print("First text field: $text");
            update(text);
          },
          decoration: InputDecoration(
            hintText: "請輸入查詢ＩＤ",
            contentPadding: EdgeInsets.only(left: 30),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text("以下是被通報的所有詐騙ＩＤ"),
        MyBody(
          queryString: queryString,
        ),
      ],
    );
  }
}

// widget 2
class MyBody extends StatefulWidget {
  final String queryString;
  MyBody({this.queryString});

  @override
  _MyBodyState createState() => _MyBodyState();
}

class _MyBodyState extends State<MyBody> {
  String searchString = "";

  //TODO : init
  Future<Welcome> fetchBadIds() async {
    try {
      Response response = await Dio().get(
          "https://od.moi.gov.tw/api/v1/rest/datastore/A01010000C-001277-053");
      if (response.statusCode == 200) {
        return Welcome.fromJson(response.data);
      }
    } catch (e) {
      print("錯誤$e");
    }
  }

  Future<Welcome> futureBadIds;

  @override
  void initState() {
    super.initState();
    futureBadIds = fetchBadIds();
  }

  @override
  Widget build(BuildContext context) {
    String queryStr = "";
    queryStr = widget.queryString;
    return FutureBuilder<Welcome>(
      future: futureBadIds,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //copy a snapshot
          List _newss = snapshot.data.result.records.sublist(0);
          _newss.sort((a, b) =>
              a.lineId.toLowerCase().compareTo(b.lineId.toLowerCase()));
          _newss = _newss.where((e) => e.lineId.contains(queryStr)).toList();
          int aa = _newss.length;
          int bb = snapshot.data.result.records.length;
          //print(aa.toString() + " :" + bb.toString());

          return Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _newss.length,
                itemBuilder: (BuildContext context, int index) {
                  String _lineId = _newss[index].lineId;
                  String _alertDate = _newss[index].alertDate;
                  return Column(
                    children: <Widget>[
                      Center(
                        child: ListTile(
                            title: Text(_lineId),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Text(_alertDate),
                              ],
                            )),
                      ),
                      Divider(
                        color: Colors.grey,
                        height: 10,
                        thickness: 2,
                      ),
                    ],
                  );
                }),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }
}
