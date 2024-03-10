import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class NativeClickerView extends StatefulWidget {
  static const viewType = 'native_matrix_multiply';

  final bool useHybridComposition;

  const NativeClickerView({
    this.useHybridComposition = false,
    super.key,
  });

  @override
  State<NativeClickerView> createState() => NativeClickerViewState();
}

class NativeClickerViewState extends State<NativeClickerView> {
  static const initialText = 'Example text';

  void _onPlatformViewCreated(int id) {
    // do some logic
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return UiKitView(
        onPlatformViewCreated: _onPlatformViewCreated,
        viewType: NativeClickerView.viewType,
        creationParams: initialText,
        creationParamsCodec: const StandardMessageCodec(),
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory(() => TapGestureRecognizer())
        },
      );
    }
    if (Platform.isAndroid) {
      if (!widget.useHybridComposition) {
        // use virtual display
        return AndroidView(
          viewType: NativeClickerView.viewType,
          creationParamsCodec: const StandardMessageCodec(),
          creationParams: initialText,
          gestureRecognizers: {
            // https://api.flutter.dev/flutter/widgets/PlatformViewSurface/gestureRecognizers.html
            Factory(
              () => TapGestureRecognizer(),
            ),
          },
        );
      } else {
        // use hybrid composition
        return PlatformViewLink(
          viewType: NativeClickerView.viewType,
          surfaceFactory: (
            BuildContext context,
            PlatformViewController controller,
          ) {
            return AndroidViewSurface(
              controller: controller as AndroidViewController,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory(() => LongPressGestureRecognizer())
              },
              hitTestBehavior: PlatformViewHitTestBehavior.opaque,
            );
          },
          onCreatePlatformView: (PlatformViewCreationParams params) {
            return PlatformViewsService.initExpensiveAndroidView(
              id: params.id,
              viewType: params.viewType,
              onFocus: () => params.onFocusChanged(true),
              layoutDirection: TextDirection.ltr,
              creationParams: initialText,
              creationParamsCodec: const StandardMessageCodec(),
            )
              ..addOnPlatformViewCreatedListener(_onPlatformViewCreated)
              ..create();
          },
        );
      }
    }
    return const Placeholder();
  }
}
