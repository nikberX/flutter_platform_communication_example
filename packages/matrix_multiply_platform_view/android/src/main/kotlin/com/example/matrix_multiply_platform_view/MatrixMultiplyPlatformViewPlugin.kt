package com.example.matrix_multiply_platform_view

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import kotlin.system.measureNanoTime
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.content.Context
import android.view.View
import android.widget.Button
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import kotlin.random.Random
import kotlin.system.measureNanoTime

/** MatrixMultiplyPlatformViewPlugin */
class MatrixMultiplyPlatformViewPlugin: FlutterPlugin {

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    flutterPluginBinding.platformViewRegistry.registerViewFactory(
      ButtonPlatformViewFactory.TYPE,
      ButtonPlatformViewFactory(flutterPluginBinding),
    )
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {}
}

class ButtonPlatformViewFactory(private val flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) :
  PlatformViewFactory(StandardMessageCodec.INSTANCE) {
  
  override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
    return ButtonPlatformView(context!!, viewId, args as String, flutterPluginBinding)
  }

  companion object {
    const val TYPE = "native_matrix_multiply";
  }
}


class ButtonPlatformView(
  context: Context,
  id: Int,
  creationParams: String,
  flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
) : PlatformView {

  var count = 0

  private val button = Button(context).apply {
    text = "Tap to start count"
    setOnClickListener {
      this.text = "Counted $count";
      count++;
    }
  }


  override fun getView(): View {
    return button
  }

  override fun dispose() {

  }
}