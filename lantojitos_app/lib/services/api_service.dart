// lib/services/api_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/producto.dart';
import '../models/aditivo.dart';

class ApiService {
  static String get _baseUrl {
    if (kIsWeb) return 'http://localhost:8080';
    return 'http://10.0.2.2:8080';
  }

  static Future<List<Producto>> fetchProductos() async {
    final uri = Uri.parse('$_baseUrl/api/productos');
    final resp = await http.get(uri);
    if (resp.statusCode == 200) {
      final jsonString = utf8.decode(resp.bodyBytes);
      final data = json.decode(jsonString) as List<dynamic>;
      return data
          .map((e) => Producto.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Error ${resp.statusCode} fetching productos');
  }

  static Future<Producto> fetchProductoById(int id) async {
    final uri = Uri.parse('$_baseUrl/api/productos/$id');
    final resp = await http.get(uri);
    if (resp.statusCode == 200) {
      final jsonString = utf8.decode(resp.bodyBytes);
      return Producto.fromJson(json.decode(jsonString) as Map<String, dynamic>);
    }
    throw Exception('Producto no encontrado');
  }

  static Future<List<Aditivo>> fetchAditivos() async {
    final uri = Uri.parse('$_baseUrl/api/aditivos');
    final resp = await http.get(uri);
    if (resp.statusCode == 200) {
      final jsonString = utf8.decode(resp.bodyBytes);
      final data = json.decode(jsonString) as List<dynamic>;
      return data
          .map((e) => Aditivo.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Error ${resp.statusCode} fetching aditivos');
  }

  static Future<void> createPedido(List<Map<String, dynamic>> detalles) async {
    final double total = detalles.fold<double>(0, (sum, d) {
      final double precioBase = d['precio'] as double;
      final double costoExtra = d['costoExtra'] as double;
      final int cantidad = d['cantidad'] as int;
      return sum + (precioBase + costoExtra) * cantidad;
    });

    final body = json.encode({
      'fecha': DateTime.now().toIso8601String(),
      'estado': 'PENDIENTE',
      'precioTotal': total,
      'detalles': detalles,
    });

    final resp = await http.post(
      Uri.parse('$_baseUrl/api/pedidos'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw Exception('Error creando pedido: ${resp.statusCode}');
    }
  }
}
