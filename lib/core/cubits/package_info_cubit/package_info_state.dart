part of 'package_info_cubit.dart';

class PackageInfoState extends BaseState {}

class PackageInfoInitial extends BaseInitialState with PackageInfoState {}

class PackageInfoLoading extends BaseLoadingState with PackageInfoState {}

class PackageInfoLoaded extends BaseLoadedState<PackageInfo>
    with PackageInfoState {
  PackageInfoLoaded(PackageInfo data) : super(data);
}

class PackageInfoError extends BaseErrorState with PackageInfoState {
  PackageInfoError(String message) : super(message);
}
