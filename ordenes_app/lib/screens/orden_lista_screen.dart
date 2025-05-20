import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pedido_provider.dart';
import 'orden_detalle_screen.dart';

class OrdenListaScreen extends StatelessWidget {
  const OrdenListaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<PedidoProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos Pendientes')),
      body: Builder(
        builder: (_) {
          if (prov.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (prov.error != null) {
            return Center(child: Text('Error: ${prov.error}'));
          }
          if (prov.pedidos.isEmpty) {
            return const Center(child: Text('No hay pedidos pendientes'));
          }
          return RefreshIndicator(
            onRefresh: () => context.read<PedidoProvider>().fetchPedidos(),
            child: ListView.separated(
              itemCount: prov.pedidos.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, i) {
                final p = prov.pedidos[i];
                return ListTile(
                  title: Text('Pedido #${p.id}'),
                  subtitle: Text(
                    'Total: ${p.precioTotal.toStringAsFixed(2)} €\n${p.fecha}',
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrdenDetalleScreen(pedido: p),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
