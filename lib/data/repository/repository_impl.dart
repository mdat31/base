
import 'package:base/domain/repository/repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: Repository)
class RepositoryImpl extends Repository {
  @override
  Future getSomething() {
    // TODO: implement getSomething
    throw UnimplementedError();
  }
}