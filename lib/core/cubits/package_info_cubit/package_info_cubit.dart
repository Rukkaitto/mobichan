import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:equatable/equatable.dart';
part 'package_info_state.dart';

class PackageInfoCubit extends Cubit<PackageInfoState> {
  final PackageInfo packageInfo;

  PackageInfoCubit({required this.packageInfo})
      : super(const PackageInfoInitial());

  void getPackageInfo() async {
    emit(PackageInfoLoaded(packageInfo));
  }
}
