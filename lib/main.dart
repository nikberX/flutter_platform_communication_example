import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:matrix_multiplyer/matrix_multiplyer.dart';
import 'package:matrix_multiplyer_ffi/matrix_multiplyer_ffi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter platform communications example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Multiply matrix benchmarks'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double sliderValue = 100;
  final random = Random(DateTime.now().millisecondsSinceEpoch);

  bool calculating = false;

  int dartResultMs = 0;
  int nativeResultMs = 0;
  int ffiResultMs = 0;

  int dartTotal = 0;
  int nativeTotal = 0;
  int ffiTotal = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Spacer(flex: 1),
              const Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
              const SizedBox(height: 15),
              dimensionBlock(),
              dartIsolateBlock(),
              nativeBlock(),
              ffiBlock(),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: calculating ? null : _onRecalculatePressed,
                  child: const Text(
                    'Recalculate',
                    style: _defaultTextStyle,
                  ),
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget dimensionBlock() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Matrix dimension: $sliderValue',
            style: _defaultTextStyle,
          ),
          const SizedBox(height: 5),
          Slider(
            value: sliderValue,
            onChanged: (val) => setState(() {
              sliderValue = val;
            }),
            label: 'Matrix dimension',
            min: 100,
            divisions: 10,
            max: 1000,
          ),
        ],
      );

  Widget dartIsolateBlock() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Colors.black),
          Text(
            'Dart matrix multiply bench in ms: $dartResultMs ms',
            style: _defaultTextStyle,
          ),
          const SizedBox(height: 5),
          Text(
            'Dart total time in ms: $dartTotal ms',
            style: _defaultTextStyle,
          ),
          const SizedBox(height: 5),
          Text(
            'Dart diff: ${dartTotal - dartResultMs} ms',
            style: _defaultTextStyle,
          ),
          const SizedBox(height: 5),
        ],
      );

  Widget nativeBlock() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Colors.black),
          Text(
            'Native matrix multiply bench in ms: $nativeResultMs ms',
            style: _defaultTextStyle,
          ),
          const SizedBox(height: 5),
          Text(
            'Native total time in ms: $nativeTotal ms',
            style: _defaultTextStyle,
          ),
          const SizedBox(height: 5),
          Text(
            'Native diff: ${nativeTotal - nativeResultMs} ms',
            style: _defaultTextStyle,
          ),
          const SizedBox(height: 5),
        ],
      );

  Widget ffiBlock() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Colors.black),
          Text(
            'Ffi matrix multiply bench in ms: $ffiResultMs ms',
            style: _defaultTextStyle,
          ),
          const SizedBox(height: 5),
          Text(
            'Ffi total time in ms: $ffiTotal ms',
            style: _defaultTextStyle,
          ),
          const SizedBox(height: 5),
          Text(
            'Ffi diff: ${ffiTotal - ffiResultMs} ms',
            style: _defaultTextStyle,
          ),
          const SizedBox(height: 5),
        ],
      );

  void _onRecalculatePressed() async {
    if (calculating) {
      return;
    }
    setState(() {
      calculating = true;
    });

    await _doCalculations();

    setState(() {
      calculating = false;
    });
  }

  Future<void> _doCalculations() async {
    final stopwatch = Stopwatch()..start();
    final dartIsolateBench =
        await compute(multiplyMatrices, sliderValue.toInt());
    stopwatch.stop();
    dartTotal = stopwatch.elapsedMilliseconds;
    stopwatch.reset();
    stopwatch.start();
    final nativeBench =
        await MatrixMultiplyer().multiplyMatrices(sliderValue.toInt());
    stopwatch.stop();
    nativeTotal = stopwatch.elapsedMilliseconds;
    stopwatch.reset();
    stopwatch.start();

    final ffiBench = multiplyMatrices(sliderValue.toInt());
    stopwatch.stop();
    ffiTotal = stopwatch.elapsedMilliseconds;

    setState(() {
      dartResultMs = dartIsolateBench;
      nativeResultMs = nativeBench;
      ffiResultMs = ffiBench;
    });
  }

  static int multiplyMatrices(int dimensions) {
    final List<List<int>> matrix1 = [];
    final List<List<int>> matrix2 = [];

    final random = Random(DateTime.now().millisecondsSinceEpoch);

    for (int i = 0; i < dimensions; ++i) {
      matrix1.add([]);
      matrix2.add([]);
    }

    for (final subMatrix in matrix1) {
      for (int i = 0; i < dimensions; ++i) {
        subMatrix.add(random.nextInt(1000));
      }
    }

    for (final subMatrix in matrix2) {
      for (int i = 0; i < dimensions; ++i) {
        subMatrix.add(random.nextInt(1000));
      }
    }

    List<List<int>> result =
        List.generate(dimensions, (index) => List.filled(dimensions, 0));

    final stopwatch = Stopwatch()..start();

    final n = dimensions;

    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        for (int k = 0; k < n; k++) {
          result[i][j] += matrix1[i][k] * matrix2[k][j];
        }
      }
    }

    stopwatch.stop();

    return stopwatch.elapsedMilliseconds;
  }
}

const TextStyle _defaultTextStyle =
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
