import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan/secrets.dart';
import 'package:mobichan/features/board/cubits/cubits.dart';
import 'package:mobichan/features/captcha/cubits/cubits.dart';
import 'package:mobichan/features/post/cubits/cubits.dart';
import 'package:mobichan/features/release/cubits/cubits.dart';
import 'package:mobichan/features/sort/cubits/cubits.dart';
import 'package:mobichan/features/setting/cubits/cubits.dart';
import 'package:mobichan_data/mobichan_data.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase/supabase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Board
  sl.registerLazySingleton<BoardRepository>(
    () => BoardRepositoryImpl(
      localDatasource: sl(),
      remoteDatasource: sl(),
    ),
  );

  sl.registerLazySingleton<BoardRemoteDatasource>(
    () => BoardRemoteDatasourceImpl(
      networkManager: sl(),
    ),
  );

  sl.registerLazySingleton<BoardLocalDatasource>(
    () => BoardLocalDatasourceImpl(
      sharedPreferences: sl(),
      database: sl(),
    ),
  );

  sl.registerFactory<BoardsCubit>(
    () => BoardsCubit(
      repository: sl(),
    ),
  );

  sl.registerFactory<BoardCubit>(
    () => BoardCubit(
      repository: sl(),
    ),
  );

  sl.registerFactory<TabsCubit>(
    () => TabsCubit(
      repository: sl(),
    ),
  );

  sl.registerFactory<FavoritesCubit>(
    () => FavoritesCubit(
      repository: sl(),
    ),
  );

  sl.registerFactory<FavoriteCubit>(
    () => FavoriteCubit(
      repository: sl(),
    ),
  );

  // Captcha
  sl.registerLazySingleton<CaptchaRepository>(
    () => CaptchaRepositoryImpl(
      remoteDatasource: sl(),
    ),
  );

  sl.registerLazySingleton<CaptchaRemoteDatasource>(
    () => CaptchaRemoteDatasourceImpl(
      networkManager: sl(),
    ),
  );

  sl.registerFactory<CaptchaCubit>(
    () => CaptchaCubit(
      repository: sl(),
    ),
  );

  // Post
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(
      localDatasource: sl(),
      remoteDatasource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<PostRemoteDatasource>(
    () => PostRemoteDatasourceImpl(
      networkManager: sl(),
    ),
  );

  sl.registerLazySingleton<PostLocalDatasource>(
    () => PostLocalDatasourceImpl(
      sharedPreferences: sl(),
      database: sl(),
    ),
  );

  sl.registerFactory<HistoryCubit>(
    () => HistoryCubit(
      repository: sl(),
    ),
  );

  sl.registerFactory<ThreadsCubit>(
    () => ThreadsCubit(
      repository: sl(),
    ),
  );

  sl.registerFactory<RepliesCubit>(
    () => RepliesCubit(
      repository: sl(),
    ),
  );

  // Release
  sl.registerLazySingleton<ReleaseRepository>(
    () => ReleaseRepositoryImpl(
      remoteDatasource: sl(),
    ),
  );

  sl.registerLazySingleton<ReleaseRemoteDatasource>(
    () => ReleaseRemoteDatasourceImpl(
      networkManager: sl(),
    ),
  );

  sl.registerFactory<ReleaseCubit>(
    () => ReleaseCubit(
      repository: sl(),
    ),
  );

  // Sort
  sl.registerLazySingleton<SortRepository>(
    () => SortRepositoryImpl(
      localDatasource: sl(),
    ),
  );

  sl.registerLazySingleton<SortLocalDatasource>(
    () => SortLocalDatasourceImpl(
      sharedPreferences: sl(),
    ),
  );

  sl.registerFactory<SortCubit>(
    () => SortCubit(
      repository: sl(),
    ),
  );

  // Setting
  sl.registerLazySingleton<SettingRepository>(
    () => SettingRepositoryImpl(
      localDatasource: sl(),
    ),
  );

  sl.registerLazySingleton<SettingLocalDatasource>(
    () => SettingLocalDatasourceImpl(
      sharedPreferences: sl(),
    ),
  );

  sl.registerFactory<SettingsCubit>(
    () => SettingsCubit(
      repository: sl(),
    ),
  );

  sl.registerFactory<NsfwWarningCubit>(
    () => NsfwWarningCubit(
      repository: sl(),
    ),
  );

  // Core
  sl.registerLazySingleton<PackageInfoCubit>(
    () => PackageInfoCubit(
      packageInfo: sl(),
    ),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  final database = await openDatabase(
    join(await getDatabasesPath(), 'mobichan_database.db'),
    onCreate: (db, version) async {
      await db.execute(Board.databaseQuery('boards'));
      await db.execute(Post.databaseQuery('posts'));
    },
    version: 1,
  );
  sl.registerLazySingleton<Database>(() => database);

  final packageInfo = await PackageInfo.fromPlatform();
  sl.registerLazySingleton<PackageInfo>(() => packageInfo);

  sl.registerLazySingleton<Dio>(() => Dio());

  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      connectionChecker: DataConnectionChecker(),
    ),
  );

  sl.registerLazySingleton<NetworkManager>(
    () => NetworkManagerImpl(
      client: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<SupabaseClient>(
    () => SupabaseClient(
      Secrets.supabaseUrl,
      Secrets.supabaseKey,
    ),
  );

  log('Injected dependencies.', name: "Dependency Injector");
}
