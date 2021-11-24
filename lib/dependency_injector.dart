import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan/features/board/cubits/cubits.dart';
import 'package:mobichan/features/captcha/cubits/cubits.dart';
import 'package:mobichan/features/post/cubits/cubits.dart';
import 'package:mobichan/features/release/cubits/cubits.dart';
import 'package:mobichan/features/sort/cubits/cubits.dart';
import 'package:mobichan/features/setting/cubits/cubits.dart';
import 'package:mobichan_data/mobichan_data.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      client: sl(),
    ),
  );

  sl.registerLazySingleton<BoardLocalDatasource>(
    () => BoardLocalDatasourceImpl(
      sharedPreferences: sl(),
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
      client: sl(),
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
    ),
  );

  sl.registerLazySingleton<PostRemoteDatasource>(
    () => PostRemoteDatasourceImpl(
      client: sl(),
    ),
  );

  sl.registerLazySingleton<PostLocalDatasource>(
    () => PostLocalDatasourceImpl(
      sharedPreferences: sl(),
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
      client: sl(),
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

  sl.registerFactory<SettingCubit>(
    () => SettingCubit(
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

  final packageInfo = await PackageInfo.fromPlatform();
  sl.registerLazySingleton<PackageInfo>(() => packageInfo);

  sl.registerLazySingleton<Dio>(() => Dio());

  log('Injected dependencies.', name: "Dependency Injector");
}
