import 'package:jemona_deals/models/menu_card.dart';
import 'package:jemona_deals/models/messages.dart';


class ResultData{
  final String status;
  final Messages message;
  final MenuCard mc;

  ResultData({
    this.status,
    this.message,
    this.mc
  });

  factory ResultData.fromJson(Map<String, dynamic> parsedJson){
    return ResultData(
        status:parsedJson['status'],
        message:parsedJson['message'],
        mc: parsedJson["data"] == null ? null : MenuCard.fromJson(parsedJson["data"])
    );
  }

}