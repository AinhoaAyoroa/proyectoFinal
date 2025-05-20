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
      6: 'lib/img/mini_tarta_queso.png',
      7: 'lib/img/mini_brownie.png',
      8: 'lib/img/crema_burule.png',
      9: 'lib/img/mini_profiteroles.png',
      10: 'lib/img/mini_mouse_frutos_rojos.png',
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
                final assetPath =
                    assetMap[item.producto.id] ?? 'lib/img/placeholder.jpeg';
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
                    "${(item.seleccionados).map((e) => e.nombre).join(', ')}",
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
                  : () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => _PaymentDialog(
                          total: carrito.total,
                          detalles: carrito.items,
                        ),
                      );
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

class _PaymentDialog extends StatefulWidget {
  final double total;
  final List detalles;
  const _PaymentDialog({
    required this.total,
    required this.detalles,
  });

  @override
  State<_PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<_PaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titularCtrl = TextEditingController();
  final _numeroCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  int? _mes;
  int? _ano;
  bool _processing = false;

  bool get _isFormValid =>
      (_formKey.currentState?.validate() ?? false) &&
      _mes != null &&
      _ano != null;

  @override
  void dispose() {
    _titularCtrl.dispose();
    _numeroCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text("Introducir datos de pago"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          onChanged: () => setState(() {}),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titularCtrl,
                decoration:
                    const InputDecoration(labelText: "Titular de la tarjeta"),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "Obligatorio" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _numeroCtrl,
                decoration:
                    const InputDecoration(labelText: "Número de tarjeta"),
                keyboardType: TextInputType.number,
                maxLength: 16,
                validator: (v) {
                  if (v == null || v.length != 16) return "16 dígitos";
                  if (!v.startsWith('4')) return "No es Visa válida";
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      decoration: const InputDecoration(labelText: "Mes"),
                      value: _mes,
                      items: List.generate(12, (i) {
                        final m = i + 1;
                        return DropdownMenuItem(
                          value: m,
                          child: Text(m.toString().padLeft(2, '0')),
                        );
                      }),
                      onChanged: (v) => setState(() => _mes = v),
                      validator: (_) => _mes == null ? "Obligatorio" : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      decoration: const InputDecoration(labelText: "Año"),
                      value: _ano,
                      items: List.generate(10, (i) {
                        final year = DateTime.now().year + i;
                        return DropdownMenuItem(
                          value: year,
                          child: Text(year.toString().substring(2)),
                        );
                      }),
                      onChanged: (v) => setState(() => _ano = v),
                      validator: (_) => _ano == null ? "Obligatorio" : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _cvvCtrl,
                decoration: const InputDecoration(labelText: "CVV"),
                keyboardType: TextInputType.number,
                maxLength: 3,
                validator: (v) => v != null && RegExp(r'^[0-9]{3}$').hasMatch(v)
                    ? null
                    : "3 dígitos",
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _processing ? null : () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: !_isFormValid || _processing
              ? null
              : () async {
                  final expiry = DateTime(_ano!, _mes! + 1);
                  if (expiry.isBefore(DateTime.now())) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tarjeta caducada')),
                    );
                    return;
                  }
                  setState(() => _processing = true);
                  try {
                    final body = widget.detalles.map((it) {
                      final item = it as CarritoItem;
                      final extras = (item.seleccionados)
                          .fold<double>(0, (sum, a) => sum + a.precioExtra);
                      return {
                        'producto': {'id': item.producto.id},
                        'cantidad': item.cantidad,
                        'precio': item.producto.precioBase,
                        'costoExtra': extras,
                        'aditivos': (item.seleccionados)
                            .map((a) => {'id': a.id})
                            .toList(),
                      };
                    }).toList();

                    await ApiService.createPedido(body);

                    Provider.of<CarritoProvider>(context, listen: false)
                        .clear();
                    Navigator.pop(context);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Pago y pedido completados")),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error en el pago: $e")),
                    );
                  } finally {
                    setState(() => _processing = false);
                  }
                },
          child: _processing
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text("Pagar ${widget.total.toStringAsFixed(2)} €"),
        ),
      ],
    );
  }
}
