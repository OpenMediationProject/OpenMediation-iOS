# OpenMediation SDK for iOS
[![CocoaPods Compatible](http://img.shields.io/badge/pod-v1.3.3-blue.svg)](https://github.com/AdTiming/OpenMediation-iOS)
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
    pod 'OpenMediation', '~> 1.3.3'
end
```

#### Subspecs

There are 12 subspecs available now: mediation core and 11 ad network adapters(AdTiming, AdMob, Facebook, Unity, Vungle, AdColony, AppLovin, Tapjoy, Chartboost, TikTok and Mintegral). By default, you get mediation core and all ad network adapters, if you only mediation some ad networks , you need to specify it. 

Podfile example:

```
pod 'OpenMediation/AdTimingAdapter'
pod 'OpenMediation/AdMobAdapter'
pod 'OpenMediation/FacebookAdapter'
pod 'OpenMediation/UnityAdapter'
pod 'OpenMediation/VungleAdapter'
pod 'OpenMediation/TencentAdAdapter'
pod 'OpenMediation/AdColonyAdapter'
pod 'OpenMediation/AppLovinAdapter'
pod 'OpenMediation/MoPubAdapter'
pod 'OpenMediation/TapjoyAdapter'
pod 'OpenMediation/ChartboostAdapter'
pod 'OpenMediation/TikTokAdapter'
pod 'OpenMediation/MintegralAdapter'
pod 'OpenMediation/IronSourceAdapter'
pod 'OpenMediation/FyberAdapter'
pod ‘OpenMediation/ChartboostBidAdapter’
```

Then, run the following command:

```bash
$ pod install
```

## Requirements

- iOS 9.0 and up
- Xcode 9.3 and up

## LICENSE

See the [LICENSE](LICENSE) file.
