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
@property (nonatomic, strong) NSTimer *playerTimer;

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
	_playUrl = url;
	if ([url.absoluteString isEqualToString:self.playUrl.absoluteString]) {
		return;
	}
	
	AVURLAsset *asset = [AVURLAsset assetWithURL:url];
	if (self.player.currentItem) {
		[self clearObserver];
	}
	
//	self.observerCount++;
	AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
	[item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
	[item addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playInterrupt) name:AVPlayerItemPlaybackStalledNotification object:nil];
	
	self.player = [AVPlayer playerWithPlayerItem:item];
	
	if (self.playerTimer) {
		[self.playerTimer invalidate];
		self.playerTimer = nil;
	}
	self.playerTimer = [HJWeakTimer scheduledTimerWithTimeInterval:1 block:^(id userInfo) {
		if (self.player.currentItem.currentTime.value > 0) {
			_playUrl = url;
			[self.playerTimer invalidate];
			self.playerTimer = nil;
		}
	} userInfo:nil repeats:YES];
}

/** 停止播放 */
- (void)stopPlay {
	if (self.player) {
		[self.player pause];
		[self clearObserver];
		self.player = nil;
	}
	
//	[self finishPreviewActionWithInterrupt:NO];
//	self.currentStatus = DSAudioToolStatusPlayEnd;
//	_playUrl = nil;
//	if (self.url) {
//		_playUrl = self.url;
//	}
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

#pragma mark - func player
/**
 * 清除播放器观察者及通知
 */
- (void)clearObserver {
	@try {
		[self.player.currentItem removeObserver:self forKeyPath:@"status" context:nil];
		[self.player.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp" context:nil];
		
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
		[self.player pause];
		
		[self.player.currentItem cancelPendingSeeks];
		[self.player.currentItem.asset cancelLoading];
		
		[self clearObserver];
		
		[self.player replaceCurrentItemWithPlayerItem:nil];
		
		self.player = nil;
		
	}
	
//	[self finishPreviewActionWithInterrupt:NO];
	_playUrl = nil;
	//	if (self.url) {
	//		_playUrl = self.url;
	//	}
}

/**
 * 播放被打断
 */
- (void)playInterrupt {
	HJLog(@"播放被打断");
//	[self finishPreviewActionWithInterrupt:NO];
//	self.currentStatus = DSAudioToolStatusPlayEnd;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
	if ([keyPath isEqualToString:@"status"]) {
		HJLog(@"status");
		AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
		
		switch (status) {
			case AVPlayerItemStatusUnknown: {
				HJLog(@"资源无效");
//				[self finishPreviewActionWithInterrupt:NO];
//				self.currentStatus = DSAudioToolStatusPlayEnd;
				
				//				NSDictionary *userInfo = @{@"url" : self.url ? : @"", @"status" : @(DSAudioToolStatusPlayFail)};
				//				[[NSNotificationCenter defaultCenter] postNotificationName:DSAudioToolPlayItem object:nil userInfo:userInfo];
				break;
			}
			case AVPlayerItemStatusReadyToPlay: {
				//				HJLog(@"资源准备好了, 已经可以播放");
				[self resume];
				
				//				NSDictionary *userInfo = @{@"url" : self.url ? : @"", @"status" : @(DSAudioToolStatusPlaying)};
				//				[[NSNotificationCenter defaultCenter] postNotificationName:DSAudioToolPlayItem object:nil userInfo:userInfo];
				break;
			}
			case AVPlayerItemStatusFailed: {
				HJLog(@"资源加载失败");
//				[self finishPreviewActionWithInterrupt:NO];
//				self.currentStatus = DSAudioToolStatusPlayEnd;
				
				//				NSDictionary *userInfo = @{@"url" : self.url ? : @"", @"status" : @(DSAudioToolStatusPlayFail)};
				//				[[NSNotificationCenter defaultCenter] postNotificationName:DSAudioToolPlayItem object:nil userInfo:userInfo];
				break;
			}
				
			default:
				break;
		}
	} else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
		//		HJLog(@"playbackLikelyToKeepUp");
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
	}
}

@end
