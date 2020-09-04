typedef T Impl<T>();

class LazyloadException implements Exception {}

class Lazyloader {
  static Lazyloader instance = Lazyloader._singleton();
  Lazyloader._singleton();

  Map<String, dynamic> holders = <String, dynamic>{};
  register<T>(Impl implementation) {
    holders.putIfAbsent(T.toString(), () => implementation());
  }

  resolve<T>() {
    if (holders.containsKey(T.toString())) {
      return holders[T.toString()];
    }
    throw LazyloadException();
  }
}

void register<T>(Impl implementation) {
  Lazyloader.instance.register<T>(implementation);
}

T resolve<T>() {
  return Lazyloader.instance.resolve<T>();
}
