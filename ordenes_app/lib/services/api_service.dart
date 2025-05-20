import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/pedido.dart';

class ApiService {
  static String get _baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080';
    }
    return 'http://localhost:8080';
  }

  static Future<List<Pedido>> fetchPendingPedidos() async {
    final uri = Uri.parse('$_baseUrl/api/pedidos?estado=PENDIENTE');
    final resp = await http.get(uri).timeout(const Duration(seconds: 5));

    if (resp.statusCode == 200) {
      final jsonString = utf8.decode(resp.bodyBytes);
      final data = json.decode(jsonString) as List<dynamic>;
      return data
          .map((e) => Pedido.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Error ${resp.statusCode} cargando pedidos');
    }
  }

  static Future<void> finalizePedido(int id) async {
    final resp = await http.patch(
      Uri.parse('$_baseUrl/api/pedidos/$id/estado?nuevo=FINALIZADO'),
    );
    if (resp.statusCode != 200) {
      throw Exception('Error ${resp.statusCode} finalizando pedido');
    }
  }
}
