import 'package:base/data/models/task/task_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'api.g.dart';

@RestApi()
@Injectable()
abstract class RestClient {
  @factoryMethod
  factory RestClient(Dio dio, {@Named('baseUrl') String baseUrl}) = _RestClient;

  @GET("/tasks")
  Future<List<TaskModel>> getTasks();
}
