//
//  NSDate+HJ.h
//  JustWay
//
//  Created by HeJun on 29/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HJ)

/**
 * 根据格式化时间获取日期对象
 */
+ (NSDate *)dateWithFormatedTime:(NSString *)formatedTime formate:(NSString *)formate;

/**
 * 格式化date
 */
+ (NSString *)formateDate:(NSDate *)date formate:(NSString *)formate;

@end
