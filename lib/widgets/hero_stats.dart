import 'package:flutter/material.dart';
import '../model/hero_item.dart';
import '../l10n/app_localizations.dart';

class HeroStats extends StatelessWidget {
  const HeroStats({super.key, required this.hero});
  final HeroItem hero;

  @override
  Widget build(BuildContext context) {
    // Obtenemos las traducciones para que los textos de "Poder" e "Inteligencia" cambien según el idioma del sistema.
    final t = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            // Icono que sirve reconocer el poder con un color llamativo.
            const Icon(Icons.fitness_center, size: 16, color: Colors.amber),
            const SizedBox(width: 4),
            Text('${t.power}: ${hero.power}'),
          ],
        ),
        Row(
          children: [
            // Icono que sirve reconocer el inteligencia con un color llamativo.
            const Icon(Icons.book, size: 16, color: Colors.redAccent),
            const SizedBox(width: 4),
            Text('${t.intelligence}: ${hero.intelligence}'),
          ],
        ),
      ],
    );
  }
}