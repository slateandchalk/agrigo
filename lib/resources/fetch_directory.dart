import 'dart:io';
import 'dart:typed_data';

import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    final myDir = Directory('${directory.path}/Agrigo/0.0.1-dev');
    if (await myDir.exists()) {
      //print(myDir.path);
      return myDir.path;
    } else {
      final createDir = Directory('${directory.path}/Agrigo/0.0.1-dev')
          .create(recursive: true)
          .then((value) {
        return value.path;
      });
      return createDir;
    }
  }

  Future<File> get _localFarmer async {
    final path = await _localPath;
    return File('$path/farmer.json');
  }

  Future<bool> checkFarmerModified() async {
    final path = await _localPath;
    return File('$path/farmer.json').lastModifiedSync().day ==
            DateTime.now().day &&
        File('$path/farmer.json').lastModifiedSync().year ==
            DateTime.now().year &&
        File('$path/farmer.json').lastModifiedSync().month ==
            DateTime.now().month;
  }

  Future<bool> setFarmerModified() async {
    final path = await _localPath;
    await File('$path/farmer.json')
        .setLastModified(DateTime(2021, 7, 21, 17, 30));
    return true;
  }

  Future<String> readFarmerCounter() async {
    try {
      final file = await _localFarmer;
      // Read the file
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return 'false';
    }
  }

  Future<File> writeFarmerCounter(dynamic counter) async {
    final file = await _localFarmer;

    // Write the file
    return file.writeAsString('$counter');
  }

  Future<File> get _localSample async {
    final path = await _localPath;
    return File('$path/sample.json');
  }

  Future<bool> checkSampleModified() async {
    final path = await _localPath;
    return File('$path/sample.json').lastModifiedSync().day ==
            DateTime.now().day &&
        File('$path/sample.json').lastModifiedSync().year ==
            DateTime.now().year &&
        File('$path/sample.json').lastModifiedSync().month ==
            DateTime.now().month;
  }

  Future<bool> setSampleModified() async {
    final path = await _localPath;
    await File('$path/sample.json')
        .setLastModified(DateTime(2021, 7, 21, 17, 30));
    return true;
  }

  Future<String> readSampleCounter() async {
    try {
      final file = await _localSample;
      // Read the file
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return 'false';
    }
  }

  Future<File> writeSampleCounter(dynamic counter) async {
    final file = await _localSample;

    // Write the file
    return file.writeAsString('$counter');
  }

  Future<File> get _localReport async {
    final path = await _localPath;
    return File('$path/report.json');
  }

  Future<bool> checkReportModified() async {
    final path = await _localPath;
    return File('$path/report.json').lastModifiedSync().day ==
            DateTime.now().day &&
        File('$path/report.json').lastModifiedSync().year ==
            DateTime.now().year &&
        File('$path/report.json').lastModifiedSync().month ==
            DateTime.now().month;
  }

  Future<bool> setReportModified() async {
    final path = await _localPath;
    await File('$path/report.json')
        .setLastModified(DateTime(2021, 7, 21, 17, 30));
    return true;
  }

  Future<String> readReportCounter() async {
    try {
      final file = await _localReport;
      // Read the file
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return 'false';
    }
  }

  Future<File> writeReportCounter(dynamic counter) async {
    final file = await _localReport;

    // Write the file
    return file.writeAsString('$counter');
  }

  Future<int> getPicturesCount() async {
    final path = await _localPath;
    final count = await Directory('$path/farmerProfilePictures')
        .list(recursive: true, followLinks: false)
        .length;
    return count;
  }

  Future<bool> writePicturesCounter(
      Uint8List fileData, String farmerNumber) async {
    final path = await _localPath;
    // Write the file
    const fileMimeType = 'image/jpeg';
    final textFile =
        XFile.fromData(fileData, mimeType: fileMimeType, name: farmerNumber);
    await textFile.saveTo('$path\\farmerProfilePictures\\$farmerNumber');
    return true;
  }

  Future<bool> checkPicturesCounter(String farmerNumber) async {
    final path = await _localPath;

    return Directory('$path/farmerProfilePictures/$farmerNumber').existsSync();
  }

  Future<String> getLastFetch() async {
    final path = await _localPath;
    final count = File('$path/report.json').lastModifiedSync();
    return DateFormat("MMM dd, yyyy HH:mm").format(count);
  }

  Future<File> get _localKural async {
    final path = await _localPath;
    return File('$path/kural.json');
  }

  Future<String> readKuralCounter() async {
    try {
      final file = await _localKural;
      // Read the file
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return 'false';
    }
  }
}
