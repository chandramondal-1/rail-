import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:railpulse/app/app_routes.dart';
import 'package:railpulse/app/theme/app_palette.dart';
import 'package:railpulse/core/state/app_state.dart';
import 'package:railpulse/l10n/app_localizations.dart';
import 'package:railpulse/shared/models/train_summary.dart';
import 'package:railpulse/shared/widgets/app_card.dart';
import 'package:railpulse/shared/widgets/app_snackbar.dart';
import 'package:railpulse/shared/widgets/empty_state.dart';
import 'package:railpulse/shared/widgets/primary_button.dart';
import 'package:railpulse/shared/widgets/train_list_tile.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);
    final state = context.watch<AppState>();
    final favourites = state.favourites;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
        children: [
          Text(
            l10n.favourites,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.favouritesSubtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          if (favourites.isEmpty)
            AppCard(
              showShadow: false,
              padding: EdgeInsets.zero,
              child: EmptyState(
                icon: Icons.star_outline_rounded,
                title: l10n.noFavourites,
                body: l10n.noFavouritesBody,
                action: SizedBox(
                  width: 200,
                  child: PrimaryButton(
                    label: l10n.searchFor,
                    icon: Icons.search_rounded,
                    onPressed: () => openTrainSearch(context),
                  ),
                ),
              ),
            )
          else
            for (var index = 0; index < favourites.length; index += 1) ...[
              TrainListTile(
                train: TrainSummary(
                  number: favourites[index].number,
                  name: favourites[index].name,
                  source: favourites[index].source,
                  destination: favourites[index].destination,
                ),
                onTap: () => openTrain(
                  context,
                  TrainSummary(
                    number: favourites[index].number,
                    name: favourites[index].name,
                    source: favourites[index].source,
                    destination: favourites[index].destination,
                  ),
                ),
                trailing: IconButton(
                  tooltip: l10n.removeFavourite,
                  onPressed: () async {
                    await context.read<AppState>().removeFavourite(
                      favourites[index].number,
                    );
                    if (!context.mounted) return;
                    AppSnackbar.show(
                      context,
                      l10n.removedFromFavourites,
                      icon: Icons.star_outline_rounded,
                    );
                  },
                  icon: Icon(
                    Icons.star_rounded,
                    color: palette.warning,
                    size: 22,
                  ),
                ),
              ),
              if (index != favourites.length - 1) const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }
}
