import 'package:flutter/material.dart';
import '../models/aditivo.dart';

class AditivoChip extends StatelessWidget {
  final Aditivo aditivo;
  final bool selected;
  final VoidCallback onTap;

  const AditivoChip({
    super.key,
    required this.aditivo,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ChoiceChip(
        label: Text(aditivo.nombre),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}
