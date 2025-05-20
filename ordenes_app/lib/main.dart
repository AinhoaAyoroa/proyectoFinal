import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/pedido_provider.dart';
import 'screens/orden_lista_screen.dart';

void main() => runApp(const OrdersApp());

class OrdersApp extends StatelessWidget {
  const OrdersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PedidoProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gestión de Pedidos',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const OrdenListaScreen(),
      ),
    );
  }
}
