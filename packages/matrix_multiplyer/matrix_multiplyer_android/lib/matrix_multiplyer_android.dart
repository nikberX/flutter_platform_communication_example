import 'package:flutter/services.dart';
import 'package:matrix_multiplyer_platform_interface/matrix_multiplyer_platform_interface.dart';

class MatrixMultiplyerAndroid extends MatrixMultiplyerPlatform {
  static const MethodChannel _channel =
      MethodChannel('matrix_multiplyer_android');

  static void registerWith() {
    MatrixMultiplyerPlatform.instance = MatrixMultiplyerAndroid();
  }

  @override
  Future<int> multiplyMatrices(int dimensions) async =>
      await _channel.invokeMethod<int?>('multiplyMatrices', dimensions) ?? -1;
}
