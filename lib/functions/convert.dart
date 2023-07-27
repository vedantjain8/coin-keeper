Map<String, double> listToMap(List inputData) {
  return inputData.fold<Map<String, double>>({}, (result, item) {
    final category = item["asHead"];
    final totalAmount = item["totalAmount"];
    result[category] = totalAmount.toDouble();
    return result;
  });
}
