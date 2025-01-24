import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

class GlucosePredictorPage extends StatefulWidget {
  @override
  _GlucosePredictorPageState createState() => _GlucosePredictorPageState();
}

class _GlucosePredictorPageState extends State<GlucosePredictorPage> {
  late tfl.Interpreter _interpreter;
  double? _predictedGlucose;

  // Sample wavelength data (Modify to match the model's expected 228 features)
  List<double> _sampleWavelengths = [
    0.361307025,
    0.372515172,
    0.378004164,
    0.388664007,
    0.390719324,
    0.393576622,
    0.400557309,
    0.408375055,
    0.41293183,
    0.424078971,
    0.429334104,
    0.43970716,
    0.448595375,
    0.459715158,
    0.470869064,
    0.480444998,
    0.487583548,
    0.493656635,
    0.498573899,
    0.502518773,
    0.504497826,
    0.508494973,
    0.509082437,
    0.511637866,
    0.512216628,
    0.512350976,
    0.51327759,
    0.515288651,
    0.516599059,
    0.516792953,
    0.516631186,
    0.517179251,
    0.518691719,
    0.519530356,
    0.520297408,
    0.520605683,
    0.523034453,
    0.52442193,
    0.525100708,
    0.526910543,
    0.529066324,
    0.531894386,
    0.534735978,
    0.538482785,
    0.539623678,
    0.543125093,
    0.546369493,
    0.550544143,
    0.55434525,
    0.55851382,
    0.562274814,
    0.566772461,
    0.571330309,
    0.575880229,
    0.580758214,
    0.585897148,
    0.591799617,
    0.59997654,
    0.610095561,
    0.622717679,
    0.638278246,
    0.657728255,
    0.674712241,
    0.692584276,
    0.70919466,
    0.721922278,
    0.731646955,
    0.73967272,
    0.747246802,
    0.752992153,
    0.757268608,
    0.761110723,
    0.766685963,
    0.774457872,
    0.776290059,
    0.78065145,
    0.783976078,
    0.783187449,
    0.785982728,
    0.785740912,
    0.787173271,
    0.786780357,
    0.787651896,
    0.789200246,
    0.787627339,
    0.788327277,
    0.787715256,
    0.7887128,
    0.78872925,
    0.789232373,
    0.790259838,
    0.791129708,
    0.791059673,
    0.794765055,
    0.795313597,
    0.797273576,
    0.80040139,
    0.802585542,
    0.806123912,
    0.810172379,
    0.813545227,
    0.818093002,
    0.823675036,
    0.830451727,
    0.836155891,
    0.842680097,
    0.851143599,
    0.859273076,
    0.870550692,
    0.880598962,
    0.89154619,
    0.903741717,
    0.916506529,
    0.928861022,
    0.946182847,
    0.96070081,
    0.974118352,
    0.989070296,
    1.00130522,
    1.01240838,
    1.02402246,
    1.03713858,
    1.04831648,
    1.0623486,
    1.07492745,
    1.09807086,
    1.1215378,
    1.14768374,
    1.17786026,
    1.21382797
  ]; // Ensure exactly 228 values

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter =
          await tfl.Interpreter.fromAsset('assets/glucose_model.tflite');
      _interpreter.allocateTensors(); // Ensure tensors are allocated
      print("✅ Model loaded successfully!");
      print(
          "Model Input Tensor: ${_interpreter.getInputTensor(0)}"); // Debug input shape
    } catch (e) {
      print("❌ Error loading model: $e");
    }
  }

  void _predictGlucose() {
    try {
      // Ensure input has exactly 228 features (Pad with zeros if necessary)
      while (_sampleWavelengths.length < 228) {
        _sampleWavelengths.add(0.0); // Padding with zeros
      }
      if (_sampleWavelengths.length > 228) {
        _sampleWavelengths = _sampleWavelengths.sublist(0, 228); // Trim excess
      }

      // Ensure input is a 2D list [[...features...]]
      var input = [_sampleWavelengths.map((e) => e.toDouble()).toList()];
      var output = List.filled(1, 0.0).reshape([1, 1]); // Output shape

      print("🔹 Running Inference with Input Shape: ${input[0].length}");

      // Run inference
      _interpreter.run(input, output);

      print("🔹 Model Output: $output");

      // Update UI with predicted glucose level
      setState(() {
        _predictedGlucose = output[0][0];
      });
    } catch (e) {
      print("❌ Error running inference: $e");
    }
  }

  @override
  void dispose() {
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Glucose Predictor")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Predict Blood Glucose Level",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _predictGlucose,
              child: Text("Run Prediction"),
            ),
            SizedBox(height: 20),
            if (_predictedGlucose != null)
              Text(
                  "Predicted Glucose Level: ${_predictedGlucose!.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}
