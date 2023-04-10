import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable()
class SharedPrefDataSource {
  final SharedPreferences _sharedPreferences;

  SharedPrefDataSource(this._sharedPreferences);
}
