import 'dart:async';

import 'package:expense/common/storage.dart';

class NoOpStorage<T> implements CommonStorage<T> {
  List<T> data;
  StreamController<List<T>> controller;
  NoOpStorage() : controller = StreamController();
  Stream<List<T>> getStream() {
    return controller.stream;
  }

  @override
  void save(List<T> data) async {
    this.data = data;
    controller.add(this.data);
  }

  @override
  FutureOr<List<T>> getData() {
    return data;
  }

  @override
  void initialize() {
    // do nothing as it is loaded from memory
    // we could add some seeder here
  }
}
