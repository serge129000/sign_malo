class AiResultObject {
  final String result;
  final int probability;
  final Map<String, dynamic> additionalInfo;
  AiResultObject(
      {required this.result,
      required this.probability,
      required this.additionalInfo});
  factory AiResultObject.fromJson(_) => AiResultObject(
      result: _['result'],
      probability: _['probability'] as int,
      additionalInfo: _['additional_info']);
}
