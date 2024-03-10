import 'package:flutter/services.dart';
import 'package:matrix_multiplyer_platform_interface/matrix_multiplyer_platform_interface.dart';

class MatrixMultiplyerAndroid extends MatrixMultiplyerPlatform {
  static const MethodChannel _methodChannel =
      MethodChannel('matrix_multiplyer_android');

  static const EventChannel _eventChannel =
      EventChannel('matrix_multiplyer_android/events');

  /// При повторном вызове receiveBroadcastStream мы получим отдельный стрим
  /// При закрытии из разных мест выстрелит ошибка
  /// ```dart
  /// PlatformException: PlatformException(error, No active stream to cancel, null, null)
  /// 	at StandardMethodCodec.decodeEnvelope(package:flutter/src/services/message_codecs.dart:653)
  /// 	at MethodChannel._invokeMethod(package:flutter/src/services/platform_channel.dart:296)
  /// 	at EventChannel.receiveBroadcastStream.<fn>(package:flutter/src/services/platform_channel.dart:649)
  /// ```
  /// В ней не будет понятного стек-трейса и ее очень сложно будет обнаружить
  /// Поэтому кэшируем значение в переменную
  static Stream<dynamic>? _eventChannelStream;

  /// Вызывается plugin_platform_interface'ом для регистрации плагина в хостовом приложении
  static void registerWith() {
    MatrixMultiplyerPlatform.instance = MatrixMultiplyerAndroid();
  }

  @override
  Future<int> multiplyMatrices(int dimensions) async {
    final result = await _methodChannel.invokeMethod<int?>(
      'multiplyMatrices',
      dimensions,
    );
    return result ?? -1;
  }

  @override
  Future<int> multiplyMatricesError(int dimensions) async {
    final result = await _methodChannel.invokeMethod<int?>(
      'multiplyMatricesError',
      dimensions,
    );
    return result ?? -1;
  }

  @override
  Stream<int> timerStream() =>
      (_eventChannelStream ??= _eventChannel.receiveBroadcastStream())
          .cast<int>();
}
