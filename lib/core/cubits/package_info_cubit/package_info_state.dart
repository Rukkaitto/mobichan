part of 'package_info_cubit.dart';

abstract class PackageInfoState extends Equatable {
  const PackageInfoState();
}

class PackageInfoInitial extends PackageInfoState {
  const PackageInfoInitial();

  @override
  List<Object?> get props => [];
}

class PackageInfoLoading extends PackageInfoState {
  const PackageInfoLoading();

  @override
  List<Object?> get props => [];
}

class PackageInfoLoaded extends PackageInfoState {
  final PackageInfo packageInfo;
  const PackageInfoLoaded(this.packageInfo);

  @override
  List<Object?> get props => [packageInfo];
}

class PackageInfoError extends PackageInfoState {
  final String message;
  const PackageInfoError(this.message);

  @override
  List<Object?> get props => [message];
}
