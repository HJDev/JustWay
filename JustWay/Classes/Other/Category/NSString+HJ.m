//
//  NSString+HJ.m
//  JustWay
//
//  Created by HeJun on 06/07/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import "NSString+HJ.h"

@implementation NSString (HJ)

/** URL ENCODE */
+ (NSString *)URLEncodedString:(NSString *)str {
	NSString *encodedString = (NSString *)
	CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
															  (CFStringRef)str,
															  NULL,
															  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
															  kCFStringEncodingUTF8));
	
	return encodedString;
}

/** URL DECODE */
+ (NSString *)URLDecodedString:(NSString *)str {
	NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
	
	return decodedString;
}

@end
