import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:equatable/equatable.dart';
part 'package_info_state.dart';

class PackageInfoCubit extends Cubit<PackageInfoState> {
  PackageInfoCubit() : super(PackageInfoInitial());

  void getPackageInfo() async {
    emit(PackageInfoLoading());
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    emit(PackageInfoLoaded(packageInfo));
  }
}
