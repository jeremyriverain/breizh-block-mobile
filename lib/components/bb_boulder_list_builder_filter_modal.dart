import 'package:breizh_blok_mobile/components/bb_boulder_list_builder_filter_grade.dart';
import 'package:breizh_blok_mobile/components/bb_boulder_list_builder_filter_realisation.dart';
import 'package:breizh_blok_mobile/components/bb_modal_closing_button.dart';
import 'package:breizh_blok_mobile/models/collection_items.dart';
import 'package:breizh_blok_mobile/models/grade.dart';
import 'package:breizh_blok_mobile/repositories/grade_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BbBoulderListBuilderFilterModal extends StatelessWidget {
  const BbBoulderListBuilderFilterModal({
    super.key,
  });

  Future<CollectionItems<Grade>> _fetch(BuildContext context) {
    return context.read<GradeRepository>().findAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const BbModalClosingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: FutureBuilder(
        future: _fetch(context),
        builder: (
          BuildContext context,
          AsyncSnapshot<CollectionItems<Grade>> snapshot,
        ) {
          final data = snapshot.data;

          if (data != null && data.totalItems > 1) {
            return SafeArea(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      BbBoulderListBuilderFilterGrade(
                        key: const Key('boulder-list-filter-grade'),
                        allGrades: data,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const BoulderListBuilderFilterRealisation(
                        label: 'Afficher les blocs réalisés',
                      ),
                      const BoulderListBuilderFilterRealisation(
                        label: 'Afficher les blocs non réalisés',
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
