import 'package:flutter/material.dart';
import '../model/hero_item.dart';
import '../l10n/app_localizations.dart';
import 'hero_stats.dart';

class HeroCard extends StatelessWidget {
  const HeroCard({super.key, required this.hero, required this.favorite,
    required this.onOpen, required this.onFavorite});
  final HeroItem hero;
  final bool favorite;
  final VoidCallback onOpen;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Card(clipBehavior: Clip.antiAlias,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          InkWell(onTap: onOpen, child: Image.asset(hero.image, height: 150,
              fit: BoxFit.contain, semanticLabel: hero.name)),
          Padding(padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Text(hero.name, style: Theme.of(context).textTheme.titleLarge)),
          const SizedBox(height: 8),
          // R1_WIDGET
          // Insertamos el widget reutilizable que me pide el ejercicio de estadisticas dentro de la tarjeta
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: HeroStats(hero: hero),
          ),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Wrap(alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center, children: [
                    TextButton(onPressed: onOpen, child: Text(t.details)),
                    IconButton(key: ValueKey('fav-${hero.id}'),
                        tooltip: favorite ? t.removeFavorite : t.addFavorite,
                        onPressed: onFavorite,
                        // Lo cambio para que sea dinamico el color del corazon si ya esta marcado como favorito
                        icon: Icon(favorite ? Icons.favorite : Icons.favorite_border,
                            color: favorite ? Colors.red : null)),
                  ])),
        ]));
  }
}