//
//  HJMusicPlayer.m
//  JustWay
//
//  Created by HeJun on 28/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import "HJMusicPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "HJWeakTimer.h"

@interface HJMusicPlayer()

/** 播放器 */
@property (nonatomic, strong) AVPlayer *player;
/** 播放器定时器 */
@property (nonatomic, strong) id timeObserver;

@end

@implementation HJMusicPlayer

+ (instancetype)sharedInstance {
	static HJMusicPlayer *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [HJMusicPlayer new];
	});
	return instance;
}

#pragma mark - 播放音频
/** 开始播放 */
- (void)playWithUrl:(NSURL *)url {
	if ([url.absoluteString isEqualToString:self.playUrl.absoluteString]) {
		return;
	}
	_playUrl = url;
	_duration = 0;
	
	AVURLAsset *asset = [AVURLAsset assetWithURL:url];
	_duration = CMTimeGetSeconds(asset.duration);
	if (self.player.currentItem) {
		[self clearObserver];
	}
	
	AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
	[item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
	[item addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
	//监控缓冲加载情况属性
	[item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playInterrupt) name:AVPlayerItemPlaybackStalledNotification object:nil];
	
	self.player = [AVPlayer playerWithPlayerItem:item];
	
	HJWeakSelf;
	[self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
		//在这里将监听到的播放进度代理出去，对进度条进行设置
		UInt64 currentTime = weakSelf.player.currentTime.value / weakSelf.player.currentTime.timescale;
		if (weakSelf.playProgressBlock) {
			weakSelf.playProgressBlock(currentTime);
		}
	}];
	
}

/** 停止播放 */
- (void)stopPlay {
	if (self.player) {
		[self.player pause];
		[self clearObserver];
		self.player = nil;
	}
}
/** 继续播放 */
- (void)resume {
	if (self.player) {
		[self.player play];
	}
}
/** 暂停播放 */
- (void)pause {
	if (self.player) {
		[self.player pause];
	}
}
/** 静音 */
- (void)setMuted:(BOOL)muted {
	if (self.player) {
		self.player.muted = muted;
	}
}
- (BOOL)isMuted {
	return self.player.isMuted;
}
- (BOOL)isPlaying {
    return self.player.rate == 1.0;
}

#pragma mark - func player
/**
 * 清除播放器观察者及通知
 */
- (void)clearObserver {
	@try {
		[self.player.currentItem removeObserver:self forKeyPath:@"status" context:nil];
		[self.player.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp" context:nil];
		[self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
		[self.player removeTimeObserver:self.timeObserver];
		
		[[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemPlaybackStalledNotification object:nil];
	} @catch (NSException *exception) {
		HJLog(@"多次删除observer");
	} @finally {
		HJLog(@"多次删除observer");
	}
}

/**
 * 播放完成
 */
- (void)playEnd {
	HJLog(@"播放完成");
	
	if (self.player) {
        if (self.playEndBlock) {
            self.playEndBlock(self.playUrl);
        }
		[self.player pause];
		
		[self.player.currentItem cancelPendingSeeks];
		[self.player.currentItem.asset cancelLoading];
		
		[self clearObserver];
		
		[self.player replaceCurrentItemWithPlayerItem:nil];
		
		self.player = nil;
		
	}
	
	_playUrl = nil;
}

/**
 * 播放被打断
 */
- (void)playInterrupt {
	HJLog(@"播放被打断");
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
	if ([keyPath isEqualToString:@"status"]) {
		HJLog(@"status");
		AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
		
		switch (status) {
			case AVPlayerItemStatusUnknown: {
				HJLog(@"资源无效");
				break;
			}
			case AVPlayerItemStatusReadyToPlay: {
				//HJLog(@"资源准备好了, 已经可以播放");
				[self resume];
				break;
			}
			case AVPlayerItemStatusFailed: {
				HJLog(@"资源加载失败");
				break;
			}
				
			default:
				break;
		}
	} else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
		//HJLog(@"playbackLikelyToKeepUp");
		BOOL playbackLikelyToKeepUp = [change[NSKeyValueChangeNewKey] boolValue];
		if (playbackLikelyToKeepUp) {
			//			HJLog(@"资源加载的可以播放了");
			
			// 具体要不要自动播放, 不能确定;
			// 用户手动暂停优先级, 最高 > 自动播放
			//			if (!_isUserPause) {
			[self resume];
			//			}
			
		} else {
			
			//			HJLog(@"资源正在加载");
		}
	} else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
		NSArray *array = self.player.currentItem.loadedTimeRanges;
		//本次缓冲时间范围
		CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
		float startSeconds = CMTimeGetSeconds(timeRange.start);
		float durationSeconds = CMTimeGetSeconds(timeRange.duration);
		//缓冲总长度
		NSTimeInterval totalBuffer = startSeconds + durationSeconds;
		HJLog(@"共缓冲：%.2f  ,   %.2f    ,  %.2f",totalBuffer, startSeconds, durationSeconds);
	}
}

@end
