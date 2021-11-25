// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (OMExtension)

+ (NSNumber*)omTimeStamp;

+ (NSNumber*)omMinutesFromGMT;

+ (NSString*)omTimeZoneName;

+ (void)omStoreSessionID;

+ (NSString*)omSessionID;

+ (NSString*)omUserID;

+ (NSString*)omIdfa;

+ (NSNumber*)omDeviveIDType;

+ (NSString*)omLanguageCode;

+ (NSString*)omLanguageName;

+ (BOOL)omJailbreak;

+ (NSString*)omBundleID;

+ (NSString*)omModel;

+ (NSString*)omOSVersion;

+ (NSString*)omOSBuildVersion;

+ (NSString*)omLocalAppVersion;

+ (NSNumber*)omWidthPixels;

+ (NSNumber*)omHeightPixels;

+ (NSString*)omCountryCode;

+ (NSString*)omCarrierInfo;

+ (long long)omMemorySize;

+ (long long)omRamSize;

+ (NSInteger)omFreeRamSize;

+ (NSInteger)omBatteryLevel;

+ (BOOL)omLowPowerMode;

+ (NSString*)omIdfv;

+ (NSString *)omCpuType;

+ (BOOL)omIs64bit;

+ (NSNumber*)omCountofCores;

+ (NSNumber*)omScreenWidth;

+ (NSNumber*)omScreenHeight;

+ (NSNumber*)omScreenScale;

+ (NSString*)omHardwareName;

+ (NSString *)omNetWorkVersion;

+ (NSString*)omNetworkRelease;

+ (NSString *)omCurrentRadioAccessTechnology;

+ (NSString*)omLocaleIdentifier;

+ (NSString*)omTimeZoneAbbreviation;

+ (NSString*)omManufacturer; //old api

+ (NSString*)omBrand;

+ (NSString*)omCarrier;

+ (NSString*)omCarrierIso;

+ (NSNumber*)omInstallTime;

+ (NSNumber*)omFirstLaunchTime;

+ (NSString*)omAFUid;

+ (long long)omBootTime;

+ (float)brightness;

@end

NS_ASSUME_NONNULL_END
