// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OpenMediation",
    platforms: [.iOS(.v9)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "OpenMediation",targets: ["OpenMediation"]),
        .library(name: "OpenMediationAdTimingAdapter",targets: ["OpenMediationAdTimingAdapter"]),
        .library(name: "OpenMediationAdMobAdapter",targets: ["OpenMediationAdMobAdapter"]),
        .library(name: "OpenMediationFacebookAdapter",targets: ["OpenMediationFacebookAdapter"]),
        .library(name: "OpenMediationUnityAdapter",targets: ["OpenMediationUnityAdapter"]),
        .library(name: "OpenMediationVungleAdapter",targets: ["OpenMediationVungleAdapter"]),
        .library(name: "OpenMediationTencentAdAdapter",targets: ["OpenMediationTencentAdAdapter"]),
        .library(name: "OpenMediationAdColonyAdapter",targets: ["OpenMediationAdColonyAdapter"]),
        .library(name: "OpenMediationAppLovinAdapter",targets: ["OpenMediationAppLovinAdapter"]),
        .library(name: "OpenMediationMoPubAdapter",targets: ["OpenMediationMoPubAdapter"]),
        .library(name: "OpenMediationTapjoyAdapter",targets: ["OpenMediationTapjoyAdapter"]),
        .library(name: "OpenMediationChartboostAdapter",targets: ["OpenMediationChartboostAdapter"]),
        .library(name: "OpenMediationPangleAdapter",targets: ["OpenMediationPangleAdapter"]),
        .library(name: "OpenMediationMintegralAdapter",targets: ["OpenMediationMintegralAdapter"]),
        .library(name: "OpenMediationIronSourceAdapter",targets: ["OpenMediationIronSourceAdapter"]),
        .library(name: "OpenMediationFyberAdapter",targets: ["OpenMediationFyberAdapter"]),
        .library(name: "OpenMediationHeliumAdapter",targets: ["OpenMediationHeliumAdapter"]),
        .library(name: "OpenMediationSigMobAdapter",targets: ["OpenMediationSigMobAdapter"]),
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
            name: "OpenMediationAdTimingAdapter",
            path:"OMAdTimingAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OpenMediationAdMobAdapter",
            path:"OMAdMobAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OpenMediationFacebookAdapter",
            path:"OMFacebookAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OpenMediationUnityAdapter",
            path:"OMUnityAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OpenMediationVungleAdapter",
            path:"OMVungleAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OpenMediationTencentAdAdapter",
            path:"OMTencentAdAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OpenMediationAdColonyAdapter",
            path:"OMAdColonyAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OpenMediationAppLovinAdapter",
            path:"OMAppLovinAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OpenMediationMoPubAdapter",
            path:"OMMoPubAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OpenMediationTapjoyAdapter",
            path:"OMTapjoyAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OpenMediationChartboostAdapter",
            path:"OMChartboostAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OpenMediationPangleAdapter",
            path:"OMTikTokAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OpenMediationMintegralAdapter",
            path:"OMMintegralAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OpenMediationIronSourceAdapter",
            path:"OMIronSourceAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OpenMediationFyberAdapter",
            path:"OMFyberAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OpenMediationHeliumAdapter",
            path:"OMChartboostAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../OpenMediation/OpenMediationCustomEvent")
            ]
        ),
        .target(
            name: "OpenMediationSigMobAdapter",
            path:"OMSigMobAdapter",
            cSettings:[
                .headerSearchPath("."),
                .headerSearchPath("../OpenMediation/OpenMediationCustomEvent")
            ]
        )
    ]
)
