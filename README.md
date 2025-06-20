rawr (Roughly Approximate Water Reminder)
=========================================

Created for the 2025 Hack Club Summer of Making (https://summer.hack.club/boe)

## What is this?

rawr is an iOS app to remind you to drink water and track your water intake.

## Features
- Reminds you to drink water at regular intervals
- Tracks your water intake
- Integrates with the Health app
- Watch app for quick access

## How does it work?

Open the app, and press the big button. A glass of water will be added to your
statistics, and a reminder will be scheduled to remind you to drink water again
in one hour.

### Configuration
You can configure the daily goal in your iPhone's settings app under Apps > rawr.

On Apple Watch, open the settings using the 􀣋 gear button in the top right corner.

### Health integration

When you log your first glass of water, the app will ask for permission to save
and read data from the Health app. If you do not grant permission, the app will
still track your water intake locally, but it will not be synced with the Health
app, and Watch sync might not work. You can change this permission in the Health
app under 􀉭 Profile (Your profile picture/Person symbol) > Apps > rawr.

### Notifications

When you log your first glass of water, the app will ask for permission to send you
notifications. If you do not grant permission, the app will not send you
notifications, but it will still track your water intake locally. You can change
this permission and the notification style in the Settings app under
Apps > rawr > Notifications.

## Hacking

To develop this app, you need to have Xcode installed on your Mac.
You can download it from the Mac App Store. You also need the iOS and watchOS SDK.
To run the app on your physical iPhone or Apple Watch, you need to have a
developer account and be above 18 years old, or share an account with a parent or
guardian who is above 18 years old and registered for the Apple Developer Program.

To run the app, build and run either the `rawr` or `rawr-watch Watch App` Scheme.

## Privacy

rawr does not collect any personal data. It only stores your water intake locally
on your device and syncs it with the Health app if you grant permission. The app does not
send any data to the developer or any third party. The app does not use any
analytics or tracking services. The app does not require an internet connection to
function, but it does require an internet connection to download the app and
updates from the App Store.

## AI Usage Disclosure

While developing rawr, I used Xcodes Predictive Code Completion (beta) feature
and GitHub Copilot to provide short completions in various places in the code.
Most of the code was written by a human, and the AI was only used speed up typing.
