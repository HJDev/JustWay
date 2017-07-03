//
//  HJConfig.h
//  JustWay
//
//  Created by HeJun on 28/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HJConfig : NSObject

/**
 * 初始化TabBar
 */
+ (UIViewController *)configTabBar;

/**
 * 配置后台播放
 */
+ (void)configBackgoundPlayTask;

@end
