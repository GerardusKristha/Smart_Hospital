import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_hospital/util/config.dart';

class Obat {
  final String idObat, nama, harga, satuan;
  bool isSelected;
  int jumlah;
  Obat(
    {this.idObat,this.nama,this.harga,this.satuan,this.isSelected = false, ,this.jumlah});
    factory Obat.fromJson(Map<String, dynamic>json){
      return Obat (
        idObat: json['id_obat'],nama: json['nama'], harga: json['harga'], satuan: json['satuan']);
    }
}

List <Obat> obatFromJson (jsonData){
  List<Obat> result = 
    List<Obat>.from(jsonData.map((item)=> Obat.fromJson(item)));
    return result;
}

//index
Furute<List<Obat>> fecthObats() async {
 String route = AppConfig.API_ENDPOINT + "obat/index.php";
  final response = await http.get(route);

  if (response.statusCode==200) {
    var jsonResp = json.decode(response.body);
    return obatFromJson(jsonResp);
  }
  else {
    throw Exception(' Failed load $route,status : ${response.statusCode}');
  }
}