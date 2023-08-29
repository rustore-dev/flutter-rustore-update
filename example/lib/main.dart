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
  String infoErr = "";

  int bytesDownloaded = 0;
  int totalBytesToDownload = 0;
  int installErrorCode = 0;

  String completeErr = "";
  int installCode = 0;

  String updateError = "";
  String silentError = "";
  String immediateError = "";

  @override
  void initState() {
    super.initState();
  }

  void info() {
    RustoreUpdateClient.info().then((info) {
      setState(() {
        availableVersionCode = info.availableVersionCode;
        installStatus = info.installStatus;
        packageName = info.packageName;
        updateAvailability = info.updateAvailability;
      });
    }).catchError((err) {
      print(err);
      setState(() {
        infoErr = err.message;
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

          setState(() {
            installStatus = value.installStatus;
            bytesDownloaded = value.bytesDownloaded;
            totalBytesToDownload = value.totalBytesToDownload;
            installErrorCode = value.installErrorCode;
          });

          if (value.installStatus == INSTALL_STATUS_DOWNLOADED) {
            RustoreUpdateClient.complete().catchError((err) {
              print("complete err ${err}");
              setState(() {
                completeErr = err.message;
              });
            });
          }
        });

        RustoreUpdateClient.download().then((value) {
          print("download code ${value.code}");
          setState(() {
            installCode = value.code;
          });
          if (value.code == ACTIVITY_RESULT_CANCELED) {
            print("user cancel update");
          }
        }).catchError((err) {
          print("download err ${err}");
          setState(() {
            updateError = err.message;
          });
        });
      }
    }).catchError((err) {
      print(err.toString());
      setState(() {
        infoErr = err.message;
      });
    });
  }

  void immediate() {
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

          setState(() {
            installStatus = value.installStatus;
            bytesDownloaded = value.bytesDownloaded;
            totalBytesToDownload = value.totalBytesToDownload;
            installErrorCode = value.installErrorCode;
          });

          if (value.installStatus == INSTALL_STATUS_DOWNLOADED) {
            RustoreUpdateClient.complete().catchError((err) {
              print("complete err ${err}");
              setState(() {
                completeErr = err.message;
              });
            });
          }
        });

        RustoreUpdateClient.immediate().then((value) {
          print("immediate code ${value.code}");
          setState(() {
            installCode = value.code;
          });
        }).catchError((err) {
          print("immediate err ${err}");
          setState(() {
            immediateError = err.message;
          });
        });
      }
    }).catchError((err) {
      print(err.toString());
      setState(() {
        infoErr = err.message;
      });
    });
  }

  void silent() {
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

          setState(() {
            installStatus = value.installStatus;
            bytesDownloaded = value.bytesDownloaded;
            totalBytesToDownload = value.totalBytesToDownload;
            installErrorCode = value.installErrorCode;
          });

          if (value.installStatus == INSTALL_STATUS_DOWNLOADED) {
            RustoreUpdateClient.complete().catchError((err) {
              print("complete err ${err}");

              setState(() {
                completeErr = err.message;
              });
            });
          }
        });

        RustoreUpdateClient.silent().then((value) {
          print("silent code ${value.code}");
          setState(() {
            installCode = value.code;
          });
        }).catchError((err) {
          print("silent err ${err}");
          setState(() {
            silentError = err.message;
          });
        });
      }
    }).catchError((err) {
      print(err.toString());
      setState(() {
        infoErr = err.message;
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
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OutlinedButton(onPressed: info, child: Text("Check update")),
                SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Info:'),
                    Text('availableVersionCode: $availableVersionCode'),
                    Text('installStatus: $installStatus'),
                    Text('packageName: $packageName'),
                    Text('updateAvailability: $updateAvailability'),
                    Text('error: $infoErr'),
                  ],
                ),
                SizedBox(height: 48),
                Row(
                  children: [
                    OutlinedButton(onPressed: update, child: Text("Update")),
                    SizedBox(width: 24),
                    OutlinedButton(onPressed: immediate, child: Text("Hard update")),
                    SizedBox(width: 24),
                    OutlinedButton(onPressed: silent, child: Text("Silent update")),
                  ],
                ),
                SizedBox(height: 48),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Install:'),
                    Text('bytesDownloaded: $bytesDownloaded'),
                    Text('totalBytesToDownload: $totalBytesToDownload'),
                    Text('installErrorCode: $installErrorCode'),
                    Text('completeErr: $completeErr'),
                    Text('installCode: $installCode'),
                    SizedBox(height: 12),
                    Text('Errors'),
                    Text('updateError: $updateError'),
                    Text('silentError: $silentError'),
                    Text('immediateError: $immediateError'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
