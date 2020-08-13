// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Welcome({
    this.success,
    this.result,
  });

  bool success;
  Result result;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        success: json["success"],
        result: Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "result": result.toJson(),
      };
}

class Result {
  Result({
    this.resourceId,
    this.limit,
    this.total,
    this.fields,
    this.records,
  });

  String resourceId;
  int limit;
  int total;
  List<Field> fields;
  List<Record> records;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        resourceId: json["resource_id"],
        limit: json["limit"],
        total: json["total"],
        fields: List<Field>.from(json["fields"].map((x) => Field.fromJson(x))),
        records:
            List<Record>.from(json["records"].map((x) => Record.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "resource_id": resourceId,
        "limit": limit,
        "total": total,
        "fields": List<dynamic>.from(fields.map((x) => x.toJson())),
        "records": List<dynamic>.from(records.map((x) => x.toJson())),
      };
}

class Field {
  Field({
    this.type,
    this.id,
  });

  String type;
  String id;

  factory Field.fromJson(Map<String, dynamic> json) => Field(
        type: json["type"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
      };
}

class Record {
  Record({
    this.no,
    this.lineId,
    this.alertDate,
  });

  String no;
  String lineId;
  String alertDate;

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        no: json["no"],
        lineId: json["line id"],
        alertDate: json["alert date"],
      );

  Map<String, dynamic> toJson() => {
        "no": no,
        "line id": lineId,
        "alert date": alertDate,
      };
}
