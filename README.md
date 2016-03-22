<p align="center">
<a href="http://openshop.io/">
<img src="http://i.imgur.com/fLhSUr0.png?1"/>
</a>
</p>
  
**First mobile E-commerce solution connected to Facebook Ads and Google**
  <br/>

We as a Facebook Marketing Partner company have experienced neverending struggles with Facebook and Google integration on side of our partners. It usually took weeks or months to implement all neccessary SDKs, features, measurements and events. That's the reason why we have decided to provide an open-source solution bringing marketing on the first place. Our mission is to fulfill all potential of Facebook Ads, Google Analytics and other marketing channels for an extraordinary mobile shopping experience.

*Visit out website on [openshop.io](openshop.io)*

Do you want to see the app in action? 

<a href="http://itunes.apple.com/app/id1088689646">
<img src="http://s12.postimg.org/87quj2uop/Download_on_the_App_Store_Badge_US_UK_135x40.png"/>
</a>

# Features
* **Facebook Ads Integration** - The most advanced Facebook Ads Integration. Encourage purchases, target your mobile customers and measure conversions.
* **Google Analytics Integration** - Integration of Google Analytics can be sometimes tricky. With our solution you can't miss any conversion.
* **Unified & Powerful API** - Connecting your backend and data storages has never been easier. Our API is, thanks to Apiary, very well documented and available for testing.
* **Push Notifications** - Encourage your customers through absolutely powerful Push Notifications. So, your customers won't miss any sale or special offer.
* **Synchronized with your Web** - Synchronize abandoned shopping carts and user profiles from your website. So, your customers won't feel the difference if coming to website or mobile app.
* **Standardized XML Feeds** - We use support all advanced XML Feed features you know from other systems. So, you don't have to create another one and just connect the feed you already use.
* We also offer Deeplinks, Advanced measurement & analytics, and much more...

