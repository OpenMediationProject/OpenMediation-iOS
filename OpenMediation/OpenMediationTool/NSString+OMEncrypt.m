// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "NSString+OMEncrypt.h"
#import <CommonCrypto/CommonCrypto.h>
@implementation NSString (OMEncrypt)

- (NSString *)omMd5 {
    if (self == nil || [self length] == 0)
        return self;
    
    const char *cStr = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++) {
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

/**
 字符大小写可以通过修改“%02X”中的x修改,下面采用的是大写
 */
- (NSString*)omSha1 {
    if (self == nil || [self length] == 0)
        return self;
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02X", digest[i]];
    }
    
    return output;
}

- (NSString *)omURLEncode {
    
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"?!@#$^&%*+,:;='\"`<>()[]{}/\\| "] invertedSet];
    return  [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
}

- (NSString *)omURLDecode {
    return [self stringByRemovingPercentEncoding];
}
@end
