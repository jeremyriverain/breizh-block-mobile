import 'package:breizh_blok_mobile/blocs/boulder_filter_bloc.dart';
import 'package:breizh_blok_mobile/blocs/boulder_marker_bloc.dart';
import 'package:breizh_blok_mobile/components/app_bar_helper.dart';
import 'package:breizh_blok_mobile/components/boulder_area_details_description_tab.dart';
import 'package:breizh_blok_mobile/components/boulder_area_details_list_tab.dart';
import 'package:breizh_blok_mobile/components/boulder_area_details_map_tab.dart';
import 'package:breizh_blok_mobile/components/lazy_indexed_stack.dart';
import 'package:breizh_blok_mobile/models/boulder_area.dart';
import 'package:breizh_blok_mobile/models/request_strategy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoulderAreaDetails extends StatefulWidget {
  const BoulderAreaDetails({
    required this.boulderArea,
    super.key,
  });

  final BoulderArea boulderArea;

  @override
  State<BoulderAreaDetails> createState() => _BoulderAreaDetailsState();
}

class _BoulderAreaDetailsState extends State<BoulderAreaDetails>
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
    context.read<BoulderMarkerBloc>().add(
          BoulderMarkerRequested(
            filterState: context.read<BoulderFilterBloc>().state,
            offlineFirst: context.read<RequestStrategy>().offlineFirst,
          ),
        );
    super.initState();
  }

  final _tabs = [
    const Tab(text: 'Blocs'),
    const Tab(
      text: 'Description',
    ),
    const Tab(text: 'Carte'),
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
      BoulderAreaDetailsListTab(boulderArea: widget.boulderArea),
      BoulderAreaDetailsDescriptionTab(boulderArea: widget.boulderArea),
      BoulderAreaDetailsMapTab(boulderArea: widget.boulderArea),
    ];

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          key: const Key('boulder-area-details-app-bar'),
          title: Column(
            children: [
              const AppBarHelper(label: 'secteur'),
              Text(
                widget.boulderArea.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: _tabs,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: LazyIndexedStack(
            index: _currentIndex,
            children: tabViews,
          ),
        ),
      ),
    );
  }
}
