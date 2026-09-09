import 'dart:async';

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
  StreamSubscription<RequestResponse>? _updateSubscription;
  Future<void> Function()? _completeUpdate;
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

  String get _installStatusLabel {
    switch (InstallStatus.fromValue(installStatus)) {
      case InstallStatus.downloaded:
        return 'INSTALL DOWNLOADED';
      case InstallStatus.downloading:
        return 'INSTALL DOWNLOADING';
      case InstallStatus.failed:
        return 'INSTALL FAILED';
      case InstallStatus.installing:
        return 'INSTALL INSTALLING';
      case InstallStatus.pending:
        return 'INSTALL PENDING';
      case InstallStatus.unknown:
        return 'INSTALL UNKNOWN';
    }
  }

  String get _updateAvailabilityLabel {
    switch (UpdateAvailability.fromValue(updateAvailability)) {
      case UpdateAvailability.available:
        return 'UPDATE AVAILABLE';
      case UpdateAvailability.inProgress:
        return 'UPDATE IN PROGRESS';
      case UpdateAvailability.notAvailable:
        return 'UPDATE NOT AVAILABLE';
      case UpdateAvailability.unknown:
        return 'UPDATE UNKNOWN';
    }
  }

  @override
  void initState() {
    super.initState();
    _updateSubscription = RustoreUpdateClient.stateStream.listen((value) {
      print("listener installStatus ${value.installStatus}");
      print("listener bytesDownloaded ${value.bytesDownloaded}");
      print("listener totalBytesToDownload ${value.totalBytesToDownload}");
      print("listener installErrorCode ${value.installErrorCode}");

      if (!mounted) {
        return;
      }

      setState(() {
        installStatus = value.installStatus;
        bytesDownloaded = value.bytesDownloaded;
        totalBytesToDownload = value.totalBytesToDownload;
        installErrorCode = value.installErrorCode;
      });

      if (value.installStatusValue == InstallStatus.downloaded) {
        final completeUpdate = _completeUpdate;
        _completeUpdate = null;
        if (completeUpdate == null) {
          return;
        }

        completeUpdate().catchError((err) {
          print("completeUpdateFlexible err ${err}");
          if (!mounted) {
            return;
          }

          setState(() {
            completeErr = err.message;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _updateSubscription?.cancel();
    super.dispose();
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

      if (info.updateAvailabilityValue == UpdateAvailability.available) {
        _completeUpdate = RustoreUpdateClient.completeUpdateFlexible;
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

      if (info.updateAvailabilityValue == UpdateAvailability.available) {
        _completeUpdate = null;
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

      if (info.updateAvailabilityValue == UpdateAvailability.available) {
        _completeUpdate = RustoreUpdateClient.completeUpdateSilent;
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
                    Text('installStatus: $installStatus ($_installStatusLabel)'),
                    Text('packageName: $packageName'),
                    Text(
                        'updateAvailability: $updateAvailability ($_updateAvailabilityLabel)'),
                    Text('error: $infoErr'),
                  ],
                ),
                SizedBox(height: 48),
                Row(
                  children: [
                    OutlinedButton(onPressed: update, child: Text("Update")),
                    SizedBox(width: 12),
                    OutlinedButton(
                        onPressed: immediate, child: Text("Hard update")),
                    SizedBox(width: 12),
                    OutlinedButton(
                        onPressed: silent, child: Text("Silent update")),
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
