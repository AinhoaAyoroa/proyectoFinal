import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/producto_provider.dart';
import '../providers/carrito_provider.dart';
import '../screens/product_detail_screen.dart';
import '../screens/carrito_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductoProvider>(context, listen: false).loadProductos();
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<ProductoProvider>();
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "L'antojitos",
            style: GoogleFonts.interTight(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: prov.loading
                ? const Center(child: CircularProgressIndicator())
                : prov.error != null
                    ? Center(child: Text("Error: ${prov.error}"))
                    : GridView.builder(
                        padding: EdgeInsets.zero,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: prov.productos.length,
                        itemBuilder: (_, i) {
                          final p = prov.productos[i];
                          return _MiniBocadilloCard(
                            producto: p,
                            onTap: () => Navigator.pushNamed(
                              context,
                              ProductDetailScreen.routeName,
                              arguments: p.id,
                            ),
                          );
                        },
                      ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: theme.colorScheme.primary,
          onPressed: () =>
              Navigator.pushNamed(context, CarritoScreen.routeName),
          child: Icon(Icons.shopping_cart,
              color: theme.colorScheme.onPrimary, size: 24),
        ),
      ),
    );
  }
}

String _assetForProducto(int id) {
  switch (id) {
    case 1:
      return 'lib/img/bocadillo_jamon.png';
    case 2:
      return 'lib/img/bocadillo_tortilla.png';
    case 3:
      return 'lib/img/bocadillo_vegetal.jpg';
    case 4:
      return 'lib/img/bocadillo_atun.jpg';
    case 5:
      return 'lib/img/bocadillo_pollo.png';
    default:
      return 'lib/img/placeholder.png';
  }
}

class _MiniBocadilloCard extends StatelessWidget {
  final producto;
  final VoidCallback onTap;
  const _MiniBocadilloCard({
    required this.producto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x20000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
                child: Image.asset(
                  _assetForProducto(producto.id),
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                producto.nombre,
                style: GoogleFonts.interTight(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                producto.descripcion,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${producto.precioBase.toStringAsFixed(2)}€',
                    style: GoogleFonts.interTight(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<CarritoProvider>().addProducto(producto);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Añadido al carrito")),
                      );
                    },
                    child: const Text("Añadir"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
