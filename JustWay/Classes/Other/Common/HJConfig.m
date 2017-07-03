//
//  HJConfig.m
//  JustWay
//
//  Created by HeJun on 28/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import "HJConfig.h"

#import <RDVTabBarController.h>
#import <RDVTabBarItem.h>
#import "HJNavigationController.h"
#import "HJNewsViewController.h"
#import "HJFilesViewController.h"
#import "HJMeViewController.h"

#import <AVFoundation/AVFoundation.h>

@implementation HJConfig

/**
 * 初始化TabBar
 */
+ (UIViewController *)configTabBar {
	RDVTabBarController *tabbar = [RDVTabBarController new];
	
	HJNewsViewController *newsVc = [HJNewsViewController new];
	newsVc.title = @"动态";
	HJNavigationController *newsNav = [[HJNavigationController alloc] initWithRootViewController:newsVc];
	
	HJFilesViewController *filesVc = [HJFilesViewController new];
	filesVc.title = @"文件";
	HJNavigationController *filesNav = [[HJNavigationController alloc] initWithRootViewController:filesVc];
	
	HJMeViewController *meVc = [HJMeViewController new];
	meVc.title = @"我";
	HJNavigationController *meNav = [[HJNavigationController alloc] initWithRootViewController:meVc];
	
	[tabbar setViewControllers:@[newsNav, filesNav, meNav]];
	
	NSArray *tabbarImages = @[@"tab_ic_recent", @"tab_ic_file", @"tab_ic_my"];
	NSInteger i = 0;
	for (RDVTabBarItem *item in tabbar.tabBar.items) {
		NSString *tabIconName = tabbarImages[i];
		NSString *tabSelIconName = [NSString stringWithFormat:@"%@_selected", tabIconName];
		[item setFinishedSelectedImage:[UIImage imageNamed:tabSelIconName] withFinishedUnselectedImage:[UIImage imageNamed:tabIconName]];
		[item setSelectedTitleAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10], NSForegroundColorAttributeName : HJRGB(4, 164, 255)}];
		[item setUnselectedTitleAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10]}];
		[item setTitlePositionAdjustment:UIOffsetMake(0, 3)];
		
		i++;
	}
	
	return tabbar;
}

/**
 * 配置后台播放
 */
+ (void)configBackgoundPlayTask {
    //实现后台播放
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
}

@end
