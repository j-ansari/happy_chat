# Flutter MQTT Chat — README

## Overview

A small starter app demonstrating:- OTP login (send / verify)- MQTT-based chat using the same topic
for publish and subscribe- MVVM architecture with Cubit- Dio with interceptor to add Authorization
header- GetIt for dependency injection- SharedPreferences for token persistence- OTP Autofill (
Android User Consent) using `otp_autofill` and `pinput`- Simple professional exception classes- A
token starter that boots the app into login or contacts depending on stored
token- Unit tests (example)

## Features implemented- Login page (enter phone, send OTP)- Verify page with OTP autofill and Pinput- Contacts list (fetched from
`/api/v1/contacts` with Authorization)- Chat page per contact- Connects to MQTT broker
`193.105.234.224:1883` with specified username/

password- Publishes messages to `challenge/user/<contact_token>/<user_token>/`- Subscribes to the
same topic so that messages are returned back (fake chat)- Clean DI with `get_it`- Dio interceptor
handles token automatically- Exception classes: `AppException`, `ApiException`, `NetworkException`,
`UnauthorizedException`- Android/iOS: OTP autofill code is implemented via `otp_autofill` (Android
User
Consent API enabled when possible)

## How to run

1. Create a new Flutter project
2. Replace `pubspec.yaml` with the content provided and run `flutter pub get`
3. Copy the `lib/` files into your project
   21
4. Update Android & iOS platform settings for network permissions (cleartext
   http if needed) and SMS permissions if testing autofill.
5. Run `flutter run`.

## Testing- Example unit test provided at `test/auth_repo_test.dart`- Run
`flutter test` to execute tests

## Notes & improvements- In production, always use JSON for MQTT payloads (I used json encode/parse in

places). Avoid naive `.toString()` serialization.- Add robust reconnection logic for MQTT and error
handling on network failures.- Consider secure storage for tokens (flutter_secure_storage) in
production.- Add E2E tests for UI flows.