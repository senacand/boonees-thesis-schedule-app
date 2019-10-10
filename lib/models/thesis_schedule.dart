import 'dart:convert';
import 'package:intl/intl.dart';

List<ThesisSchedule> thesisScheduleFromJson(String str) {
  final jsonData = json.decode(str);
  return List<ThesisSchedule>
      .from(jsonData.map((x) => ThesisSchedule.fromJson(x)))
      ..sort((a, b) => b.getStartDate().compareTo(a.getStartDate()));
}

String thesisScheduleToJson(List<ThesisSchedule> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

class ThesisSchedule {
  String priod;
  String kdSem;
  String nimhs;
  String nmmhs;
  String kelas;
  String kelompok;
  String nmTopik;
  String tanggal;
  String kampus;
  String ruang;
  String judul;
  String jamml;
  String jamsl;
  String stsrc;

  ThesisSchedule({
    this.priod,
    this.kdSem,
    this.nimhs,
    this.nmmhs,
    this.kelas,
    this.kelompok,
    this.nmTopik,
    this.tanggal,
    this.kampus,
    this.ruang,
    this.judul,
    this.jamml,
    this.jamsl,
    this.stsrc,
  });

  factory ThesisSchedule.fromJson(Map<String, dynamic> json) => new ThesisSchedule(
    priod: json["Priod"],
    kdSem: json["KdSem"],
    nimhs: json["nimhs"],
    nmmhs: json["nmmhs"],
    kelas: json["kelas"],
    kelompok: json["kelompok"],
    nmTopik: json["nm_topik"],
    tanggal: json["tanggal"],
    kampus: json["kampus"],
    ruang: json["ruang"],
    judul: json["judul"],
    jamml: json["jamml"],
    jamsl: json["jamsl"],
    stsrc: json["stsrc"],
  );
  
  String getNim() => nimhs
      .split(" - ")
      .first;

  String getShortStartTime() => jamml.substring(0, 5);
  String getShortEndTime() => jamsl.substring(0, 5);

  String getShortThesisTitle(int length) => judul.trim().length <= length+3 ? judul.trim() : judul.substring(0, length) + "...";

  DateTime getStartDate() {
    final formatter = DateFormat("d MMM yyyy HH:mm:ss");
    return formatter.parse("${tanggal} ${jamml}");
  }

  DateTime getEndDate() {
    final formatter = DateFormat("d MMM yyyy HH:mm:ss");
    return formatter.parse("${tanggal} ${jamsl}");
  }

  Map<String, dynamic> toJson() => {
    "Priod": priod,
    "KdSem": kdSem,
    "nimhs": nimhs,
    "nmmhs": nmmhs,
    "kelas": kelas,
    "kelompok": kelompok,
    "nm_topik": nmTopik,
    "tanggal": tanggal,
    "kampus": kampus,
    "ruang": ruang,
    "judul": judul,
    "jamml": jamml,
    "jamsl": jamsl,
    "stsrc": stsrc,
  };
}
