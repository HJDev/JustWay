//
//  HJMusicPlayControlView.h
//  JustWay
//
//  Created by HeJun on 30/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJMusicPlayControlView : UIView

/** 当前播放进度 */
@property (nonatomic, assign) NSInteger currentTime;
/** 总时长 */
@property (nonatomic, assign) NSInteger duration;

@end
