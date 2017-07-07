//
//  HJSlider.m
//  JustWay
//
//  Created by HeJun on 07/07/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import "HJSlider.h"

@implementation HJSlider

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	
	if (touches.count == 1) {
		UITouch *touch = touches.anyObject;
		CGPoint point = [touch locationInView:self];
		
		if (self.touchBlock) {
			self.touchBlock(UITouchPhaseEnded, point);
		}
	} else {
		if (self.touchBlock) {
			self.touchBlock(UITouchPhaseEnded, CGPointZero);
		}
	}
}

@end
