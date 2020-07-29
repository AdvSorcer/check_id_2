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
        body: MyBody(),
      ),
    );
  }
}

class MyBody extends StatefulWidget {
  @override
  _MyBodyState createState() => _MyBodyState();
}

class _MyBodyState extends State<MyBody> {
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
          return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data.result.records.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 50,
                  child: Center(
                    child: Card(
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        child: Container(
                          width: 200,
                          height: 50,
                          child: Center(
                            child: Text(
                                snapshot.data.result.records[index].lineId),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }
}
