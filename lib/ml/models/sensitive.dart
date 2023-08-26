// import 'package:firebase_core/firebase_core.dart';
// // import 'package:firebase_ml_custom/firebase_ml_custom.dart';


// // val conditions = CustomModelDownloadConditions.Builder()
// //     .requireWifi()
// //     .build()
// // FirebaseModelDownloader.getInstance()
// //     .getModel("sensitive-contents", DownloadType.LOCAL_MODEL, conditions)
// //     .addOnCompleteListener {
// //       // Download complete. Depending on your app, you could enable the ML
// //       // feature, or switch from the local model to the remote model, etc.
// //     }
// import 'package:firebase_ml_custom/firebase_ml_custom.dart';

// Future<void> runCustomModel() async {
//   final modelManager = FirebaseModelManager.instance;
//   final customModel = await modelManager.registerCloudModelSource(
//     FirebaseCustomRemoteModel('sensitive-contents'),
//   );

//   if (customModel != null && customModel.status == FirebaseModelDownloadStatus.downloaded) {
//     final interpreterOptions = FirebaseModelInterpreterOptions([customModel]);
//     final interpreter = FirebaseModelInterpreter.instance;
//     final inputOutputOptions = await interpreter.getInputOutputOptions(customModel);

//     // Perform inference using the custom model
//     final inputs = <String, dynamic>{
//        bool toxic = models().toxicComments(imagetext);
//        bool sensitive = models().sensitiveContents(imagetext);
//     };
//     final outputs = <String, dynamic>{
//       bool toxic = models().toxicComments(imagetext);
//       bool sensitive = models().sensitiveContents(imagetext);
//     };

//     final results = await interpreter.run(
//       inputOutputOptions,
//       inputs: inputs,
//       outputs: outputs,
//     );

//     // Process the inference results
//   } else {
//     // Model download failed or not available
//   }
// }
