import 'package:flutter_rustore_update/const.dart';
import 'package:flutter_rustore_update/pigeons/rustore.dart';

enum InstallStatus {
  unknown(INSTALL_STATUS_UNKNOWN, 'Install status is unknown.'),
  downloaded(INSTALL_STATUS_DOWNLOADED, 'Update package has been downloaded.'),
  downloading(INSTALL_STATUS_DOWNLOADING, 'Update package is downloading.'),
  failed(INSTALL_STATUS_FAILED, 'Update flow failed.'),
  installing(INSTALL_STATUS_INSTALLING, 'Update is being installed.'),
  pending(INSTALL_STATUS_PENDING, 'Update is pending user or system action.');

  const InstallStatus(this.value, this.description);

  final int value;
  final String description;

  static InstallStatus fromValue(int value) {
    return InstallStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => InstallStatus.unknown,
    );
  }
}

enum UpdateAvailability {
  unknown(UPDATE_AVAILABILITY_UNKNOWN, 'Update availability is unknown.'),
  notAvailable(UPDATE_AVAILABILITY_NOT_AVAILABLE, 'No update is available.'),
  available(
    UPDATE_AVAILABILITY_AVAILABLE,
    'An update is available or already downloaded.',
  ),
  inProgress(
    UPDATE_AVAILABILITY_IN_PROGRESS,
    'Update download or installation is already in progress.',
  );

  const UpdateAvailability(this.value, this.description);

  final int value;
  final String description;

  static UpdateAvailability fromValue(int value) {
    return UpdateAvailability.values.firstWhere(
      (availability) => availability.value == value,
      orElse: () => UpdateAvailability.unknown,
    );
  }
}

enum RustoreUpdateError {
  none(0, 'No install error.'),
  download(UPDATE_ERROR_DOWNLOAD, 'Download failed.'),
  blocked(UPDATE_ERROR_BLOCKED, 'Installation was blocked by the system.'),
  invalidApk(UPDATE_ERROR_INVALID_APK, 'The downloaded APK is invalid.'),
  conflict(
      UPDATE_ERROR_CONFLICT, 'The update conflicts with the installed app.'),
  storage(UPDATE_ERROR_STORAGE, 'Not enough device storage for the update.'),
  incompatible(UPDATE_ERROR_INCOMPATIBLE,
      'The update is incompatible with this device.'),
  appNotOwned(
      UPDATE_ERROR_APP_NOT_OWNED, 'The app is not owned by the user account.'),
  internalError(UPDATE_ERROR_INTERNAL_ERROR, 'Internal RuStore update error.'),
  aborted(UPDATE_ERROR_ABORTED, 'The update was aborted by the user.'),
  apkNotFound(UPDATE_ERROR_APK_NOT_FOUND,
      'The APK required for installation was not found.'),
  externalSourceDenied(
    UPDATE_ERROR_EXTERNAL_SOURCE_DENIED,
    'Update launch was denied by the external source policy.',
  ),
  unknown(-1, 'Unknown RuStore update error.');

  const RustoreUpdateError(this.value, this.description);

  final int value;
  final String description;

  static RustoreUpdateError fromValue(int value) {
    return RustoreUpdateError.values.firstWhere(
      (error) => error.value == value,
      orElse: () => RustoreUpdateError.unknown,
    );
  }
}

extension UpdateInfoX on UpdateInfo {
  InstallStatus get installStatusValue =>
      InstallStatus.fromValue(installStatus);

  UpdateAvailability get updateAvailabilityValue =>
      UpdateAvailability.fromValue(updateAvailability);
}

extension RequestResponseX on RequestResponse {
  InstallStatus get installStatusValue =>
      InstallStatus.fromValue(installStatus);

  RustoreUpdateError get installError =>
      RustoreUpdateError.fromValue(installErrorCode);

  double? get downloadProgress {
    if (totalBytesToDownload <= 0) {
      return null;
    }

    return (bytesDownloaded / totalBytesToDownload).clamp(0.0, 1.0);
  }
}
