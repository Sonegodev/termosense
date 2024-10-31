
import 'package:shared_preferences/shared_preferences.dart';

const idUser = "id";
const token = "token";
const nivel = "nivel";

class GetId {
  final SharedPreferences usuario;

  GetId(this.usuario);

  Future<void> gravarId(int value) async {
    await usuario.setInt(idUser, value);
  }


int pegarId() {
  return usuario.getInt(idUser) ?? 0;
}

String pegarToken() {
  return usuario.getString(token) ?? "";
}

Future<void> gravarToken(String value) async {
  await usuario.setString(token, value);
}

Future<void> gravarNivel(String value) async {
  await usuario.setString(nivel, value);
}

String pegarNivel() {
  return usuario.getString(nivel) ?? "";
 }
} 