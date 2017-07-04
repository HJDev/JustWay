//
//  HJMusicPlayer.h
//  JustWay
//
//  Created by HeJun on 28/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 播放进度更新 */
typedef void(^OnPlayProgress)(UInt64 currentTime);
/** 播放完成 */
typedef void(^OnPlayEnd)(NSURL *playUrl);
/** 播放状态改变 */
typedef void(^OnPlayStatusChanged)(BOOL playing);

@interface HJMusicPlayer : NSObject

/** 当前播放地址 */
@property (nonatomic, strong, readonly) NSURL *playUrl;
/** 是否已静音 */
@property (nonatomic, assign, getter=isMuted) BOOL muted;
/** 是否正在播放 */
@property (nonatomic, assign, getter=isPlaying) BOOL playing;
/** 音频总时长 */
@property (nonatomic, assign, readonly) Float64 duration;
/** 当前播放进度 */
@property (nonatomic, copy) OnPlayProgress playProgressBlock;
/** 播放完成 */
@property (nonatomic, copy) OnPlayEnd playEndBlock;
/** 播放状态改变 */
@property (nonatomic, copy) OnPlayStatusChanged playStatusChangedBlock;

+ (instancetype)sharedInstance;
/** 开始播放 */
- (void)playWithUrl:(NSURL *)url;
/** 停止播放 */
- (void)stopPlay;
/** 继续播放 */
- (void)resume;
/** 暂停播放 */
- (void)pause;

@end
