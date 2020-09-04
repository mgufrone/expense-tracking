import 'dart:async';

abstract class CommonStorage<T> {
  Stream getStream();
  void save(List<T> data);
  void initialize();
  FutureOr<List<T>> getData();
}
