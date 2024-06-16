
import 'package:signe_malo/models/objects/ai_result_object.dart';
import 'package:signe_malo/models/services/ai/ai_services_impl.dart';

class AiController {
  Future<List<AiResultObject>> getGeminiResponse(
      {required List<Map<String, dynamic>> json}) async {
    try {
      final response =
          await AiServicesImpl().getGeminiResponse(posesJson: json);
      final results = response["result"];
      return List.from(results).map((e) => AiResultObject.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
