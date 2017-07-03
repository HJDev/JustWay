//
//  HJMusicPlayCoverView.h
//  JustWay
//
//  Created by HeJun on 30/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJMusicPlayCoverView : UIView

/** 播放状态(YES : 正在播放 NO : 暂停) */
@property (nonatomic, assign) BOOL playing;
/**
 * 添加封面旋转动画
 */
- (void)setupCycleAnimation;

@end
