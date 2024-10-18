import 'package:breizh_blok_mobile/components/bb_boulder_success_toggle.dart';
import 'package:breizh_blok_mobile/components/bb_map_launcher_button.dart';
import 'package:breizh_blok_mobile/components/bb_restricted_clickable_widget.dart';
import 'package:breizh_blok_mobile/components/boulder_details_associated.dart';
import 'package:breizh_blok_mobile/components/boulder_details_line_boulders.dart';
import 'package:breizh_blok_mobile/components/boulder_item_map.dart';
import 'package:breizh_blok_mobile/iri_parser.dart';
import 'package:breizh_blok_mobile/models/boulder.dart';
import 'package:breizh_blok_mobile/models/request_strategy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BoulderDetails extends StatelessWidget {
  const BoulderDetails({
    required this.boulder,
    super.key,
  });

  final Boulder boulder;

  @override
  Widget build(BuildContext context) {
    final grade = boulder.grade;
    final description = boulder.description;
    final offlineFirst = context.read<RequestStrategy>().offlineFirst;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: ListView(
        key: const Key('boulder-details-list-view'),
        shrinkWrap: true,
        children: [
          Stack(
            children: [
              BoulderDetailsLineBoulders(lineBoulders: boulder.lineBoulders),
              const Positioned(
                top: 10,
                right: 10,
                child: BbRestrictedClickableWidget(
                  child: BbBoulderSuccessToggle(
                    size: 50,
                  ),
                ),
              ),
            ],
          ),
          if (description != null)
            ListTile(
              title: Text(description),
              leading: const Text('Description'),
            ),
          if (grade != null)
            ListTile(
              title: Text(grade.name),
              leading: const Text('Cotation'),
            ),
          ListTile(
            title: Text(boulder.rock.boulderArea.municipality.name),
            leading: const Text('Commune'),
            key: const Key('municipality-details-link'),
            onTap: offlineFirst
                ? null
                : () {
                    context.pushNamed(
                      'municipality_details',
                      pathParameters: {
                        'id': IriParser.id(
                          boulder.rock.boulderArea.municipality.iri,
                        ),
                      },
                    );
                  },
          ),
          ListTile(
            title: Text(boulder.rock.boulderArea.name),
            leading: const Text('Secteur'),
            key: const Key('boulder-area-details-link'),
            onTap: () {
              final routeName = offlineFirst
                  ? 'downloaded_boulder_area_details'
                  : 'boulder_area_details';
              context.pushNamed(
                routeName,
                pathParameters: {
                  'id': IriParser.id(boulder.rock.boulderArea.iri),
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: BbMapLauncherButton(
                destination: boulder.rock.location,
                destinationTitle:
                    // ignore: lines_longer_than_80_chars
                    '${boulder.name}${boulder.grade != null ? ', ${boulder.grade?.name}' : ''}',
              ),
            ),
          ),
          SizedBox(
            height: 300,
            child: BoulderItemMap(boulder: boulder),
          ),
          const SizedBox(
            height: 20,
          ),
          BoulderDetailsAssociated(boulder: boulder),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
