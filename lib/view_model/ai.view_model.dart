import 'package:flutter/foundation.dart';
import 'package:signe_malo/models/controller/ai_controller.dart';
import 'package:signe_malo/models/objects/ai_result_object.dart';
import 'package:signe_malo/models/objects/exception.dart';
import 'package:signe_malo/utils/utils.dart';

class AiViewModel with ChangeNotifier {
  Status _gettingResponse = Status.initial;
  Status get gettingResponseStatus => _gettingResponse;
  List<AiResultObject> _response = [];
  List<AiResultObject> get response => _response;
  String _aiExceptionValue = "";
  String get aiExceptionValue => _aiExceptionValue;

  void getResponse({required List<Map<String, dynamic>> json}) async {
    _gettingResponse = Status.loading;
    notifyListeners();
    try {
      _response = await AiController().getGeminiResponse(json: json);
      _gettingResponse = Status.loaded;
      notifyListeners();
    } on AiException catch (e) {
      _gettingResponse = Status.loaded;
      _aiExceptionValue = e.unexceptedValue ?? "Unexpected Error";
      notifyListeners();
    } on Exception catch (e) {
      debugPrint(e.toString());
      _gettingResponse = Status.error;
      notifyListeners();
    } finally {
      _gettingResponse = Status.initial;
      _aiExceptionValue = "";
      notifyListeners();
    }
  }
}
