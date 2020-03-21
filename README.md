OpenMediation is a fully open mediation platform, providing an end-to-end system from SDK to server, Dashboard, and datacentre. OpenMediation's full-featured and full-platform access provides a highly competitive mobile advertising mediation solution:

- Comprehensive support for more than 10 major AdNetwork, including admob, Facebook, applovin, unity, vungle, adcolony, tapjoy, chartboost, mopub, ironsrc, tiktok, Mintegral, tencentAds, to ensure maximum revenue

- Featured smart ad inventory and automatic waterfall optimization technology to ensure highest ad loading performance and fill rate of 99%+ (* with proper Waterfall level configuration), with historical data driven realtime optimization capacity
- Supports IAB specifications complied headerbidding to maximize revenue through real-time bidding
- Docker container images and deployment automation on popular public cloud such as AWS ECS/EKS, combined with S3 + Athena lightweight data analytics solutions, makes running a powerful advertising mediation system easy

The OpenMediation project includes three parts: server, dashboard, and SDK. It is divided into seven sub-projects, as follows:

- [OM-Server](https://github.com/AdTiming/OM-Server): Mediation server core module, responsible for SDK access and mediation logic processing, data collection processing

- [OM-ADC](https://github.com/AdTiming/OM-ADC): Data aggregation module, responsible for aggregating revenue data from AdNetworks for business reports generation

- [OM-DTask](https://github.com/AdTiming/OM-Dtask): Data configuration center, which stores key configuration information for OM-Server, such as kafka, S3, etc. Also includes data processing code for AWS Athena based data analytics and report generation

- [OM-Android-SDK](https://github.com/AdTiming/OpenMediation-Android): Android Mediation SDK, responsible for mediating third-party AdNetwork Android SDKs

- [OM-iOS-SDK](https://github.com/AdTiming/OpenMediation-iOS): iOS Mediation SDK, responsible for mediating third-party AdNetwork iOS SDKs

- OM-DS-UI: Dashboard frontend

- OM-DS-Server: Dashboard backend

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
