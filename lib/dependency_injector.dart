import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mobichan/pages/boards/cubit/boards_cubit/boards_cubit.dart';
import 'package:mobichan/pages/boards/cubit/favorite_cubit/favorite_cubit.dart';
import 'package:mobichan/widgets/drawer/cubit/favorites_cubit/favorites_cubit.dart';
import 'package:mobichan/widgets/drawer/cubit/package_info_cubit/package_info_cubit.dart';
import 'package:mobichan_data/mobichan_data.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
      dio: sl(),
    ),
  );

  sl.registerLazySingleton<PostLocalDatasource>(
    () => PostLocalDatasourceImpl(
      sharedPreferences: sl(),
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

  // Core
  sl.registerLazySingleton<PackageInfoCubit>(
    () => PackageInfoCubit(
      packageInfo: sl(),
    ),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  final packageInfo = await PackageInfo.fromPlatform();
  sl.registerLazySingleton(() => packageInfo);

  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Dio());

  log('Injected dependencies.', name: "Dependency Injector");
}
