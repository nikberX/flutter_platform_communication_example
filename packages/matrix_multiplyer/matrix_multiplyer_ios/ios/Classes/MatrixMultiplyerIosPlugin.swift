import Flutter
import UIKit

public class MatrixMultiplyerIosPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "matrix_multiplyer_ios", binaryMessenger: registrar.messenger())
    let instance = MatrixMultiplyerIosPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "multiplyMatrices":
      result(1)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
