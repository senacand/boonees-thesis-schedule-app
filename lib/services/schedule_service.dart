import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:thesis_schedule/models/thesis_schedule.dart';

class ScheduleService {
  static final instance = ScheduleService();
  final url = "https://binusmaya.binus.ac.id/services/ci/index.php/student/thesis/SearchThesisExamSchedule";

  Future<List<ThesisSchedule>> getSchedules() async {
    try {
      debugPrint("Sending HTTP");
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json, text/javascript, */*; q=0.01",
          "Accept-Encoding": "gzip, deflate, br",
          "Content-Type": "application/json;charset=UTF-8",
          "Host": "binusmaya.binus.ac.id",
          "Referer": "https://binusmaya.binus.ac.id/student/",
          "Origin": "https://binusmaya.binus.ac.id",
          "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36",
        },
        body: json.encode({
          "nim": "%",
          "nama": "%",
          "topic": "%",
          "title": "%",
          "date": "%",
          "time": "%"
        }),
      );
      if(response.statusCode == 200) {
        debugPrint("[200] ${response.body}");
        final schedules = thesisScheduleFromJson(response.body);
        return schedules;
      } else {
        debugPrint("[${response.statusCode}] ${response.body}");
        throw Error();
      }
    } catch (error) {
      debugPrint("ERROR! ${error.toString()}");
      throw error;
    }
  }
}