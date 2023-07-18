bool isNumeric(String? result) {
  if (result == null || result == "") {
    return false;
  }
  return double.tryParse(result) != null;
}
