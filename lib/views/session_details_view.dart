import 'package:breizh_blok_mobile/blocs/boulder_bloc.dart';
import 'package:breizh_blok_mobile/blocs/boulder_filter_bloc.dart';
import 'package:breizh_blok_mobile/blocs/boulder_filter_grade_bloc.dart';
import 'package:breizh_blok_mobile/blocs/boulder_order_bloc.dart';
import 'package:breizh_blok_mobile/blocs/map_bloc.dart';
import 'package:breizh_blok_mobile/components/bb_bar_chart.dart';
import 'package:breizh_blok_mobile/components/bb_boulder_list_builder.dart';
import 'package:breizh_blok_mobile/components/bb_boulder_map.dart';
import 'package:breizh_blok_mobile/components/bb_lazy_indexed_stack.dart';
import 'package:breizh_blok_mobile/map_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionDetailsView extends StatefulWidget {
  const SessionDetailsView({
    required this.id,
    super.key,
  });

  final String id;

  @override
  State<SessionDetailsView> createState() => _SessionDetailsViewState();
}

class _SessionDetailsViewState extends State<SessionDetailsView>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      length: _tabs.length,
      initialIndex: _currentIndex,
    );

    _tabController.addListener(() {
      if (_tabController.index != _currentIndex) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });

    super.initState();
  }

  final _tabs = [
    const Tab(text: 'Blocs réalisés'),
    const Tab(text: 'Statistiques'),
  ];

  int _currentIndex = 0;

  late TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabViews = [
      BbBoulderListBuilder(
        showFilterButton: false,
        boulderFilterBloc: context.read<BoulderFilterBloc>(),
        onPageRequested: (int page) {
          final orderBlocState = context.read<BoulderOrderBloc>().state;
          final grades = context.read<BoulderFilterGradeBloc>().state.grades;

          final boulderFilterState = context.read<BoulderFilterBloc>().state;
          return BoulderRequested(
            page: page,
            term: boulderFilterState.term,
            boulderAreas: boulderFilterState.boulderAreas,
            orderParam: orderBlocState,
            grades: grades,
          );
        },
      ),
      SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: BbBarChart(
                title: 'Répartition des blocs réalisés',
                data: {'6a': 4, '6a+': 2, '6b': 1},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                height: 500,
                child: BbBoulderMap(
                  initialZoom: context.read<MapBloc>().state.mapZoom,
                  initialPosition: context.read<MapBloc>().state.mapLatLng,
                  boulderMarkerBuilder: MapMarker.markerBuilderFactory(
                    context,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ];

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '3 mars 2024',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: _tabs,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: BbLazyIndexedStack(
            index: _currentIndex,
            children: tabViews,
          ),
        ),
      ),
    );
  }
}
