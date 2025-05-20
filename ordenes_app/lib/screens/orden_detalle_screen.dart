import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pedido.dart';
import '../providers/pedido_provider.dart';

class OrdenDetalleScreen extends StatelessWidget {
  final Pedido pedido;
  const OrdenDetalleScreen({required this.pedido, super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.read<PedidoProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('Detalle Pedido #${pedido.id}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fecha: ${pedido.fecha}'),
            const SizedBox(height: 8),
            Text('Total: ${pedido.precioTotal.toStringAsFixed(2)} €',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const Divider(height: 32),
            const Text('Líneas de pedido:', style: TextStyle(fontSize: 16)),
            Expanded(
              child: ListView.builder(
                itemCount: pedido.detalles.length,
                itemBuilder: (_, i) {
                  final d = pedido.detalles[i];
                  return ListTile(
                    title: Text('${d.productoNombre} ×${d.cantidad}'),
                    subtitle: Text(
                      'Precio: ${d.precio.toStringAsFixed(2)} €\n'
                      'Extras: ${d.costoExtra.toStringAsFixed(2)} €\n'
                      'Aditivos: ${d.aditivos.map((a) => a.nombre).join(', ')}',
                    ),
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await prov.finalize(pedido.id);
                  Navigator.pop(context);
                },
                child: const Text('Marcar como FINALIZADO'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
