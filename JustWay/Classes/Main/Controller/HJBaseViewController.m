//
//  HJBaseViewController.m
//  JustWay
//
//  Created by HeJun on 29/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import "HJBaseViewController.h"
#import <RDVTabBarController.h>

@interface HJBaseViewController ()<UINavigationControllerDelegate>

@end

@implementation HJBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationController.delegate = self;
	self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
	HJLog(@"%s", __func__);
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
	[super supportedInterfaceOrientations];
	return UIInterfaceOrientationMaskPortrait;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//	HJLog(@"%s", __func__);
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//	HJLog(@"%s", __func__);
	if (self.navigationController.viewControllers.count > 1) {
		[self.rdv_tabBarController setTabBarHidden:YES animated:YES];
	} else {
		[self.rdv_tabBarController setTabBarHidden:NO animated:YES];
	}
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
