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
background:linear-gradient(180deg,#ffffff,#f3f4f6);
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
background:linear-gradient(180deg,#e9edf2,#ffffff);
box-shadow:inset 0 2px 6px rgba(0,0,0,.10);">
EN
</span>

</div>
<!-- ────────────────────────────────────────────────────────────────── -->

## 10.5.2

- Changed: maven repository link

## 10.5.1

- Changed: supported RuStore appupdate SDK 10.5.1

## 10.5.0

- Changed: supported RuStore appupdate SDK 10.5.0
- Fixed: compatibility issues after updating Pigeon to 22.5.0

## 10.4.0

- Release was skipped

## 10.3.1

* Updated RuStore AppUpdate SDK to 10.3.1
* Updated Flutter tooling: Dart ≥3.3.0, flutter_lints 4.0, pigeon 22.5, minSdkVersion 24

## 10.3.0

* Updated RuStore Update SDK to 10.3.0.

## 10.2.0

* Updated RuStore Update SDK to 10.2.0.
* Added `RustoreUpdateClient.stateStream` for update state tracking via `Stream`.
* Replaced endless Dart polling with a native `EventChannel` state delivery model.
* On Android, the listener is now registered with `registerListener(...)` and removed with `unregisterListener(...)` on `cancel/dispose`.
* Preserved backward compatibility for the legacy API: `RustoreUpdateClient.listener(...)` remains available as a wrapper over `stateStream.listen(...)`.
* Preserved native backward compatibility for the legacy one-shot `listener()` bridge path.
* Added type-safe enums `InstallStatus`, `UpdateAvailability`, and `RustoreUpdateError`.
* Added convenience getters `installStatusValue`, `updateAvailabilityValue`, `installError`, and `downloadProgress`.
* Added correctly spelled `UPDATE_AVAILABILITY_*` aliases without removing legacy `UPDATE_AILABILITY_*`.
* Updated the example app, README, and tests to use lifecycle-safe subscriptions and human-readable statuses.

## 10.1.0

* Update RuStore Update SDK 10.1.0

## 10.0.0

* Update RuStore Update SDK 10.0.0

## 9.1.0

* Update RuStore Update SDK 9.1.0

## 9.0.2

* Update RuStore Update SDK 9.0.2

## 9.0.1

* Update RuStore Update SDK 9.0.1

## 8.0.0

* Update RuStore Update SDK 8.0.0

## 7.0.1

* Add support gradle 8

## 7.0.0

* Update RuStore Update SDK 7.0.0

## 6.1.0

* Update RuStore Update SDK 6.1.0

## 6.0.0

* Update RuStore Update SDK 6.0.0

## 3.0.0

* Update RuStore Update SDK 3.0.0

## 2.0.0

* Update RuStore Update SDK 2.0.0

## 1.0.0

* Update RuStore Update SDK 1.0.0

## 0.0.3

* Update RuStore Update SDK 0.2.0

## 0.0.2

* Updated readme and docs

## 0.0.1

* Full RuStore Update SDK support

[ru]: CHANGELOG.ru.md
[en]: CHANGELOG.md
