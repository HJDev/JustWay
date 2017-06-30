//
//  NSDate+HJ.m
//  JustWay
//
//  Created by HeJun on 29/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import "NSDate+HJ.h"

@implementation NSDate (HJ)

/**
 * 根据格式化时间获取日期对象
 */
+ (NSDate *)dateWithFormatedTime:(NSString *)formatedTime formate:(NSString *)formate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterMediumStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
	
	[formatter setDateFormat:formate];
	
	NSDate *date = [formatter dateFromString:formatedTime];
	
	return date;
}

+ (NSString *)formateDate:(NSDate *)date formate:(NSString *)formate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterMediumStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
	
	[formatter setDateFormat:formate];
	
	return [formatter stringFromDate:date];
}

@end
