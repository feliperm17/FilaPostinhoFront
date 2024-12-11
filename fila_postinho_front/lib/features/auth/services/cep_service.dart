import 'dart:convert';
import 'package:http/http.dart' as http;

class CepService {
  static Future<Map<String, dynamic>?> fetchAddress(String cep) async {
    try {
      final cleanCep = cep.replaceAll(RegExp(r'[^0-9]'), '');
      if (cleanCep.length != 8) return null;

      final response = await http.get(
        Uri.parse('https://viacep.com.br/ws/$cleanCep/json/'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['erro'] == true) return null;

        return {
          'street': data['logradouro'],
          'neighborhood': data['bairro'],
          'city': data['localidade'],
          'state': data['uf'],
          'country': 'Brasil',
        };
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
