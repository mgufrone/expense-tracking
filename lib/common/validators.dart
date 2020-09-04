String isEmpty(String value) {
  return value == null || value.trim() == '' ? 'is empty' : null;
}

String isNumber(String value) {
  return double.tryParse(value) > 0 ? null : 'must be more than one';
}

String textLimit(String value, int limit) {
  return value.length > limit ? 'length must below ${limit}' : null;
}
