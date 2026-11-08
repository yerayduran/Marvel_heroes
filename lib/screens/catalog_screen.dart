import 'package:flutter/material.dart';
import '../data/heroes.dart';
import '../model/hero_item.dart';
import '../widgets/hero_card.dart';
import '../l10n/app_localizations.dart';
import 'detail_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});
  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final Set<String> _favorites = {};
  String _query = '';
  int _destination = 0;

  bool _matches(HeroItem hero) {
    // R2: filtrar por nombre, ignorando mayúsculas y espacios exteriores.

    // Limpiamos los espacios en blanco con .trim() y pasamos todo a minúsculas para hacer una búsqueda de manera concisa.
    final query = _query.trim().toLowerCase();
    return query.isEmpty || hero.name.toLowerCase().contains(query);
  }

  Future<void> _changeFavorite(HeroItem hero) async {
    // R4: añadir sin duplicados; antes de quitar, pedir confirmación.
    final t = AppLocalizations.of(context)!;
    final isFavorite = _favorites.contains(hero.id);

    // Si el héroe ya es favorito, mostramos una alerta pidiendo confirmación antes de borrarlo del Set.
    if (isFavorite) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(t.confirmTitle),
          content: Text(t.confirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(t.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(t.remove),
            ),
          ],
        ),
      );

      // Si el usuario pulsa en confirmar, eliminamos el ID del Set mediante setState para actualizar la interfaz.
      if (confirm == true) {
        setState(() {
          _favorites.remove(hero.id);
        });
      }
      // Si no es favorito, lo añadimos directamente sin duplicar elementos gracias a las propiedades del Set.
    } else {
      setState(() {
        _favorites.add(hero.id);
      });
    }
  }

  Future<void> _open(HeroItem hero) async {
    final changed = await Navigator.push<bool>(context, MaterialPageRoute(
        builder: (_) => DetailScreen(hero: hero, favorite: _favorites.contains(hero.id))));
    if (!mounted || changed != true) return;

    // R3: aplicar la intención devuelta por el detalle.
    // Recogemos el booleano que devuelve el detalle al hacer pop y ejecutamos el cambio de favorito correspondiente.
    await _changeFavorite(hero);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final shown = heroes.where((h) => (_destination == 0 || _favorites.contains(h.id))
        && _matches(h)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('MarvelHeroes'), actions: [
        IconButton(tooltip: t.about, icon: const Icon(Icons.info_outline),
            onPressed: () => showAboutDialog(context: context,
                applicationName: 'MarvelHeroes UD2',
                applicationVersion: const String.fromEnvironment('APP_LABEL', defaultValue: 'Aula 1'),
                children: [Text(t.memoryNote)])),
      ]),
      body: SafeArea(child: Column(children: [
        Padding(padding: const EdgeInsets.all(12), child: TextField(
            key: const ValueKey('search'),
            decoration: InputDecoration(labelText: t.search,
                prefixIcon: const Icon(Icons.search), border: const OutlineInputBorder()),
            onChanged: (value) => setState(() => _query = value))),
        Expanded(child: shown.isEmpty
            ? Center(child: Padding(padding: const EdgeInsets.all(24),
            child: Text(_destination == 1 && _favorites.isEmpty ? t.noFavorites : t.noResults)))
            : LayoutBuilder(builder: (context, constraints) {
          // Android puede anunciar ancho cero durante el primer fotograma.
          if (constraints.maxWidth <= 16) return const SizedBox.shrink();

          // R5: una columna <600; dos >=600 píxeles lógicos.
          // Comprobamos el ancho disponible de la pantalla para definir si ponemos 1 o 2 columnas en el grid/wrap.
          final columns = constraints.maxWidth >= 600 ? 2 : 1;

          return SingleChildScrollView(key: const ValueKey('catalog-scroll'),
              padding: const EdgeInsets.all(8), child: Wrap(children: [
                for (final hero in shown)
                  SizedBox(width: (constraints.maxWidth - 16) / columns,
                      child: HeroCard(hero: hero, favorite: _favorites.contains(hero.id),
                          onOpen: () => _open(hero), onFavorite: () => _changeFavorite(hero))),
              ]));
        })),
      ])),
      bottomNavigationBar: NavigationBar(selectedIndex: _destination,
          onDestinationSelected: (value) => setState(() => _destination = value),
          destinations: [
            NavigationDestination(icon: const Icon(Icons.grid_view), label: t.catalog),
            NavigationDestination(icon: const Icon(Icons.favorite), label: t.favorites),
          ]),
    );
  }
}