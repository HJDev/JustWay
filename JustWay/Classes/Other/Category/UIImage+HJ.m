//
//  UIImage+HJ.m
//  JustWay
//
//  Created by HeJun on 28/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import "UIImage+HJ.h"

@implementation UIImage (HJ)

+ (instancetype)imageWithUnCachedName:(NSString *)name {
	if (name == nil) {
		return nil;
	}
	NSString *fileName = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name];
	return [self imageWithContentsOfFile:fileName];
}

@end
