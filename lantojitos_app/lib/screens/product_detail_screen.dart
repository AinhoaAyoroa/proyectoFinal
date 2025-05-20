import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/aditivo.dart';
import '../models/producto.dart';
import '../providers/aditivo_provider.dart';
import '../providers/carrito_provider.dart';
import '../services/api_service.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product_detail';
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Producto> _futProducto;
  Aditivo? _panSeleccionado;
  Aditivo? _carneSeleccionada;
  final List<Aditivo> _toppingsSeleccionados = [];
  Aditivo? _pinchoSeleccionado;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = ModalRoute.of(context)!.settings.arguments as int;
    _futProducto = ApiService.fetchProductoById(id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final aditivoProv = context.watch<AditivoProvider>();
    final panes = aditivoProv.byTipo('Pan');
    final carnes = aditivoProv.byTipo('Carne');
    final toppings = aditivoProv.byTipo('Topping');
    final pinchos = aditivoProv.byTipo('Pincho');
    final carrito = context.read<CarritoProvider>();
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        title: Text(
          'Detalle',
          style: theme.textTheme.headlineSmall
              ?.copyWith(color: theme.colorScheme.onSurface),
        ),
      ),
      body: FutureBuilder<Producto>(
        future: _futProducto,
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final p = snap.data!;
          final isBocata = p.id <= 5;
          final extraCost = isBocata
              ? [
                  _panSeleccionado,
                  _carneSeleccionada,
                  ..._toppingsSeleccionados,
                  _pinchoSeleccionado,
                ]
                  .whereType<Aditivo>()
                  .fold<double>(0, (sum, a) => sum + a.precioExtra)
              : 0.0;
          final puedeAnadir = !isBocata ||
              (_panSeleccionado != null && _carneSeleccionada != null);
          final imgPath = assetMap[p.id] ?? 'lib/img/placeholder.jpeg';
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imgPath,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 100),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  p.nombre,
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  p.descripcion,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 24),
                if (isBocata && panes.isNotEmpty) ...[
                  Text('Pan (Obligatorio):',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: panes.map((pan) {
                      final sel = _panSeleccionado?.id == pan.id;
                      return ChoiceChip(
                        backgroundColor: Colors.white,
                        selectedColor: Colors.lightBlue.shade100,
                        side: BorderSide(color: Colors.grey.shade600),
                        label: Text(
                          sel
                              ? '${pan.nombre} +${pan.precioExtra.toStringAsFixed(2)}€'
                              : pan.nombre,
                        ),
                        selected: sel,
                        onSelected: (_) => setState(() {
                          _panSeleccionado = sel ? null : pan;
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
                if (isBocata && carnes.isNotEmpty) ...[
                  Text('Carne (Obligatorio):',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: carnes.map((carne) {
                      final sel = _carneSeleccionada?.id == carne.id;
                      return ChoiceChip(
                        backgroundColor: Colors.white,
                        selectedColor: Colors.lightBlue.shade100,
                        side: BorderSide(color: Colors.grey.shade600),
                        label: Text(
                          sel
                              ? '${carne.nombre} +${carne.precioExtra.toStringAsFixed(2)}€'
                              : carne.nombre,
                        ),
                        selected: sel,
                        onSelected: (_) => setState(() {
                          _carneSeleccionada = sel ? null : carne;
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
                if (isBocata && toppings.isNotEmpty) ...[
                  Text('Topping (Opcional):',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: toppings.map((top) {
                      final sel =
                          _toppingsSeleccionados.any((a) => a.id == top.id);
                      return ChoiceChip(
                        backgroundColor: Colors.white,
                        selectedColor: Colors.lightBlue.shade100,
                        side: BorderSide(color: Colors.grey.shade600),
                        label: Text(
                          sel
                              ? '${top.nombre} +${top.precioExtra.toStringAsFixed(2)}€'
                              : top.nombre,
                        ),
                        selected: sel,
                        onSelected: (_) => setState(() {
                          if (sel) {
                            _toppingsSeleccionados
                                .removeWhere((a) => a.id == top.id);
                          } else {
                            _toppingsSeleccionados.add(top);
                          }
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
                if (isBocata && pinchos.isNotEmpty) ...[
                  Text('Añade un pincho (Opcional):',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: pinchos.map((pin) {
                      final sel = _pinchoSeleccionado?.id == pin.id;
                      return ChoiceChip(
                        backgroundColor: Colors.white,
                        selectedColor: Colors.lightBlue.shade100,
                        side: BorderSide(color: Colors.grey.shade600),
                        label: Text(
                          sel
                              ? '${pin.nombre} +${pin.precioExtra.toStringAsFixed(2)}€'
                              : pin.nombre,
                        ),
                        selected: sel,
                        onSelected: (_) => setState(() {
                          _pinchoSeleccionado = sel ? null : pin;
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add_shopping_cart),
                    label: Text(
                      'Añadir al carrito${extraCost > 0 ? ' +${extraCost.toStringAsFixed(2)}€' : ''}',
                    ),
                    onPressed: puedeAnadir
                        ? () {
                            final extras = <Aditivo>[];
                            if (isBocata) {
                              if (_panSeleccionado != null) {
                                extras.add(_panSeleccionado!);
                              }
                              if (_carneSeleccionada != null) {
                                extras.add(_carneSeleccionada!);
                              }
                              if (_pinchoSeleccionado != null) {
                                extras.add(_pinchoSeleccionado!);
                              }
                              extras.addAll(_toppingsSeleccionados);
                            }
                            carrito.addProducto(p, extras: extras);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Añadido al carrito")),
                            );
                            Navigator.pop(context);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
