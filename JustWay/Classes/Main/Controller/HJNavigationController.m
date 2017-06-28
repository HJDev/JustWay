//
//  HJNavigationController.m
//  JustWay
//
//  Created by HeJun on 28/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import "HJNavigationController.h"
#import <RDVTabBarController.h>

@interface HJNavigationController ()

@end

@implementation HJNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
	[super pushViewController:viewController animated:animated];
	
	if (self.viewControllers.count > 1) {
		[self.rdv_tabBarController setTabBarHidden:YES animated:YES];
	}
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
	
	if (self.viewControllers.count == 2) {
		[self.rdv_tabBarController setTabBarHidden:NO animated:YES];
	}
	
	return [super popViewControllerAnimated:animated];
}

@end
