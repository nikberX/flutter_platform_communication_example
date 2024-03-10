library matrix_multiplyer;

import 'package:matrix_multiplyer_platform_interface/matrix_multiplyer_platform_interface.dart';

class MatrixMultiplyer {
  static MatrixMultiplyerPlatform get _platform =>
      MatrixMultiplyerPlatform.instance;

  Future<int> multiplyMatrices(int dimensions) =>
      _platform.multiplyMatrices(dimensions);

  Stream<int> timerStream() => _platform.timerStream();
}
