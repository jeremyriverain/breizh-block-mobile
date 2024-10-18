import 'dart:io';

import 'package:breizh_blok_mobile/app_http_client.dart';
import 'package:breizh_blok_mobile/blocs/auth_bloc.dart';
import 'package:breizh_blok_mobile/blocs/boulder_filter_bloc.dart';
import 'package:breizh_blok_mobile/blocs/boulder_filter_grade_bloc.dart';
import 'package:breizh_blok_mobile/blocs/boulder_marker_bloc.dart';
import 'package:breizh_blok_mobile/blocs/boulder_order_bloc.dart';
import 'package:breizh_blok_mobile/blocs/map_bloc.dart';
import 'package:breizh_blok_mobile/blocs/map_permission_bloc.dart';
import 'package:breizh_blok_mobile/blocs/tab_bloc.dart';
import 'package:breizh_blok_mobile/blocs/terms_of_use_bloc.dart';
import 'package:breizh_blok_mobile/blocs/vibrator_bloc.dart';
import 'package:breizh_blok_mobile/components/bb_restricted_view.dart';
import 'package:breizh_blok_mobile/database/app_database.dart';
import 'package:breizh_blok_mobile/image_boulder_cache.dart';
import 'package:breizh_blok_mobile/location_provider.dart';
import 'package:breizh_blok_mobile/models/order_param.dart';
import 'package:breizh_blok_mobile/models/request_strategy.dart';
import 'package:breizh_blok_mobile/repositories/boulder_area_repository.dart';
import 'package:breizh_blok_mobile/repositories/boulder_marker_repository.dart';
import 'package:breizh_blok_mobile/repositories/boulder_repository.dart';
import 'package:breizh_blok_mobile/repositories/department_repository.dart';
import 'package:breizh_blok_mobile/repositories/grade_repository.dart';
import 'package:breizh_blok_mobile/repositories/municipality_repository.dart';
import 'package:breizh_blok_mobile/share_content_service.dart';
import 'package:breizh_blok_mobile/share_content_service_interface.dart';
import 'package:breizh_blok_mobile/vibrator_service.dart';
import 'package:breizh_blok_mobile/views/boulder_area_details_view.dart';
import 'package:breizh_blok_mobile/views/boulder_details_view.dart';
import 'package:breizh_blok_mobile/views/download_view.dart';
import 'package:breizh_blok_mobile/views/home_view.dart';
import 'package:breizh_blok_mobile/views/municipality_details_view.dart';
import 'package:breizh_blok_mobile/views/profile_view.dart';
import 'package:breizh_blok_mobile/views/session_details_view.dart';
import 'package:breizh_blok_mobile/views/sessions_view.dart';
import 'package:breizh_blok_mobile/views/stats_view.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart' hide HttpClientProvider;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main({
  MapPermissionBloc? mapPermissionBloc,
  ShareContentServiceInterface? shareContentService,
  AppDatabase? database,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final termsOfUseBloc = TermsOfUseBloc();

  final appDatabase = database ??
      AppDatabase(
        LazyDatabase(() async {
          final dbFolder = await getApplicationDocumentsDirectory();
          final file = File(p.join(dbFolder.path, 'db.sqlite'));
          return NativeDatabase.createInBackground(file);
        }),
      );

  final httpClient = AppHttpClient(
    database: appDatabase,
  );

  final imageBoulderCache = ImageBoulderCache();

  final authBloc = AuthBloc();

  final tabBloc = TabBloc();

  final mapBloc = MapBloc();

  final boulderFilterBloc = BoulderFilterBloc(
    BoulderFilterState(),
  );

  final boulderOrderBloc = BoulderOrderBloc(
    const OrderParam(
      direction: kDescendantDirection,
      name: kIdOrderParam,
    ),
  );

  final boulderFilterGradeBloc =
      BoulderFilterGradeBloc(BoulderFilterGradeState());
  final boulderMarkerRepository =
      BoulderMarkerRepository(httpClient: httpClient);

  final boulderMarkerBloc = BoulderMarkerBloc(
    repository: boulderMarkerRepository,
  );

  final appShareContentService = shareContentService ?? ShareContentService();
  final vibratorCapabilityBloc = VibratorBloc(
    vibratorService: VibratorService(),
  );

  await SentryFlutter.init(
    (options) {
      options
        ..dsn = options.dsn = const String.fromEnvironment('SENTRY_DSN')
        ..tracesSampleRate = 0;
    },
    appRunner: () => runApp(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<BoulderAreaRepository>(
            create: (context) => BoulderAreaRepository(httpClient: httpClient),
          ),
          RepositoryProvider<BoulderMarkerRepository>(
            create: (context) => boulderMarkerRepository,
          ),
          RepositoryProvider<BoulderRepository>(
            create: (context) => BoulderRepository(httpClient: httpClient),
          ),
          RepositoryProvider<DepartmentRepository>(
            create: (context) => DepartmentRepository(httpClient: httpClient),
          ),
          RepositoryProvider<GradeRepository>(
            create: (context) => GradeRepository(httpClient: httpClient),
          ),
          RepositoryProvider<MunicipalityRepository>(
            create: (context) => MunicipalityRepository(httpClient: httpClient),
          ),
          RepositoryProvider<AppDatabase>(
            create: (context) => appDatabase,
          ),
          RepositoryProvider<AppHttpClient>(
            create: (context) => httpClient,
          ),
          RepositoryProvider<ImageBoulderCache>(
            create: (context) => imageBoulderCache,
          ),
          RepositoryProvider<ShareContentServiceInterface>(
            create: (context) => appShareContentService,
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (BuildContext context) => authBloc,
            ),
            BlocProvider<TermsOfUseBloc>(
              create: (BuildContext context) => termsOfUseBloc,
            ),
            BlocProvider<BoulderFilterBloc>(
              create: (BuildContext context) => boulderFilterBloc,
            ),
            BlocProvider<BoulderOrderBloc>(
              create: (BuildContext context) => boulderOrderBloc,
            ),
            BlocProvider<BoulderFilterGradeBloc>(
              create: (BuildContext context) => boulderFilterGradeBloc,
            ),
            BlocProvider<BoulderMarkerBloc>(
              create: (BuildContext context) => boulderMarkerBloc,
            ),
            BlocProvider<TabBloc>(
              create: (BuildContext context) => tabBloc,
            ),
            BlocProvider<MapBloc>(
              create: (BuildContext context) => mapBloc,
            ),
            BlocProvider<MapPermissionBloc>(
              create: (BuildContext context) =>
                  mapPermissionBloc ?? MapPermissionBloc(),
            ),
            BlocProvider<VibratorBloc>(
              create: (BuildContext context) => vibratorCapabilityBloc,
            ),
          ],
          child: LocationProvider(
            locationInstance: Location.instance,
            child: MyApp(
              database: appDatabase,
            ),
          ),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    required this.database,
    super.key,
  });

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          name: 'boulder_list',
          builder: (context, state) => RepositoryProvider(
            create: (context) => RequestStrategy(),
            child: HomeView(
              database: database,
            ),
          ),
          routes: [
            GoRoute(
              path: 'boulders/:id',
              name: 'boulder_details',
              builder: (context, state) {
                return RepositoryProvider(
                  create: (context) => RequestStrategy(),
                  child: BoulderDetailsView(id: state.pathParameters['id']!),
                );
              },
            ),
            GoRoute(
              path: 'boulder-areas/:id',
              name: 'boulder_area_details',
              builder: (context, state) {
                return RepositoryProvider(
                  create: (context) => RequestStrategy(),
                  child:
                      BoulderAreaDetailsView(id: state.pathParameters['id']!),
                );
              },
            ),
            GoRoute(
              path: 'municipalities/:id',
              name: 'municipality_details',
              builder: (context, state) {
                return RepositoryProvider(
                  create: (context) => RequestStrategy(),
                  child:
                      MunicipalityDetailsView(id: state.pathParameters['id']!),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/downloads/boulders/:id',
          name: 'downloaded_boulder_details',
          builder: (context, state) {
            return RepositoryProvider<RequestStrategy>(
              create: (context) => RequestStrategy(offlineFirst: true),
              child: BoulderDetailsView(
                id: state.pathParameters['id']!,
                boulderAreaIri: state.uri.queryParameters['boulderAreaIri'],
              ),
            );
          },
        ),
        GoRoute(
          path: '/downloads/boulders-area/:id',
          name: 'downloaded_boulder_area_details',
          builder: (context, state) {
            return RepositoryProvider<RequestStrategy>(
              create: (context) => RequestStrategy(offlineFirst: true),
              child: BoulderAreaDetailsView(
                id: state.pathParameters['id']!,
              ),
            );
          },
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) {
            return RepositoryProvider(
              create: (context) => RequestStrategy(),
              child: const ProfileView(),
            );
          },
        ),
        GoRoute(
          path: '/downloads',
          name: 'downloads',
          builder: (context, state) {
            return RepositoryProvider(
              create: (context) => RequestStrategy(),
              child: DownloadView(
                database: database,
              ),
            );
          },
        ),
        GoRoute(
          path: '/stats',
          name: 'stats',
          builder: (context, state) {
            return BbRestrictedView(
              child: RepositoryProvider(
                create: (context) => RequestStrategy(),
                child: const StatsView(),
              ),
            );
          },
        ),
        GoRoute(
          path: '/sessions',
          name: 'sessions',
          builder: (context, state) {
            return BbRestrictedView(
              child: RepositoryProvider(
                create: (context) => RequestStrategy(),
                child: SessionsView(),
              ),
            );
          },
        ),
        GoRoute(
          path: '/sessions/:id',
          name: 'session_details',
          builder: (context, state) {
            return BbRestrictedView(
              child: RepositoryProvider(
                create: (context) => RequestStrategy(),
                child: SessionDetailsView(id: state.pathParameters['id']!),
              ),
            );
          },
        ),
      ],
      initialLocation: '/',
    );

    return MaterialApp.router(
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.lightBlue),
      debugShowCheckedModeBanner: false,
    );
  }
}
