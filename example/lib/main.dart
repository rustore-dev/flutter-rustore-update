import 'package:flutter/material.dart';
import 'package:flutter_rustore_update/const.dart';
import 'package:flutter_rustore_update/flutter_rustore_update.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int availableVersionCode = 0;
  int installStatus = 0;
  String packageName = "";
  int updateAvailability = 0;
  String error = "";

  @override
  void initState() {
    super.initState();

    RustoreUpdateClient.info().then((info) {
      setState(() {
        availableVersionCode = info.availableVersionCode;
        installStatus = info.installStatus;
        packageName = info.packageName;
        updateAvailability = info.updateAvailability;
      });
    }).catchError((err) {
      setState(() {
        error = err.toString();
      });
    });
  }

  void update() {
    RustoreUpdateClient.info().then((info) {
      setState(() {
        availableVersionCode = info.availableVersionCode;
        installStatus = info.installStatus;
        packageName = info.packageName;
        updateAvailability = info.updateAvailability;
      });

      if (info.updateAvailability == UPDATE_AILABILITY_AVAILABLE) {
        RustoreUpdateClient.listener((value) {
          print("listener installStatus ${value.installStatus}");
          print("listener bytesDownloaded ${value.bytesDownloaded}");
          print("listener totalBytesToDownload ${value.totalBytesToDownload}");
          print("listener installErrorCode ${value.installErrorCode}");

          if (value.installStatus == INSTALL_STATUS_DOWNLOADED) {
            RustoreUpdateClient.complete().catchError((err) {
              print("complete err ${err}");
            });
          }
        });

        RustoreUpdateClient.download().then((value) {
          print("download code ${value.code}");
          if (value.code == ACTIVITY_RESULT_CANCELED) {
            print("user cancel update");
          }
        }).catchError((err) {
          print("download err ${err}");
        });
      }
    }).catchError((err) {
      setState(() {
        print(err.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              OutlinedButton(onPressed: update, child: Text("Check update")),
              Text('availableVersionCode: $availableVersionCode'),
              Text('installStatus: $installStatus'),
              Text('packageName: $packageName'),
              Text('updateAvailability: $updateAvailability'),
              Text('error: $error'),
            ],
          ),
        ),
      ),
    );
  }
}
