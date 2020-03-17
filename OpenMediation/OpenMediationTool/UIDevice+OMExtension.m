// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "UIDevice+OMExtension.h"
#import "OMMacros.h"
#import "OMKeychain.h"
#import "OMLogMoudle.h"

#import <AdSupport/AdSupport.h>
#import <iAd/iAd.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#include <sys/utsname.h>
#import "mach/mach.h"
#include <mach/mach_host.h>
#include <sys/sysctl.h>

@implementation UIDevice (OMExtension)

+ (NSNumber*)omTimeStamp {
    return [NSNumber numberWithInteger:(NSInteger)([[NSDate date]timeIntervalSince1970]*1000.0)];
}

+ (NSNumber*)omMinutesFromGMT {
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    return [NSNumber numberWithInteger:(NSInteger)([timeZone secondsFromGMT]/60)];
}

+ (NSString*)omTimeZoneName {
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    return [timeZone name];
}

+ (void)omStoreSessionID {
    [[NSUserDefaults standardUserDefaults]setObject:OM_SAFE_STRING([[NSUUID UUID]UUIDString]) forKey:@"OMSession"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (NSString*)omSessionID {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"OMSession"];
}

+ (NSString*)omUserID {
    NSString *userID = [self omKeyChainGetValueWithKey:KEY_UUID];
    if (OM_STR_EMPTY(userID)) {
        userID= [[NSUUID UUID]UUIDString];
        [self omKeyChainStoreValue:userID withKey:KEY_UUID];
    }
    return userID;
}


+ (NSString*)omIdfa{
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return OM_SAFE_STRING(idfa);
}

+ (NSNumber*)omDeviveIDType{
    return [NSNumber numberWithInt:1];//1:IDFA, 2:GAID, 3:FBID, 4:HUAWEIID
}

+ (NSString*)omLanguageCode{
    NSString *language=@"";
    if ([[NSLocale preferredLanguages] count] > 0) {
        language = [[NSLocale preferredLanguages]objectAtIndex:0];
    }
    return language;
}

+ (NSString*)omLanguageName {
    NSString *languageName = @"";
    NSMutableArray *languageArray = [NSMutableArray arrayWithArray:[[self omLanguageCode] componentsSeparatedByString:@"-"]] ;
    if (languageArray.count > 1) {
        [languageArray removeLastObject];
    }
    languageName = [languageArray componentsJoinedByString:@"-"];
    return languageName;
}


+ (BOOL)omJailbreak {
    
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath])
    {
        jailbroken = YES;
    }
    return jailbroken;
}

+ (NSString*)omBundleID {
    return OM_SAFE_STRING([[NSBundle mainBundle] bundleIdentifier]);
}

+ (NSString*)omModel {
    return [self omReadSysctlbByName:"hw.machine"];
}

+ (NSString*)omOSVersion {
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    return OM_SAFE_STRING(systemVersion);
}

+ (NSString*)omOSBuildVersion {
    return [self omReadSysctlbByName:"kern.osversion"];
}


+ (NSString*)omLocalAppVersion {
    NSString *vString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return OM_SAFE_STRING(vString);
}

+ (NSNumber*)omWidthPixels {
    return [NSNumber numberWithInteger:(NSInteger)([UIScreen mainScreen].bounds.size.width*[UIScreen mainScreen].scale)];
}

+ (NSNumber*)omHeightPixels {
    return [NSNumber numberWithInteger:(NSInteger)([UIScreen mainScreen].bounds.size.height*[UIScreen mainScreen].scale)];
}

+ (NSString*)omCountryCode {
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    return OM_SAFE_STRING(countryCode);
}

+ (NSString*)omCarrierInfo {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CTCarrier *carrier = [info subscriberCellularProvider];
#pragma clang diagnostic pop
    NSString *carrierMCC = [carrier mobileCountryCode];
    NSString *carrierMNC = [carrier mobileNetworkCode];
    NSString *carrierName = [carrier carrierName];
    NSString *carrierInfo = [[NSString alloc] initWithFormat:@"%@%@%@",OM_SAFE_STRING(carrierMCC),OM_SAFE_STRING(carrierMNC),OM_SAFE_STRING(carrierName)];
    return carrierInfo;
}

