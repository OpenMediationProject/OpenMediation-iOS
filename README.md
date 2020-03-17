# OpenMediation SDK for iOS
Thanks for taking a look at OpenMediation! We offers diversified and competitive monetization solution and supports a variety of Ad formats including Native Ad, Interstitial Ad, Banner Ad, and Rewarded Video Ad. The OpenMediation platform works with multiple ad networks include AdMob, Facebook, UnityAds, Vungle, AdColony, AppLovin, Tapjoy, Chartboost, TikTok and Mintegral etc.

## Communication

- If you **found a bug**, _and can provide steps to reliably reproduce it_, open an issue.
- If you **have a feature request**, open an issue.

## Installation

The OpenMediation SDK supports multiple methods for installing the library in a project.

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
    pod 'OpenMediation', '~> 1.0.0'
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
pod 'OpenMediation/AdColonyAdapter'
pod 'OpenMediation/AppLovinAdapter'
pod 'OpenMediation/TapjoyAdapter'
pod 'OpenMediation/ChartboostAdapter'
pod 'OpenMediation/TikTokAdapter'
pod 'OpenMediation/MintegralAdapter'
```

Then, run the following command:

```bash
$ pod install
```
### Manual Integration with static Framework

OpenMediation provides a prepackaged archive of the static framework:

- **[OpenMediation SDK](https://github.com/AdTiming/OpenMediation-iOS/releases/download/1.0.0/OpenMediation-iOS-1.0.0.zip)**
- **[AdTimingAdapter SDK](https://github.com/AdTiming/OpenMediation-iOS/releases/download/1.0.0/OMAdTimingAdapter-iOS-1.0.0.zip)**
- **[AdMobAdapter SDK](https://github.com/AdTiming/OpenMediation-iOS/releases/download/1.0.0/OMAdMobAdapter-iOS-1.0.0.zip)**
- **[FacebookAdapter SDK](https://github.com/AdTiming/OpenMediation-iOS/releases/download/1.0.0/OMFacebookAdapter-iOS-1.0.0.zip)**
- **[UnityAdapter SDK](https://github.com/AdTiming/OpenMediation-iOS/releases/download/1.0.0/OMUnityAdapter-iOS-1.0.0.zip)**
- **[VungleAdapter SDK](https://github.com/AdTiming/OpenMediation-iOS/releases/download/1.0.0/OMVungleAdapter-iOS-1.0.0.zip)**
- **[AdColonyAdapter SDK](https://github.com/AdTiming/OpenMediation-iOS/releases/download/1.0.0/OMAdColonyAdapter-iOS-1.0.0.zip)**
- **[AppLovinAdapter SDK](https://github.com/AdTiming/OpenMediation-iOS/releases/download/1.0.0/OMAppLovinAdapter-iOS-1.0.0.zip)**
- **[ChartboostAdapter SDK](https://github.com/AdTiming/OpenMediation-iOS/releases/download/1.0.0/OMChartboostAdapter-iOS-1.0.0.zip)**
- **[TapjoyAdapter SDK](https://github.com/AdTiming/OpenMediation-iOS/releases/download/1.0.0/OMTapjoyAdapter-iOS-1.0.0.zip)**
- **[TikTokAdapter SDK](https://github.com/AdTiming/OpenMediation-iOS/releases/download/1.0.0/OMTikTokAdapter-iOS-1.0.0.zip)**
- **[MintegralAdapter SDK](https://github.com/AdTiming/OpenMediation-iOS/releases/download/1.0.0/OMMintegralAdapter-iOS-1.0.0.zip)**

## Requirements

- iOS 9.0 and up
- Xcode 9.3 and up

## LICENSE

See the [LICENSE](LICENSE) file.
