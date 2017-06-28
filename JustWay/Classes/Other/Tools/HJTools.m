//
//  HJTools.m
//  JustWay
//
//  Created by HeJun on 28/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import "HJTools.h"

@implementation HJTools

/** 转换文件大小 */
- (NSString *)transformedValue:(id)value {
	
	double convertedValue = [value doubleValue];
	int multiplyFactor = 0;
	
	NSArray *tokens = [NSArray arrayWithObjects:@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB", @"ZB", @"YB",nil];
	
	while (convertedValue > 1024) {
		convertedValue /= 1024;
		multiplyFactor++;
	}
	
	return [NSString stringWithFormat:@"%4.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
}

@end
