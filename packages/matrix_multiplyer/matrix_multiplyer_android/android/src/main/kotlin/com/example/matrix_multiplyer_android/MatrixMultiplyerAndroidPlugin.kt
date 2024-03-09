package com.example.matrix_multiplyer_android

import androidx.annotation.NonNull
import kotlin.system.measureNanoTime
import kotlin.random.Random

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import java.util.Timer

/** MatrixMultiplyerAndroidPlugin */
class MatrixMultiplyerAndroidPlugin: FlutterPlugin, MethodCallHandler, StreamHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var eventSink: EventSink? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "matrix_multiplyer_android")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "multiplyMatrices") {
      result.success(multiplyMatricesCall(call.arguments<Int?>() as Int))
      
    } else {
      result.notImplemented()
    }
  }


    // EventChannel.StreamHandler methods
    override fun onListen(arguments: Any?, eventSink: EventSink?) {
        // TODO: attach event sink
        this.eventSink = eventSink
    }

    override fun onCancel(arguments: Any?) {
        // TODO: detach event sink
        eventSink = null
    }

    fun multiplyMatricesCall(dimensions: Int): Long {
      var matrix1 = Array(dimensions) { IntArray(dimensions) { 0 } }
      var matrix2 = Array(dimensions) { IntArray(dimensions) { 0 } }

    fillMatrix(matrix1, dimensions)
    fillMatrix(matrix2, dimensions)

    val time = measureNanoTime {
      val result = multiplyMatrices(matrix1, matrix2)
    }

    return time / 1_000_000
  }

  fun fillMatrix(matrix: Array<IntArray>, n: Int) {
      for (i in 0 until n) {
          for (j in 0 until n) {
              matrix[i][j] = Random.nextInt(0, 1000)
          }
      }
  }



  fun multiplyMatrices(matrix1: Array<IntArray>, matrix2: Array<IntArray>): Array<IntArray> {
    val n = matrix1.size
    val result = Array(n) { IntArray(n) }

    for (i in 0 until n) {
        for (j in 0 until n) {
            var sum = 0
            for (k in 0 until n) {
                sum += matrix1[i][k] * matrix2[k][j]
            }
            result[i][j] = sum
        }
    }

    return result
}




  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
