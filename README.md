# OpenMediation SDK for iOS
[![CocoaPods Compatible](http://img.shields.io/badge/pod-v2.2.2-blue.svg)](https://github.com/AdTiming/OpenMediation-iOS)
[![Platform](https://img.shields.io/badge/platform-iOS%209%2B-brightgreen.svg?style=flat)](https://github.com/AdTiming/OpenMediation-iOS)
[![License](https://img.shields.io/github/license/AdTiming/OpenMediation-iOS)](https://github.com/AdTiming/OpenMediation-iOS/blob/master/LICENSE)

Thanks for taking a look at OpenMediation! We offers diversified and competitive monetization solution and supports a variety of Ad formats including Native Ad, Interstitial Ad, Banner Ad, and Rewarded Video Ad. The OpenMediation platform works with multiple ad networks include AdMob, Facebook, UnityAds, Vungle, AdColony, AppLovin, Tapjoy, Chartboost, TikTok and Mintegral etc.

## Communication

- If you **found a bug**, _and can provide steps to reliably reproduce it_, open an issue.
- If you **have a feature request**, open an issue.

### Installation with CocoaPods

[CocoaPods](https://cocoapods.org/) is a dependency manager for Swift and Objective-C Cocoa projects, which automates and simplifies the process of using 3rd-party libraries like the OpenMediation SDK in your projects. You can install it with the following command:

```
$ gem install cocoapods
```

**Podfile**
To integrate OpenMediation SDK into your Xcode project using CocoaPods, specify it in your Podfile:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

target 'TargetName' do
    pod 'OpenMediation', '~> 2.2.2'
end
```

#### Adapters

Podfile example:

```
pod 'OpenMediationAdTimingAdapter'
pod 'OpenMediationAdMobAdapter'
pod 'OpenMediationFacebookAdapter'
pod 'OpenMediationUnityAdapter'
pod 'OpenMediationVungleAdapter'
pod 'OpenMediationTencentAdAdapter'
pod 'OpenMediationAdColonyAdapter'
pod 'OpenMediationAppLovinAdapter'
pod 'OpenMediationMoPubAdapter'
pod 'OpenMediationTapjoyAdapter'
pod 'OpenMediationChartboostAdapter'
pod 'OpenMediationPangleAdapter'
pod 'OpenMediationMintegralAdapter'
pod 'OpenMediationIronSourceAdapter'
pod 'OpenMediationFyberAdapter'
pod ‘OpenMediationHeliumAdapter’
pod ‘OpenMediationSigMobAdapter’
pod ‘OpenMediationKuaiShouAdapter’
pod ‘OpenMediationPubNativeAdapter’
```

Then, run the following command:

```bash
$ pod install
```

### Installation with Swift Package Manager

Add the following entry to your package's dependencies:

```
.Package(url: "https://github.com/AdTiming/OpenMediation-iOS.git", from: "2.0.4")
``` 

## Requirements

- iOS 9.0 and up
- Xcode 9.3 and up

## LICENSE

See the [LICENSE](LICENSE) file.