+ (long long)omRamSize {
    long long ramSize = [[[[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil] objectForKey:NSFileSystemSize] longLongValue];
    return ramSize;
}

+ (NSInteger)omFreeRamSize {
    long long ramSize = [[[[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil] objectForKey:NSFileSystemFreeSize] longLongValue];
    return (NSInteger)(ramSize/1024/1024);
}

+ (NSInteger)omBatteryLevel {
    bool monitoringPreviouslyEnabled = [[UIDevice currentDevice] isBatteryMonitoringEnabled];
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    float batteryLevel = [UIDevice currentDevice].batteryLevel;
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:monitoringPreviouslyEnabled];
    return (NSInteger)(batteryLevel*100);
}

+ (BOOL)omLowPowerMode {
    BOOL lowPowerMode = NO;
    if (@available(iOS 9.0, *)) {
        lowPowerMode = [NSProcessInfo processInfo].lowPowerModeEnabled;
    }
    return lowPowerMode;
}


+ (NSString*)omIdfv {
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return OM_SAFE_STRING(idfv);
}

+ (NSString *)omCpuType {
    host_basic_info_data_t hostInfo;
    mach_msg_type_number_t infoCount;
    
    infoCount = HOST_BASIC_INFO_COUNT;
    host_info(mach_host_self(), HOST_BASIC_INFO, (host_info_t)&hostInfo, &infoCount);
    
    switch (hostInfo.cpu_type) {
        case CPU_TYPE_ANY:
            return @"CPU_TYPE_ANY";
            break;
            
        case CPU_TYPE_VAX:
            return @"CPU_TYPE_VAX";
            break;
            
        case CPU_TYPE_MC680x0:
            return @"CPU_TYPE_MC680x0";
            break;
            
        case CPU_TYPE_MC98000:
            return @"CPU_TYPE_MC98000";
            break;
            
        case CPU_TYPE_MC88000:
            return @"CPU_TYPE_MC88000";
            break;
            
        case CPU_TYPE_SPARC:
            return @"CPU_TYPE_SPARC";
            break;
            
        case CPU_TYPE_I860:
            return @"CPU_TYPE_I860";
            break;
            
        case CPU_TYPE_POWERPC64:
            return @"CPU_TYPE_POWERPC64";
            break;
            
            
        case CPU_TYPE_HPPA:
            return @"CPU_TYPE_HPPA";
            break;
            
        case CPU_TYPE_ARM:
            return @"CPU_TYPE_ARM";
            break;
            
        case CPU_TYPE_ARM64:
            return @"CPU_TYPE_ARM64";
            break;
            
        case CPU_TYPE_X86:
            return @"CPU_TYPE_X86";
            break;
            
        case CPU_TYPE_X86_64:
            return @"CPU_TYPE_X86_64";
            break;
            
        default:
            return [NSString stringWithFormat:@"cpu_%d",hostInfo.cpu_type];
            break;
    }
}

+ (BOOL) omIs64bit {
    int error = 0;
    int value = 0;
    size_t length = sizeof(value);
    
    error = sysctlbyname("hw.cpu64bit_capable", &value, &length, NULL, 0);
    
    if (error != 0) {
        error = sysctlbyname("hw.optional.x86_64", &value, &length, NULL, 0); //x86 specific
    }
    
    if (error != 0) {
        error = sysctlbyname("hw.optional.64bitops", &value, &length, NULL, 0); //PPC specific
    }
    
    if (error != 0) {
        return NO;
    }
    
    return value == 1;
}

+ (NSNumber*)omCountofCores {
    NSInteger ncpu = 1;
    size_t len = sizeof(ncpu);
    sysctlbyname("hw.ncpu", &ncpu, &len, NULL, 0);
    return [NSNumber numberWithInteger:ncpu];
}

// width
+ (NSNumber*)omScreenWidth {
    return [NSNumber numberWithInteger:(NSInteger)[UIScreen mainScreen].bounds.size.width];
}

// height
+ (NSNumber*)omScreenHeight {
    return [NSNumber numberWithInteger:(NSInteger)([UIScreen mainScreen].bounds.size.height)];
}

+ (NSNumber*)omScreenScale {
    return [NSNumber numberWithFloat:[UIScreen mainScreen].scale];
}


+ (NSString*)omHardwareName {
    return [self omReadSysctlbByName:"hw.model"];
}

+ (NSString *)omNetWorkVersion {
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *path = @"/System/Library/Frameworks/CFNetwork.framework/Info.plist";
    if ([fileMgr fileExistsAtPath:path]) {
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        return [dict valueForKey:@"CFBundleVersion"]; // CFBundleVersion CFBundleShortVersionString
    }
    return @"758.1.6";
}

+ (NSString*)omNetworkRelease {
    struct utsname name;
    memset(&name, 0x0, sizeof(struct utsname));
    uname(&name);
    return [NSString stringWithUTF8String:name.release];
}

+ (NSString *)omCurrentRadioAccessTechnology {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    NSString *currentStatus = @"";//
    SEL radioTechSelector = NSSelectorFromString(@"currentRadioAccessTechnology");
    if ([networkInfo respondsToSelector:radioTechSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        currentStatus = [networkInfo performSelector:radioTechSelector];
#pragma clang diagnostic pop
    }
    return currentStatus;
}

+ (NSString*)omLocaleIdentifier {
    return [NSLocale currentLocale].localeIdentifier;
}

+ (NSString*)omTimeZoneAbbreviation {
    return OM_SAFE_STRING([[NSTimeZone systemTimeZone]abbreviation]);
}

+ (NSString*)omReadSysctlbByName:(const char *)name {
    int error = 0;
    size_t length = 0;
    error = sysctlbyname(name, NULL, &length, NULL, 0);
    if (error) {
        return @"";
    }
    char *p = malloc(sizeof(char) * (length+1));
    memset(p , 0, sizeof(char) * (length+1));
    if (!p) {
        return @"";
    } else {
        error = sysctlbyname(name, p, &length, NULL, 0);
        if (error) {
            free(p);
            return @"";
        } else {
            NSString * result = [NSString stringWithUTF8String:p];
            free(p);
            return result;
        }
    }
}

+ (void)omKeyChainStoreValue:(NSString*)value withKey:(NSString*)key {
    if (key && value) {
        NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
        if ([OMKeychain load:KEY_USERKEYCHAIN]) {
            userDic = [OMKeychain load:KEY_USERKEYCHAIN];
        }
        [userDic setObject:value forKey:key];
        [OMKeychain save:KEY_USERKEYCHAIN data:userDic];
    }
}

+ (NSString*)omKeyChainGetValueWithKey:(NSString*)key {
    NSString *result = @"";
    if (key) {
        NSMutableDictionary *userDic = (NSMutableDictionary *)[OMKeychain load:KEY_USERKEYCHAIN];
        result = [userDic objectForKey:key];
    }
    return result;
}


+ (NSString*)omManufacturer {
    return @"Apple";
}

+ (NSString*)omBrand {
    return @"Apple";
}

+ (NSString*)omCarrier {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CTCarrier *carrier = [info subscriberCellularProvider];
#pragma clang diagnostic pop
    ;
    NSString *carrierName = [carrier carrierName];
    return OM_SAFE_STRING(carrierName);
}

+ (NSNumber*)omInstallTime {
    NSInteger installTime = 0;
    NSString *checkPath = [[NSBundle mainBundle] bundlePath];
    @try {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if (paths.count > 0) {
            checkPath = [paths objectAtIndex:0];
        }
        NSDate*createTime = [[[NSFileManager defaultManager] attributesOfItemAtPath:checkPath error:nil]objectForKey:NSFileCreationDate];
        installTime = [createTime timeIntervalSince1970];
    } @catch (NSException *exception) {
        NSLog(@"Error while trying to check install date. Exception: %@",exception);
    }
    OMLogV(@"install ts %zd",installTime);
    return [NSNumber numberWithInteger:installTime];
}

+ (NSNumber*)omFirstLaunchTime {
    NSString *ts = [self omKeyChainGetValueWithKey:KEY_FIRSTLAUNCHTIME];
    if (OM_STR_EMPTY(ts)) {
        ts = [NSString stringWithFormat:@"%zd",(NSInteger)[[NSDate date]timeIntervalSince1970]];
        [self omKeyChainStoreValue:ts withKey:KEY_FIRSTLAUNCHTIME];
    }
    OMLogV(@"first launch ts %@",ts);
    return [NSNumber numberWithInteger:[ts integerValue]];

}

+ (long long)omBootTime {
    long long btime = 0;
    struct timeval  boottime;
    int mib[2] = {CTL_KERN,KERN_BOOTTIME};
    size_t size = sizeof(boottime);
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1) {
        btime = boottime.tv_sec*1000 + boottime.tv_usec/1000;
    }
    return btime;
}

@end
