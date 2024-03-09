import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'matrix_multiply_platform_view_platform_interface.dart';

class MatrixMultiplyPlatformView {
  Future<String?> getPlatformVersion() {
    return MatrixMultiplyPlatformViewPlatform.instance.getPlatformVersion();
  }
}

class NativeMatrixMultiplyView extends StatefulWidget {
  static const viewType = 'native_matrix_multiply';

  final bool useHybridComposition;
  const NativeMatrixMultiplyView({
    this.useHybridComposition = false,
    super.key,
  });

  @override
  State<NativeMatrixMultiplyView> createState() =>
      NativeMatrixMultiplyViewState();
}

class NativeMatrixMultiplyViewState extends State<NativeMatrixMultiplyView> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      if (!widget.useHybridComposition) {
        return AndroidView(
          viewType: NativeMatrixMultiplyView.viewType,
          creationParamsCodec: const StandardMessageCodec(),
          creationParams: "Example text",
          gestureRecognizers: {Factory(() => TapGestureRecognizer())},
        );
      } else {
        return PlatformViewLink(
          surfaceFactory: (_, __) {
            return Placeholder();
          },
          onCreatePlatformView: (_) {
            throw UnimplementedError();
          },
          viewType: NativeMatrixMultiplyView.viewType,
        );
      }
    }
    return const Placeholder();
  }
}
