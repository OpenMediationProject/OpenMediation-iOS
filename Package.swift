// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OpenMediation",
    platforms: [.iOS(.v9)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "OpenMediation",targets: ["OpenMediation"]),
        .library(name: "OMAdColonyAdapter",targets: ["OMAdColonyAdapter"]),
        .library(name: "OMAdMobAdapter",targets: ["OMAdMobAdapter"]),
        .library(name: "OMAdTimingAdapter",targets: ["OMAdTimingAdapter"]),
        .library(name: "OMAppLovinAdapter",targets: ["OMAppLovinAdapter"]),
        .library(name: "OMChartboostAdapter",targets: ["OMChartboostAdapter"]),
        .library(name: "OMChartboostBidAdapter",targets: ["OMChartboostBidAdapter"]),
        .library(name: "OMFyberAdapter",targets: ["OMFyberAdapter"]),
        .library(name: "OMFacebookAdapter",targets: ["OMFacebookAdapter"]),
        .library(name: "OMIronSourceAdapter",targets: ["OMIronSourceAdapter"]),
        .library(name: "OMMintegralAdapter",targets: ["OMMintegralAdapter"]),
        .library(name: "OMMoPubAdapter",targets: ["OMMoPubAdapter"]),
        .library(name: "OMTapjoyAdapter",targets: ["OMTapjoyAdapter"]),
        .library(name: "OMTencentAdAdapter",targets: ["OMTencentAdAdapter"]),
        .library(name: "OMTikTokAdapter",targets: ["OMTikTokAdapter"]),
        .library(name: "OMUnityAdapter",targets: ["OMUnityAdapter"]),
        .library(name: "OMVungleAdapter",targets: ["OMVungleAdapter"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "OpenMediation",
            dependencies: [],
            path:"OpenMediation",
            exclude: ["Info.plist","OpenMediation.modulemap"],
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("OpenMediationBanner"),
                .headerSearchPath("OpenMediationBid"),
                .headerSearchPath("OpenMediationCrossPromotion"),
                .headerSearchPath("OpenMediationCustomEvent"),
                .headerSearchPath("OpenMediationInterstitial"),
                .headerSearchPath("OpenMediationModel"),
                .headerSearchPath("OpenMediationNative"),
                .headerSearchPath("OpenMediationNetwork"),
                .headerSearchPath("OpenMediationPromotion"),
                .headerSearchPath("OpenMediationRewardedVideo"),
                .headerSearchPath("OpenMediationSegments"),
                .headerSearchPath("OpenMediationSplash"),
                .headerSearchPath("OpenMediationTool")
            ]
        ),
        .target(
            name: "OMAdColonyAdapter",
            path:"Adapters/AdColonyAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OMAdMobAdapter",
            path:"Adapters/AdMobAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OMAdTimingAdapter",
            path:"Adapters/AdTimingAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OMAppLovinAdapter",
            path:"Adapters/AppLovinAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OMChartboostAdapter",
            path:"Adapters/ChartboostAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OMChartboostBidAdapter",
            path:"Adapters/ChartboostBidAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OMFyberAdapter",
            path:"Adapters/FyberAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OMFacebookAdapter",
            path:"Adapters/FacebookAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OMIronSourceAdapter",
            path:"Adapters/IronSourceAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OMMintegralAdapter",
            path:"Adapters/MintegralAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OMMoPubAdapter",
            path:"Adapters/MoPubAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OMMyTargetAdapter",
            path:"Adapters/MyTargetAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OMTapjoyAdapter",
            path:"Adapters/TapjoyAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OMTencentAdAdapter",
            path:"Adapters/TencentAdAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OMTikTokAdapter",
            path:"Adapters/TikTokAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OMUnityAdapter",
            path:"Adapters/UnityAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OMVungleAdapter",
            path:"Adapters/VungleAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../../OpenMediation/OpenMediationCustomEvent")
            ]
        )
    ]
)
