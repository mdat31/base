// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:base/data/remote/api/api.dart' as _i10;
import 'package:base/data/remote/base_url.dart' as _i13;
import 'package:base/data/repository/repository_impl.dart' as _i9;
import 'package:base/device/device_info.dart' as _i4;
import 'package:base/di/register_module.dart' as _i12;
import 'package:base/domain/repository/repository.dart' as _i8;
import 'package:base/presentation/home/bloc/home_bloc.dart' as _i7;
import 'package:connectivity_plus/connectivity_plus.dart' as _i3;
import 'package:dio/dio.dart' as _i5;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i6;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i11;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    final baseUrl = _$BaseUrl();
    gh.factory<_i3.Connectivity>(() => registerModule.connectivity);
    gh.factory<_i4.DeviceInfo>(() => _i4.DeviceInfo());
    gh.factory<_i5.Dio>(() => registerModule.dio);
    gh.factory<_i6.FlutterSecureStorage>(() => registerModule.secureStorage);
    gh.factory<_i7.HomeBloc>(() => _i7.HomeBloc());
    gh.factory<_i8.Repository>(() => _i9.RepositoryImpl());
    gh.factory<_i10.RestClient>(() => _i10.RestClient(
          gh<_i5.Dio>(),
          baseUrl: gh<String>(instanceName: 'baseUrl'),
        ));
    await gh.factoryAsync<_i11.SharedPreferences>(
      () => registerModule.sharedPreferences,
      preResolve: true,
    );
    gh.factory<String>(() => baseUrl.baseUrl);
    return this;
  }
}

class _$RegisterModule extends _i12.RegisterModule {}

class _$BaseUrl extends _i13.BaseUrl {}
