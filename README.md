<!-- ── Language switch (EN active) ──────────────────────────────────── -->

<div align="left" style="margin:0 0 14px 0;">

<span style="display:inline-block;
padding:.28rem .6rem;
border:1px solid rgba(0,0,0,.18);
border-radius:10px 0 0 10px;
font-weight:400;
font-size:12px;
letter-spacing:.06em;
color:#111827;
background:linear-gradient(180deg,#ffffff,#e9edf2);
box-shadow:0 1px 0 rgba(0,0,0,.06);">
[RU]
</span><span style="display:inline-block;
margin-left:-1px;
padding:.28rem .6rem;
border:1px solid rgba(0,0,0,.14);
border-radius:0 10px 10px 0;
font-weight:400;
font-size:12px;
letter-spacing:.06em;
background:linear-gradient(180deg,#f3f4f6,#ffffff);
box-shadow:inset 0 2px 6px rgba(0,0,0,.10);">
EN
</span>

</div>
<!-- ────────────────────────────────────────────────────────────────── -->


# flutter_rustore_update

## [Documentation RuStore](https://help.rustore.ru/rustore/for_developers/developer-documentation/sdk_updates/flutter)

- [flutter\_rustore\_update](#flutter_rustore_update)
  - [Documentation RuStore](#documentation-rustore)
    - [General](#general)
    - [Example user scenario](#example-user-scenario)
    - [Preparing required parameters](#preparing-required-parameters)
    - [Setting up the sample app](#setting-up-the-sample-app)
    - [Conditions for correct SDK operation](#conditions-for-correct-sdk-operation)
    - [Example implementation](#example-implementation)
  - [Integration into the project](#integration-into-the-project)
  - [Checking for updates](#checking-for-updates)
  - [Downloading the update](#downloading-the-update)
    - [Deferred update](#deferred-update)
    - [Forced update](#forced-update)
    - [Silent update](#silent-update)
  - [Installing the update](#installing-the-update)
    - [Flexible update completion](#flexible-update-completion)
    - [Silent update completion](#silent-update-completion)
  - [Possible errors](#possible-errors)

### General

RuStore In-app updates SDK helps keep your app up to date on the user's device.

When users maintain their app in a current state, they can try out new features and also benefit from performance improvements and bug fixes.

You can use the RuStore In-app updates SDK to display an app update process that ensures background download and installation of the update with status control. The user will be able to use your app during the update download.

### Example user scenario

<img src="https://gitflic.ru/project/rustore/flutter-rustore-update/blob/raw?file=flow.png" alt="Update flow" height="400px">

### Preparing required parameters

To run the example, you need the following parameters:

1. `applicationId` - from the app you published in the RuStore console, is located in the build.gradle file of your project

```
  android {
     defaultConfig {
     applicationId = "ru.rustore.sdk.updateexample"
     }
  }
```

2. `release.keystore` - signature used to sign the app published in the RuStore console.

### Setting up the sample app

1. To test the example, upload two versions of the app to the console with different versionCodes. In testing, specify a smaller versionCode than what is in the console.

```
  defaultConfig {
    versionCode 1
  }
```

2. Replace `applicationId` in the example/android/app/build.gradle file with the applicationId of the apk file you published in the RuStore console:

```
android {
  defaultConfig {
    applicationId = "ru.rustore.sdk.updateexample" // Often .debug is appended in buildTypes
  }
}
```

3. Replace the signature with your app's signature. Configure `key_alias`, `key_password`, `store_password` parameters

```
android{
  signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
}
```

### Conditions for correct SDK operation

For RuStore In-app updates SDK to work correctly, the following conditions must be met:

- Android OS version 7.0 or higher.
- RuStore must be installed on the user's device.
- The RuStoreApp version on the user's device must be current.
- RuStore app must be allowed to install apps.

### Example implementation

To learn how to properly integrate the package for working with push notifications, it is recommended to familiarize yourself with the sample app

[https://gitflic.ru/project/rustore/flutter-rustore-update](https://gitflic.ru/project/rustore/flutter-rustore-update)

## Integration into the project

To add the package to the project, execute the command

```sh
flutter pub add flutter_rustore_update
```

This command adds a line to the pubspec.yaml file

```yml
dependencies:
    flutter_rustore_update: ^10.5.2
```

## Checking for updates

Before requesting an update, check if an update is available for your app. To check for updates, call the info() method. When calling this method, the following conditions are checked:

- RuStore must be installed on the user's device.
- The RuStoreApp version on the user's device must be current.
- The user and the app must not be blocked in RuStore.

In response to this method, you will receive an info object containing information about whether an update is needed.

```dart
RustoreUpdateClient.info().then((info) {
    print(info);
}).catchError((err) {
    print(err);
});
```

The info object contains a set of parameters necessary to determine update availability:

- updateAvailability - update availability:
- UPDATE_AVAILABILITY_NOT_AVAILABLE - no update needed.
- UPDATE_AVAILABILITY_AVAILABLE - update needs to be downloaded or already downloaded to the user's device.
- UPDATE_AVAILABILITY_IN_PROGRESS - update is being downloaded or installation has started.
- UPDATE_AVAILABILITY_UNKNOWN - default status.
- installStatus - installation status if the user is currently installing an update:
- INSTALL_STATUS_DOWNLOADED - downloaded.
- INSTALL_STATUS_DOWNLOADING - downloading.
- INSTALL_STATUS_FAILED - error.
- INSTALL_STATUS_INSTALLING - installing.
- INSTALL_STATUS_PENDING - pending.
- INSTALL_STATUS_UNKNOWN - default.

Downloading an update is only possible if the updateAvailability field contains the value UPDATE_AVAILABILITY_AVAILABLE.

The method may return an error. For more details, see the section ***Possible errors**.

## Downloading the update

After confirming update availability, you can request the user to download the update, but first you need to start listening to the update download status using the listener() method

```dart
RustoreUpdateClient.listener((value) {
  print("listener installStatus ${value.installStatus}");
  print("listener bytesDownloaded ${value.bytesDownloaded}");
  print("listener totalBytesToDownload ${value.totalBytesToDownload}");
  print("listener installErrorCode ${value.installErrorCode}");
 
  if (value.installStatus == INSTALL_STATUS_DOWNLOADED) {
    // here you can call the complete() method
  }
});
```

The state object describes the current status of the update download. The object contains:

- installStatus - installation status if the user is currently installing an update:
- INSTALL_STATUS_DOWNLOADED - downloaded.
- INSTALL_STATUS_DOWNLOADING - downloading.
- INSTALL_STATUS_FAILED - error.
- INSTALL_STATUS_INSTALLING - installing.
- INSTALL_STATUS_PENDING - pending.
- INSTALL_STATUS_UNKNOWN - default.
- bytesDownloaded - number of downloaded bytes.
- totalBytesToDownload - total number of bytes to download.
- installErrorCode - error code during download. More details about possible errors can be found in the **Possible errors** section.

### Deferred update

Download with UI from RuStore

To initiate the app update download, call the download() method.

```dart
RustoreUpdateClient.download().then((value) {
  print("download code ${value.code}");
}).catchError((err) {
  print("download err ${err}");
});
```

If the user confirms the update download, then value.code = ACTIVITY_RESULT_OK, if they decline, then value.code = ACTIVITY_RESULT_CANCELED.

After calling the method, you can monitor the update download status in the listener. If in the listener you receive the status INSTALL_STATUS_DOWNLOADED, then you can call the update installation method complete(). It is recommended to notify the user about the readiness of the update installation.

The method may return an error. More details about possible errors can be found in the **Possible errors** section.

### Forced update

Download with UI from RuStore

To initiate forced update download, call the `immediate()` method.

```js
RustoreUpdateClient.immediate().then((value) {
  print("silent code ${value.code}");
}).catchError((err) {
  print("immediate err ${err}");
});
```

`resultCode (Int)`:

- `ACTIVITY_RESULT_OK (-1)` — update completed, the code might not be received as the app may terminate during the update.
- `ACTIVITY_RESULT_CANCELED (0)` — flow interrupted by the user or an error occurred. It is assumed that upon receiving this code, the app should terminate.
- `ACTIVITY_RESULT_NOT_FOUND (2)` — RuStore is not installed, or an incompatible version is installed (`RuStore versionCode` < `191`).

`throwable` — error starting the update flow.

No further actions are required after successful update.

### Silent update

Download without UI from RuStore

For this type of update, it is recommended to implement your own interface.

To initiate silent update download, call the `silent()` method.

```js
RustoreUpdateClient.silent().then((value) {
  print("silent code ${value.code}");
}).catchError((err) {
  print("silent err ${err}");
});
```

Upon calling `then` with `code = ACTIVITY_RESULT_OK`, a task for downloading the update will be registered.

In this scenario, only `then` with `ACTIVITY_RESULT_OK` or `catchError` can be called.

After calling the method, you can monitor the update download status in the listener.

Once the status `INSTALL_STATUS_DOWNLOADED` is received, you can call the update installation method. It is recommended to notify the user about the readiness of the update for installation.

## Installing the update

### Flexible update completion

Update with UI from RuStore:

After downloading the APK file of the update, you can start installing the update. To initiate the update installation, call the completeUpdateFlexible() method.

```dart
RustoreUpdateClient.completeUpdateFlexible().catchError((err) {
  print("completeUpdateFlexible err ${err}");
});
```

1. A UI dialog for completing the update will be shown to the user.
2. In case of successful update, the app will restart.

The update is performed via the native Android tool. After a successful update, the app will restart.

### Silent update completion

Update without UI from RuStore:

After downloading the APK file of the update, you can start installing the update. To initiate the update installation, call the completeUpdateSilent() method.

```dart
RustoreUpdateClient.completeUpdateSilent().catchError((err) {
  print("completeUpdateSilent err ${err}");
});
```

1. The UI dialog for completing the update will not be shown.
2. In case of successful update, the app will close.

The update is performed via the native Android tool. After a successful update, the app will close.

Errors may occur during the update phase. More details about them can be found in the **Possible errors** section.

## Possible errors

If you get onFailure in response, do not display the error to the user yourself. Displaying the error may negatively affect the user experience.

List of possible errors:

- UPDATE_ERROR_DOWNLOAD - Error during download.
- UPDATE_ERROR_BLOCKED - Installation blocked by system.
- UPDATE_ERROR_INVALID_APK - Invalid APK update.
- UPDATE_ERROR_CONFLICT - Conflict with the current app version.
- UPDATE_ERROR_STORAGE - Insufficient storage on the device.
- UPDATE_ERROR_INCOMPATIBLE - Incompatible with the device.
- UPDATE_ERROR_APP_NOT_OWNED - App not purchased.
- UPDATE_ERROR_INTERNAL_ERROR - Internal error.
- UPDATE_ERROR_ABORTED - User declined the update installation.
- UPDATE_ERROR_APK_NOT_FOUND - APK for installation not found.
- UPDATE_ERROR_EXTERNAL_SOURCE_DENIED - Update launch denied. For example, in the first method, the response indicated that the update is unavailable, but the user calls the second method.

[ru]: README.ru.md
[en]: README.md
