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

+ (UIImage *)addImage:(NSString *)imageName1 withImage:(NSString *)imageName2 {
	UIImage *image1 = [UIImage imageWithUnCachedName:imageName1];
	UIImage *image2 = [UIImage imageWithUnCachedName:imageName2];
	
	UIGraphicsBeginImageContext(image1.size);
	
	[image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
	[image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
//	[image2 drawInRect:CGRectMake((image1.size.width - image2.size.width)/2,(image1.size.height - image2.size.height)/2, image2.size.width, image2.size.height)];
	
	UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return resultingImage;
}

@end
