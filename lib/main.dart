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
        body: Column(
          children: <Widget>[
            TextField(
              onChanged: (text) {
                print("First text field: $text");
              },
            ),
            RaisedButton(
              child: Text('Button'),
              onPressed: () {
                print('you push me');
              },
            ),
            MyBody(),
          ],
        ),
      ),
    );
  }
}

class MyBody extends StatefulWidget {
  //MyBody({this.lineid3});
  //String lineid3;
  @override
  _MyBodyState createState() => _MyBodyState();
}

class _MyBodyState extends State<MyBody> {
  //_MyBodyState({this.lineid2});
  //String lineid2;

  //String searchString = "1234";

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
    return FutureBuilder<Welcome>(
      future: futureBadIds,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //copy a snapshot
          List _newss = snapshot.data.result.records.sublist(0);
          _newss.sort((a, b) =>
              a.lineId.toLowerCase().compareTo(b.lineId.toLowerCase()));
          _newss = _newss.where((e) => e.lineId.contains("123")).toList();
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
