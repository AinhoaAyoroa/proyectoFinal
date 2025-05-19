import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/producto_provider.dart';
import 'providers/carrito_provider.dart';
import 'providers/aditivo_provider.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/carrito_screen.dart';

void main() {
  runApp(const LantojitosApp());
}

class LantojitosApp extends StatelessWidget {
  const LantojitosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductoProvider()),
        ChangeNotifierProvider(create: (_) => CarritoProvider()),
        ChangeNotifierProvider(create: (_) => AditivoProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: Colors.deepPurple,
        ),
        initialRoute: HomeScreen.routeName,
        routes: {
          HomeScreen.routeName: (_) => const HomeScreen(),
          ProductDetailScreen.routeName: (_) => const ProductDetailScreen(),
          CarritoScreen.routeName: (_) => const CarritoScreen(),
        },
      ),
    );
  }
}
