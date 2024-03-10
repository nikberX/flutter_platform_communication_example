// You have generated a new plugin project without specifying the `--platforms`
// flag. An FFI plugin project that supports no platforms is generated.
// To add platforms, run `flutter create -t plugin_ffi --platforms <platforms> .`
// in this directory. You can also find a detailed instruction on how to
// add platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'matrix_multiplyer_ffi_bindings_generated.dart';

int multiplyMatricesFfi(int dimensions) =>
    _bindings.multiplyMatrices(dimensions);

Future<int> multiplyMatricesFfiAsync(int dimensions) async {
  final SendPort helperIsolateSendPort = await _helperIsolateSendPort;
  final int requestId = _nextMultiplyRequestId++;
  final _MultiplyRequest request = _MultiplyRequest(requestId, dimensions);
  final Completer<int> completer = Completer<int>();
  _multiplyRequests[requestId] = completer;
  helperIsolateSendPort.send(request);
  return completer.future;
}

const String _libName = 'matrix_multiplyer_ffi';

/// The dynamic library in which the symbols for [MatrixMultiplyerFfiBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final MatrixMultiplyerFfiBindings _bindings =
    MatrixMultiplyerFfiBindings(_dylib);

/// A request to compute `multiply`.
///
/// Typically sent from one isolate to another.
class _MultiplyRequest {
  final int id;
  final int dimensions;

  const _MultiplyRequest(this.id, this.dimensions);
}

/// A response with the result of `multiply`.
///
/// Typically sent from one isolate to another.
class _MultiplyResponse {
  final int id;
  final int benchmark;

  const _MultiplyResponse(this.id, this.benchmark);
}

/// Counter to identify [_MultiplyRequest]s and [_MultiplyResponse]s.
int _nextMultiplyRequestId = 0;

/// Mapping from [_MultiplyRequest] `id`s to the completers corresponding to the correct future of the pending request.
final Map<int, Completer<int>> _multiplyRequests = <int, Completer<int>>{};

/// The SendPort belonging to the helper isolate.
Future<SendPort> _helperIsolateSendPort = () async {
  // The helper isolate is going to send us back a SendPort, which we want to
  // wait for.
  final Completer<SendPort> completer = Completer<SendPort>();

  // Receive port on the main isolate to receive messages from the helper.
  // We receive two types of messages:
  // 1. A port to send messages on.
  // 2. Responses to requests we sent.
  final ReceivePort receivePort = ReceivePort()
    ..listen((dynamic data) {
      if (data is SendPort) {
        // The helper isolate sent us the port on which we can sent it requests.
        completer.complete(data);
        return;
      }
      if (data is _MultiplyResponse) {
        // The helper isolate sent us a response to a request we sent.
        final Completer<int> completer = _multiplyRequests[data.id]!;
        _multiplyRequests.remove(data.id);
        completer.complete(data.benchmark);
        return;
      }
      throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
    });

  // Start the helper isolate.
  await Isolate.spawn((SendPort sendPort) async {
    final ReceivePort helperReceivePort = ReceivePort()
      ..listen((dynamic data) {
        // On the helper isolate listen to requests and respond to them.
        if (data is _MultiplyRequest) {
          final int result = _bindings.multiplyMatrices(data.dimensions);
          final _MultiplyResponse response = _MultiplyResponse(data.id, result);
          sendPort.send(response);
          return;
        }
        throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
      });

    // Send the port to the main isolate on which we can receive requests.
    sendPort.send(helperReceivePort.sendPort);
  }, receivePort.sendPort);

  // Wait until the helper isolate has sent us back the SendPort on which we
  // can start sending requests.
  return completer.future;
}();
