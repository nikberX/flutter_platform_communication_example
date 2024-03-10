import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class MatrixMultiplyerPlatform extends PlatformInterface {
  MatrixMultiplyerPlatform() : super(token: _token);

  static final Object _token = Object();

  static MatrixMultiplyerPlatform _instance = _PlaceholderImplementation();

  static MatrixMultiplyerPlatform get instance => _instance;

  static set instance(MatrixMultiplyerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Перемножает квадратные матрицы со случайными целыми числами размера dimensions
  ///
  /// Возвращает количество миллисекунд, равное продолжительности исполнения кода перемножения
  Future<int> multiplyMatrices(int dimensions) => throw UnimplementedError(
        'MatrixMultiplyerPlatform has not been implemented',
      );

  /// Вызывает result.error на стороне натива
  Future<int> multiplyMatricesError(int dimensions) => throw UnimplementedError(
        'MatrixMultiplyerPlatform has not been implemented',
      );

  /// Периодически возвращает инерементируемые значения
  Stream<int> timerStream() => throw UnimplementedError(
        'MatrixMultiplyerPlatform has not been implemented',
      );
}

class _PlaceholderImplementation extends MatrixMultiplyerPlatform {}
