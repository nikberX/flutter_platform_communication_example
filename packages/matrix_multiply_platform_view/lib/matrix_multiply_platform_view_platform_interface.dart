import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'matrix_multiply_platform_view_method_channel.dart';

abstract class MatrixMultiplyPlatformViewPlatform extends PlatformInterface {
  /// Constructs a MatrixMultiplyPlatformViewPlatform.
  MatrixMultiplyPlatformViewPlatform() : super(token: _token);

  static final Object _token = Object();

  static MatrixMultiplyPlatformViewPlatform _instance =
      MethodChannelMatrixMultiplyPlatformView();

  /// The default instance of [MatrixMultiplyPlatformViewPlatform] to use.
  ///
  /// Defaults to [MethodChannelMatrixMultiplyPlatformView].
  static MatrixMultiplyPlatformViewPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MatrixMultiplyPlatformViewPlatform] when
  /// they register themselves.
  static set instance(MatrixMultiplyPlatformViewPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
