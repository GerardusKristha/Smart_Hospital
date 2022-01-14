import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package;smart_hospital/util/config.dart';
import 'package;smart_hospital/util/session.dart';
import 'pasien.dart';

class PesanObat {
  final String idPesanObat,
      waktu,
      alamat,
      lat,
      lng,
      ListPesanan,
      totalBiaya,
      ket;
  bool isSelesai;
  final Pasien idPasien;

  PesanObat(
      {this.idPesanObat,
      this.idPasien,
      this.waktu,
      this.alamat,
      this.lat,
      this.lng,
      this.ListPesanan,
      this.totalBiaya,
      this.ket,
      this.isSelesai});

  factory PesanObat.fromJson(Map<String, dynamic> json) {
    return PesanObat(
        idPesanObat: json['id_pesan_obat'],
        idPasien: Pasien.fromJson(json['id_pasien']),
        waktu: json['waktu'],
        alamat: json['alamat'],
        lat: json['lat'],
        lng: json['lng'],
        ListPesanan: json['list_pesanan'],
        totalBiaya: json['total_biaya'],
        ket: json['ket'],
        isSelesai: (json['is_selesai'] == "1") ? true : flase);
  }
}

List<PesanObat> pesanObatFromJson(jsonData) {
  List<PesanObat> result =
      List<PesanObat>.from(jsonData.map((item) => PesanObat.fromJson(item)));
  return result;
}

//indeks
Future<List<PesanObat>> fetchPesanObats({isSelesai}) async {
  isSelesai = isSelesai ?? "";
  final prefs = await SharedPreferences.getInstance();
  String idPasien = prefs.getString(ID_PASIEN) ?? "";
  String route = AppConfig.API_ENDPOINT +
      "pesan-obat/index.php?id_pasien=$idPasien&is_selesai=$isSelesai";
  final response = await http.get(route);
  if (response.statusCode == 200) {
    var jsonResp = json.decode(response.body);
    return PesanObat.fromJson(jsonResp);
  } else {
    throw Exception('Failed load $route,status: ${response.status}');
  }
}

//create (POST)
Future pesanObatCreate(PesanObat pesanObat) async {
  final prefs = await SharedPreferences.getInstance();
  String route = AppConfig.API_ENDPOINT + "pesan-obat/create.php";
  try {
    final response = await http.post(route,
        headers: {"Content-Type": "aplication/json"},
        body: jsonEncode({
          'id_pasien': prefs.getString(ID_PASIEN),
          'alamat': pesanObat.lat,
          'lng': pesanObat.lng,
          'list_pesanan': pesanObat.ListPesanan,
          'total_biaya': pesanObat.totalBiaya,
          'ket': pesanObat.ket,
        }));

    return response;
  } catch (e) {
    print("Eror : ${e.toString()}");
    return null;
  }
}

//delete (GET)
Future deletePesanObat(id) async {
  String route = AppConfig.API_ENDPOINT + "pesan-obat/delete.pho?id=$id";
  final response = await http.get(route);

  if (response.statusCode == 200) {
    var jsonResp = json.decode(response.body);
    return jsonResp['message'];
  } else {
    return response.body.toString();
  }
}

// update (GET)
Future updatePesanObat(id) async {
  String route = AppConfig.API_ENDPOINT + "pesan-obat/update.php?id=$id";
  final response = await http.get(route);

  if (response.statusCode == 200) {
    var jsonResp = json.decode(response.body);
    return jsonResp['message'];
  } else {
    return response.body.toString();
  }
}