# How to connect
We are trying to minimize the effort necessary to ship your ecommerce mobile solution. The first step for a successful integration is connection between your data source and our server. There is prepared a standardized [apiary.io](http://docs.bfeshopapiconnector.apiary.io/) documentation which will tell you how to output your XML feed to be compatible with the data the app is expecting. For more information on how to connect to our server please [contact us](#contact-us).

![img](http://openshop.io/img/schema.png)

# Technical Intro
OpenShop.io uses CocoaPods as a dependency manager for OpenShop.io project. To run the project please follow these steps:

## Requirements
* iOS 8.0+
* Xcode 7.2+ for app development and distribution to Apple App Store

## Workspace Setup
Run these commands in Terminal or other command line tool to download and instal all the necessary tools for the app development and distribution:
```
[sudo] gem install bundler
xcode-select --install
```

To download the project, install dependencies specified in the `Podfile` and open the project workspace run these commands one after another:
```
git clone https://github.com/business-factory/openshop.io-ios.git
cd openshop.io-ios
bundle install
bundle exec fastlane build
```
This will build the project and create a new workspace file `OpenShop.xcworkspace` which includes all the CocoaPod dependencies. Make sure to open `OpenShop.xcworkspace` workspace file for app development and submission and ignore `OpenShop.xcodeproj`.

## Graphics template
[Here](link to psd) you will find the PSD template which served as the guideline for implementing user interface in the OpenShop app.

# Run the app
The example OpenShop.io application you can download from this repository or [App Store](http://itunes.apple.com/app/id1088689646) runs on our custom sample data source (product, payments, shipping, branches,...). If you want to integrate your feed within the app take a look at the section [how to connect](#how-to-connect).

# Release the app with minimal effort
Do you want to release the app like 1, 2, 3, BLAST OFF!? It is as easy as editing a few files and running a command from Terminal and you are done.
We have prepared and configured [fastlane tool](https://github.com/fastlane/fastlane) to automate the process of creating the application on Apple App Store, taking screenshots and distributing the app for you.

## Create new application on iTunes Connect
Open `fastlane/Fastfile` and find `produce` lane which specifies the basic information necessary for the creation. Enter your Apple Developer account `username`, choose a `app_identifier`, `app_name` and `sku` and run the following command which will produce a new app on you iTunes Connect. 
```
bundle exec fastlane produce
```

## Update OpenShop project
1. Rename the project - [Apple tutorial](https://developer.apple.com/library/ios/recipes/xcode_help-project_editor/RenamingaProject/RenamingaProject.html)
2. Update UI 
    * colors - currently there are two sources where the UI components colors are defined - `UIColor+BFColor.m` and `Main.storyboard`
    * logos, icons - you will find all the image resources inside `Images.xcassets` file. Replace all the OpenShop logos and images with your custom ones
    * banners - upload custom banners which appear on the title page through the administration - sales, new collections
3. Bundle ID - Select custom bundle ID which will uniquely identify your app. It must be same as the one specified in the [previous step](Create-new-application-on-iTunes-Connect). For example: `nameofyourcompany.openshop`
![Bundle id change](http://s9.postimg.org/eed7db51r/Sni_mek_obrazovky_2016_03_01_v_13_45_53.png)
4. Define your organization - inside `BFAppPreferences` you will find `BFAppPreferencesDefaultOrganization` key which defines your organization ID. After the registration in our system we will assign you an identification which will be placed here.
5. Create Facebook application - [Facebook tutorial](https://developers.facebook.com/docs/apps/register)
    ![Facebook application settings](http://s11.postimg.org/nq5evt9xf/Sni_mek_obrazovky_2016_03_08_v_14_53_56.png)
6. Connect Facebook application the OpenShop project - enter Facebook application ID on these places: 
    * `Info.plist` inside `OpenShop.io.xcworkspace` - notice that value inside URL Schemes is prefixed with string `fb`
    ![Info.plist](http://s23.postimg.org/h7fvfqnxn/Sni_mek_obrazovky_2016_03_01_v_14_12_26.png)
    * administration on our server
7. Validate FB configuration: Thanks to the [Facebook App Ads Helper](https://developers.facebook.com/tools/app-ads-helper/) you will be able to determine if all of the parts of the configuration were successful.

## Screenshots 
Taking screenshots for multiple resolutions on multiple devices can be pretty annoying that's why we have automated this process with [snapshot](https://github.com/fastlane/snapshot) and [frameit](https://github.com/fastlane/frameit) tools. Running this command will run the simulators, take screenshots and put them in the frames.

```
bundle exec fastlane screenshots
```

* **UI behaviour** is specified within `OpenShopUITests.swift`.
* **snapshot** configuration is inside `fastlane/Snapfile`.
* **frameit** configuration is inside `fastlane/screenshots/Framefile.json`.
    * texts which are places inside the frames are defined in the files `keywords.strings` and `titles.strings`. Each language folder (en-US) has its own set of strings files
    * It is important to mention that **frameit** uses images for Apple devices which must be downloaded and installed from their site. For more information please follow [frameit docs](https://github.com/fastlane/frameit).


## Release the app
This command will do all the magic - build the app, take screenshots, frame them with the texts, check for provisioning profiles and deliver the app to the Apple App Store
```
bundle exec fastlane appstore
```

Next step is to send the application to Apple to review the application. Some extra features (e.g. Analytics tools) require IDFA collection so it is recommended to create custom licence which specifies that user agrees with this by downloading the application.
![](http://s15.postimg.org/mmwymk53f/Release_custom_licence.png)
![](http://s15.postimg.org/dt625gi4r/Release_custom_licence_2.png)

*In addition to the terms set out in the standard Apple "Licensed Application End User Licence Agreement" users agree to the Application collecting detailed user information. A copy of the Apple standard EULA can be found at: http://www.apple.com/legal/internet-services/itunes/appstore/dev/stdeula/*

Before submitting the app to the review is is also necessary to complete the final form according to this picture to avoid the rejection.
![](http://s15.postimg.org/fv6jjpg3v/Submit_to_review.png)

## Nice-to-have features
Implementing these features will significantly help you with getting to know the users, collecting the data about the app usage or remarketing but they aren't crutial for running the app.
* **Analytics** - To measure conversions or application usage and installs from the campaigns you can use pre-implemented Google Analytics or Facebook Analytics inside `BFAnalyticsLogger` class. Each logger (e.g. `BFAnalyticsGoogle`, `BFAnalyticsFacebook`) defines its own way how to log the event and `BFAnalyticsLogger` serves as the proxy for them. 
  * Google Analytics
      * The first step is to create Google Analytics account. Take a look [here](https://support.google.com/analytics/answer/1008015?hl=en).
      * Set custom values obtained from Google Analytics site to `trackerName` and `trackerUA` inside `BFAnalyticsGoogle` class 
  * Facebook Analytics - If you have successfully configured Facebook SDK you can start logging the events.
* **Apple Push Notification Service (APNS)** - [APNS](https://developer.apple.com/library/mac/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/ApplePushService.html) provides you a feature to inform the customers about the newest collections and sales. We have created a tool in the administration for you to broadcast the notifications from one place with just a few clicks. At first it is necessary that you obtain APNS certificates. [PEM](https://github.com/fastlane/PEM) is a great, easy to use command line tool which will generate the certificates for you. If you want to do it the hard way [this tutorial by Ali Hafizji](http://www.raywenderlich.com/32960/apple-push-notification-services-in-ios-6-tutorial-part-1) might help you. When you are done, just upload the certificates to our administration.

* **Fabric (Crashlytics)** - As Rocky Balboa once said: *"The world ain’t all sunshine and rainbows. It's about how hard you can get hit and keep moving forward."*. And let's face it. Every app can get hit pretty hard and crash. But it's about how you can analyze the crash and fix it. That's the reason why we are using Crashlytics to analyze the bugs that made the application crash. Take a look at their [Get started guide](https://get.fabric.io/) and when you are done there is `BFCrashLoggerService` in the project which will make the integration easier.

# Development
Now let's talk a bit more technically. If you wish to make more significant changes we are providing the basic description of the implementation on our [wiki pages](https://github.com/business-factory/openshop.io-ios/wiki) but you will find more in-depth comments inside the code. 

Don't you have your mobile development team? We totally understand that pain, when your IT department is super busy or you don't have your own in-house mobile development team. We will connect you with one of our integration partners to build the app for you. Just [contact us](#contact-us).

# TODO
* Travis CI builds
* Unit Tests

# Contact us

Do you have any troubles or issue to report?
Do you like OpenShop.io project and want to be part of it? Great! 
Contact us on help@openshop.io or here on GitHub.

# Licence
