//
//  HJSlider.h
//  JustWay
//
//  Created by HeJun on 07/07/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OnTouch)(UITouchPhase touchType, CGPoint touchPoint);

@interface HJSlider : UISlider

@property (nonatomic, copy) OnTouch touchBlock;

@end
