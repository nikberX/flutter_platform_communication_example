import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'matrix_multiply_platform_view_platform_interface.dart';

/// An implementation of [MatrixMultiplyPlatformViewPlatform] that uses method channels.
class MethodChannelMatrixMultiplyPlatformView
    extends MatrixMultiplyPlatformViewPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('matrix_multiply_platform_view');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
