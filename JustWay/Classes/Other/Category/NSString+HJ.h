//
//  NSString+HJ.h
//  JustWay
//
//  Created by HeJun on 06/07/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HJ)

/** URL ENCODE */
+ (NSString *)URLEncodedString:(NSString *)str;
/** URL DECODE */
+ (NSString *)URLDecodedString:(NSString *)str;

@end
