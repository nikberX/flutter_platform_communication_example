package com.example.matrix_multiplyer_android

import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.Timer
import java.util.TimerTask
import kotlin.random.Random
import kotlin.system.measureNanoTime


/** MatrixMultiplyerAndroidPlugin */
class MatrixMultiplyerAndroidPlugin : FlutterPlugin, MethodCallHandler, StreamHandler {
    /// Платформенный канал методов
    private lateinit var methodChannel: MethodChannel

    /// EventChannel
    private lateinit var eventChannel: EventChannel

    /// EventSink для событий из EventChannel. Их получаем на стороне dart.
    private var eventSink: EventSink? = null

    private lateinit var timer: Timer
    private lateinit var handler: Handler

    private var currentRunnable : Runnable? = null


    var count = 0;

    // overriden method from flutter plugin
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel =
            MethodChannel(flutterPluginBinding.binaryMessenger, "matrix_multiplyer_android")
        methodChannel.setMethodCallHandler(this)

        eventChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, "matrix_multiplyer_android/events")
        eventChannel.setStreamHandler(this)

        timer = Timer()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "multiplyMatrices" -> handleMultiplyMatrices(call, result)
            "multiplyMatricesError" -> handleMultiplyMatricesError(call, result)
            else -> {
                // Обязательно падаем в notImplemented по-умолчанию если название метода не совпало
                // Иначе будем бесконечно висеть на await на стороне dart
                // Постоянные висящие await = утечка памяти
                result.notImplemented()
            }
        }
    }

    // Вызывается когда есть слушатели на стороне dart
    override fun onListen(arguments: Any?, eventSink: EventSink?) {
        this.eventSink = eventSink

        handler = Handler(Looper.getMainLooper())
        currentRunnable = object : Runnable {
            override fun run() {
                eventSink?.success(count++)

                val runnable = currentRunnable
                if (runnable != null) {
                    handler.postDelayed(runnable, 3000)
                }

            }
        }
        handler.postDelayed(currentRunnable as Runnable, 3000)
    }

    // Вызывается когда сторона dart перестает слушать EventChannel
    override fun onCancel(arguments: Any?) {
        eventSink = null

        timer.cancel()
    }

    fun sendTick() {
        eventSink?.success(count++)
        currentRunnable = null
    }

    fun handleMultiplyMatrices(call: MethodCall, result: Result) {
        val dimensions = call.arguments<Int?>() as Int
        val multiplyBench = multiplyMatricesCall(dimensions)
        result.success(multiplyBench)
    }

    fun handleMultiplyMatricesError(call: MethodCall, result: Result) {
        result.error("callError", "Called Error Method", "e.g. stacktrace")
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
}
