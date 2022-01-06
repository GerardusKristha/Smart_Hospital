import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_hospital/util/config.dart';

class Dokter {
  late final String idDokter, nama, hp;
  Dokter(
    {
      required this.idDokter, required this.nama, required this.hp;
    }
  );

  factory Dokter.fromJson(Map<String, dynamic>json) {
    return Dokter (
      idDokter: json['id_dokter'], nama: json['nama'], hp: json['hp']);
  }
}

List<Dokter> dokterFromJson(jsonData) {
  List<Dokter> result =
    List<Dokter>.from(jsonData.map((item) => Dokter.fromJson(item)));
    return result;
}

//index
Future<List>Dokter>> fetchDokter() async {
  String route = AppConfig.API_ENDPOINT + "dokter/index.php";
  final response = await http.get(route);

  if (response.statusCode==200) {
    var jsonResp = json.decode(response.body);
    return dokterFromJson(jsonResp);
  }
  else {
    throw Exception(' Failed load $route,status : ${response.statusCode}');
  }
}