import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/carrito_provider.dart';
import '../services/api_service.dart';

class CarritoScreen extends StatelessWidget {
  const CarritoScreen({super.key});
  static const routeName = '/carrito';

  @override
  Widget build(BuildContext context) {
    final carrito = context.watch<CarritoProvider>();
    const assetMap = {
      1: 'lib/img/bocadillo_jamon.png',
      2: 'lib/img/bocadillo_tortilla.png',
      3: 'lib/img/bocadillo_vegetal.jpg',
      4: 'lib/img/bocadillo_atun.jpg',
      5: 'lib/img/bocadillo_pollo.png',
    };

    return Scaffold(
      appBar: AppBar(title: const Text("Carrito de Compras")),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: carrito.items.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, i) {
                final item = carrito.items[i];
                final assetPath = assetMap[item.producto.id]!;
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      assetPath,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image, size: 40),
                    ),
                  ),
                  title: Text(item.producto.nombre),
                  subtitle: Text(
                    "Cant: ${item.cantidad} – Extras: "
                    "${item.seleccionados.map((e) => e.nombre).join(', ')}",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "\$${item.total.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'Eliminar',
                        onPressed: () {
                          context.read<CarritoProvider>().removeProducto(item);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Total: \$${carrito.total.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ElevatedButton(
              onPressed: carrito.items.isEmpty
                  ? null
                  : () async {
                      final detallesJson = carrito.items.map((it) {
                        return {
                          'producto': {'id': it.producto.id},
                          'cantidad': it.cantidad,
                          'precio': it.producto.precioBase,
                          'costoExtra': it.seleccionados
                              .fold<double>(0, (sum, e) => sum + e.precioExtra),
                          'aditivos': it.seleccionados
                              .map((e) => {'id': e.id})
                              .toList(),
                        };
                      }).toList();

                      try {
                        await ApiService.createPedido(detallesJson);
                        carrito.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Pedido confirmado")),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: $e")),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: const Text("Confirmar Pedido"),
            ),
          ),
        ],
      ),
    );
  }
}
