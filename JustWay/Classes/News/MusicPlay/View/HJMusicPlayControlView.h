//
//  HJMusicPlayControlView.h
//  JustWay
//
//  Created by HeJun on 30/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 播放进度更新 */
typedef void(^OnSliderValueChanged)(NSInteger currentTime);
/**
 * 播放控制操作
 */
typedef NS_ENUM(NSUInteger, HJMusicPlayAction) {
	/** 播放 */
	HJMusicPlayActionPlay,
	/** 暂停 */
	HJMusicPlayActionPause,
	/** 下一首 */
	HJMusicPlayActionNext,
	/** 上一首 */
	HJMusicPlayActionPreview,
	/** 随机播放 */
	HJMusicPlayActionRandom,
	/** 单曲循环 */
	HJMusicPlayActionSingleCycle,
	/** 全部循环 */
	HJMusicPlayActionAllCycle,
	/** 播放列表 */
	HJMusicPlayActionPlayList,
};
typedef void(^OnMusicPlayActionChange)(HJMusicPlayAction action);

@interface HJMusicPlayControlView : UIView

/** 当前播放进度 */
@property (nonatomic, assign) NSInteger currentTime;
/** 总时长 */
@property (nonatomic, assign) NSInteger duration;
/** 播放器动作改变 */
@property (nonatomic, copy)	OnMusicPlayActionChange actionChangeBlock;
/** 播放进度更新 */
@property (nonatomic, copy) OnSliderValueChanged sliderValueChangeBlock;
/** 播放状态(YES : 正在播放 NO : 暂停) */
@property (nonatomic, assign) BOOL playing;

@end
