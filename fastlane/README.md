fastlane documentation
================
# Installation
```
sudo gem install fastlane
```
# Available Actions
### test
```
fastlane test
```
Run iOS Tests
### build
```
fastlane build
```
Build the project including dependencies
### analyze
```
fastlane analyze
```
Run the static analyzer on the iOS project
### screenshots
```
fastlane screenshots
```
Create new screenshots for the App Store in all languages and device types

Additionally, this will add device frames around the screenshots and add the correct titles
### create_app
```
fastlane create_app
```
Create new app on both iTunes Connect and the Apple Developer Portal
### upload_metadata
```
fastlane upload_metadata
```
Uploads metadata only - no ipa file will be uploaded

You'll get a summary of the collected metadata before it's uploaded
### beta
```
fastlane beta
```
Build, sign and upload a new beta build to Apple TestFlight

This will **not** send an email to all testers, it will only be uploaded to the new TestFlight. 
### appstore
```
fastlane appstore
```
Build, sign and upload a new build to the App Store.

This will do the following:



- Create new screenshots and store them in `./fastlane/screenshots`

- Collect the app metadata from `./fastlane/metadata`

- Upload screenshots + app metadata

- Build, sign and upload the app



This will **not** submit the app for review.

----

This README.md is auto-generated and will be re-generated every time to run [fastlane](https://fastlane.tools).
More information about fastlane can be found on [https://fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [GitHub](https://github.com/fastlane/fastlane/tree/master/fastlane).