//
//  UIImage+HJ.h
//  JustWay
//
//  Created by HeJun on 28/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HJ)

/** 获取一张图片(不会缓存到内存) */
+ (instancetype)imageWithUnCachedName:(NSString *)name;
/** 合并两张图片 */
+ (UIImage *)addImage:(NSString *)imageName1 withImage:(NSString *)imageName2;

@end
