import 'package:breizh_blok_mobile/components/bb_boulder_success_toggle.dart';
import 'package:breizh_blok_mobile/components/bb_boulder_tile_image.dart';
import 'package:breizh_blok_mobile/components/bb_boulder_tile_title.dart';
import 'package:breizh_blok_mobile/components/bb_restricted_clickable_widget.dart';
import 'package:breizh_blok_mobile/models/boulder.dart';
import 'package:breizh_blok_mobile/models/request_strategy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BbBoulderListBuilderTile extends StatelessWidget {
  const BbBoulderListBuilderTile({
    required this.boulder,
    this.showLocationInfo = true,
    super.key,
  });

  final Boulder boulder;
  final bool showLocationInfo;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Voir le détail du bloc "${boulder.name}"',
      child: InkWell(
        onTap: () {
          final offlineFirst = context.read<RequestStrategy>().offlineFirst;
          final routeName =
              offlineFirst ? 'downloaded_boulder_details' : 'boulder_details';
          context.pushNamed(
            routeName,
            pathParameters: {'id': boulder.id},
            queryParameters: offlineFirst
                ? {
                    'boulderAreaIri': boulder.rock.boulderArea.iri,
                  }
                : {},
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: SizedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: [
                    BbBoulderTileImage(boulder: boulder),
                    const Positioned(
                      bottom: 5,
                      left: 5,
                      child: BbRestrictedClickableWidget(
                        child: BbBoulderSuccessToggle(),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 2, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        BbBoulderTileTitle(boulder: boulder),
                        if (showLocationInfo)
                          const Padding(padding: EdgeInsets.only(bottom: 2)),
                        if (showLocationInfo)
                          Text.rich(
                            TextSpan(
                              children: <TextSpan>[
                                const TextSpan(
                                  text: 'Secteur: ',
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                                TextSpan(
                                  text: boulder.rock.boulderArea.name,
                                ),
                              ],
                            ),
                          ),
                        if (showLocationInfo)
                          Text.rich(
                            TextSpan(
                              children: <TextSpan>[
                                const TextSpan(
                                  text: 'Commune: ',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                TextSpan(
                                  text: boulder
                                      .rock.boulderArea.municipality.name,
                                ),
                              ],
                            ),
                            key: const Key('boulder-list-tile-municipality'),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
