// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3


#import <Foundation/Foundation.h>
#import <zlib.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (OMGzip)

- (NSData *)omGzipData;
- (NSData *)omUnzipData;
- (BOOL)omIsGzippedData;
- (NSData *)omZlibInflate;
- (NSData *)omZlibDeflate;
@end

NS_ASSUME_NONNULL_END
