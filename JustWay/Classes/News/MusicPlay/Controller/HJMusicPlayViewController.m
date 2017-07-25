//
//  HJMusicPlayViewController.m
//  JustWay
//
//  Created by HeJun on 28/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import "HJMusicPlayViewController.h"
#import "HJMusicPlayControlView.h"
#import "HJMusicPlayLyricView.h"
#import "HJMusicPlayCoverView.h"
#import "HJMusicPlayer.h"
#import "HJMusicPlayModel.h"
#import <Masonry.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>

/** 播放模式 */
#define kHJMusicPlayMode @"HJMusicPlayMode"

@interface HJMusicPlayViewController ()

/** 播放器控制View */
@property (nonatomic, weak) HJMusicPlayControlView *controlView;
/** 播放器封面View */
@property (nonatomic, weak) HJMusicPlayCoverView   *coverView;
/** 播放器歌词View */
@property (nonatomic, weak) HJMusicPlayLyricView   *lyricView;

@end

@implementation HJMusicPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	
	[self setupViews];
    [self startPlayWithModel:self.playModel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [[UIApplication sharedApplication] resignFirstResponder];
	[UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [[UIApplication sharedApplication] becomeFirstResponder];
	[UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
	HJLog(@"%s", __func__);
}

/**
 * 开始播放
 */
- (void)startPlayWithModel:(HJMusicPlayModel *)playModel {
    if (playModel.playUrl == nil) {
        return;
    }
	NSString *playUrlStr = [NSString URLDecodedString:playModel.playUrl.absoluteString];
	NSArray *musicPartial = [playUrlStr componentsSeparatedByString:@"/"];
	self.title = musicPartial.lastObject;
    if (playModel.playUrl != nil) {
        [[HJMusicPlayer sharedInstance] playWithUrl:playModel.playUrl];
		self.lyricView.lyricUrl = playModel.lyricUrl;
        HJWeakSelf;
        //播放进度更新
        [[HJMusicPlayer sharedInstance] setPlayProgressBlock:^(UInt64 currentTime) {
            [weakSelf.controlView setCurrentTime:currentTime];
			weakSelf.lyricView.currentTime = currentTime;
			//显示锁屏动态歌词
			[weakSelf setupLockScreenInfoWithPreviousLrc:weakSelf.lyricView.previousLrc nextLrc:weakSelf.lyricView.nextLrc currentLrc:weakSelf.lyricView.currentLrc currentTime:currentTime];
        }];
		//播放状态改变
		[[HJMusicPlayer sharedInstance] setPlayStatusChangedBlock:^(BOOL playing) {
			weakSelf.controlView.playing = playing;
			weakSelf.coverView.playing = playing;
		}];
        //播放完成
        [[HJMusicPlayer sharedInstance] setPlayEndBlock:^(NSURL *playUrl) {
			[weakSelf playNextWithCurrentMusic:weakSelf.playModel playMode:HJMusicPlayActionNext userAction:NO];
        }];
        [self.controlView setDuration:[HJMusicPlayer sharedInstance].duration];
//		[[HJMusicPlayer sharedInstance] seek:200];
    }
	[self setupLockScreenInfoWithPreviousLrc:self.lyricView.previousLrc nextLrc:self.lyricView.nextLrc currentLrc:self.lyricView.currentLrc currentTime:0];
}

/**
 * 下一曲
 *
 * @param currentMusic 当前播放歌曲
 * @param playAction   播放动作
 * @param userAction   是否为用户操作 (YES : 用户操作 NO : 自动续播)
 */
- (void)playNextWithCurrentMusic:(HJMusicPlayModel *)currentMusic
						playMode:(HJMusicPlayAction)playAction
					  userAction:(BOOL)userAction {
	if (self.musicList.count > 1) {
		NSInteger nextPlayIndex = [self.musicList indexOfObject:self.playModel];
		HJMusicPlayMode playMode = [self getPlayMode];
		switch (playMode) {
			case HJMusicPlayModeSingleCycle: {
				if (userAction) {
					if (playAction == HJMusicPlayActionNext) {
						nextPlayIndex++;
					} else {
						nextPlayIndex--;
					}
				}
				break;
			}
			case HJMusicPlayModeRandom: {
				nextPlayIndex = arc4random() % self.musicList.count;
				break;
			}
			case HJMusicPlayModeAllCycle: {
				if (playAction == HJMusicPlayActionNext) {
					nextPlayIndex++;
				} else {
					nextPlayIndex--;
				}
				break;
			}
				
			default:
				break;
		}
		NSInteger nextIndex = (nextPlayIndex + self.musicList.count) % self.musicList.count;
		self.playModel = [self.musicList objectAtIndex:nextIndex];
	}
	[self startPlayWithModel:self.playModel];
	
}

/**
 * 音乐锁屏信息展示
 */
- (void)setupLockScreenInfoWithPreviousLrc:(NSString *)previousLrc nextLrc:(NSString *)nextLrc currentLrc:(NSString *)currentLrc currentTime:(UInt64)currentTime {
	// 1.获取锁屏中心
	MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
	//初始化一个存放音乐信息的字典
	NSMutableDictionary *playingInfoDict = [NSMutableDictionary dictionary];
	// 2、设置歌曲名
	if (self.playModel.playName) {
		[playingInfoDict setObject:self.playModel.playName forKey:MPMediaItemPropertyAlbumTitle];
	}
	// 设置歌手名
	if (self.playModel.artist) {
		[playingInfoDict setObject:self.playModel.artist forKey:MPMediaItemPropertyArtist];
	}
	// 3设置封面的图片
	
	UIImage *image = [self coverImage:[UIImage imageWithUnCachedName:@"image"] previousLrc:previousLrc nextLrc:nextLrc currentLrc:currentLrc];//[UIImage imageWithUnCachedName:@"image"];
	if (image) {
		MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
		[playingInfoDict setObject:artwork forKey:MPMediaItemPropertyArtwork];
	}
	// 4设置歌曲的总时长
	[playingInfoDict setObject:@([HJMusicPlayer sharedInstance].duration) forKey:MPMediaItemPropertyPlaybackDuration];
	[playingInfoDict setObject:@(currentTime) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
	//音乐信息赋值给获取锁屏中心的nowPlayingInfo属性
	playingInfoCenter.nowPlayingInfo = playingInfoDict;
	
	// 5.开启远程交互，只有开启这个才能进行远程操控
	[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

/**
 * 获取锁屏图片+歌词
 */
- (UIImage *)coverImage:(UIImage *)coverImage previousLrc:(NSString *)previousLrc nextLrc:(NSString *)nextLrc currentLrc:(NSString *)currentLrc {
	// 生成图片
	UIGraphicsBeginImageContextWithOptions(coverImage.size, YES, 1.0);
	[coverImage drawInRect:CGRectMake(0, 0, coverImage.size.width, coverImage.size.height)];
	CGFloat textHeight = 18;
	NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
	style.alignment = NSTextAlignmentCenter;
	NSDictionary *previousAndNextLrcAttrDic = @{NSFontAttributeName : [UIFont systemFontOfSize:14],
												NSForegroundColorAttributeName : [UIColor whiteColor],
												NSParagraphStyleAttributeName : style};
	NSDictionary *currentLrcAttrDic = @{NSFontAttributeName : [UIFont systemFontOfSize:18],
										NSForegroundColorAttributeName : HJBaseColor,
										NSParagraphStyleAttributeName : style};
	[previousLrc drawInRect:CGRectMake(0, coverImage.size.height - 3 * textHeight, coverImage.size.width, coverImage.size.height) withAttributes:previousAndNextLrcAttrDic];
	[nextLrc drawInRect:CGRectMake(0, coverImage.size.height - textHeight, coverImage.size.width, coverImage.size.height) withAttributes:previousAndNextLrcAttrDic];
	[currentLrc drawInRect:CGRectMake(0, coverImage.size.height - 2 * textHeight, coverImage.size.width, coverImage.size.height) withAttributes:currentLrcAttrDic];
	
	UIImage *lockImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return lockImage;
}

#pragma mark - 接受远程控制事件
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    HJLog(@"%@", event);
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                HJLog(@"控制中心播放");
                [[HJMusicPlayer sharedInstance] resume];
                break;
            case UIEventSubtypeRemoteControlPause: {
                HJLog(@"控制中心暂停");
                [[HJMusicPlayer sharedInstance] pause];
                break;
            }
            case UIEventSubtypeRemoteControlStop: {
                HJLog(@"停止");
                [[HJMusicPlayer sharedInstance] stopPlay];
                break;
            }
            case UIEventSubtypeRemoteControlNextTrack: {
                HJLog(@"下一首");
				[self playNextWithCurrentMusic:self.playModel playMode:HJMusicPlayActionNext userAction:YES];
                break;
            }
            case UIEventSubtypeRemoteControlPreviousTrack: {
                HJLog(@"上一首");
				[self playNextWithCurrentMusic:self.playModel playMode:HJMusicPlayActionPreview userAction:YES];
                break;
            }
            case UIEventSubtypeRemoteControlTogglePlayPause: {
                HJLog(@"耳机相控暂停");
                if ([HJMusicPlayer sharedInstance].isPlaying) {
                    [[HJMusicPlayer sharedInstance] pause];
                } else {
                    [[HJMusicPlayer sharedInstance] resume];
                }
                break;
            }
                
            default:
                break;
        }
    }
}

/**
 * 初始化控件
 */
- (void)setupViews {
	HJMusicPlayLyricView *lyricView = [HJMusicPlayLyricView new];
	lyricView.backgroundColor = HJRANDOM;
	[self.view addSubview:lyricView];
	self.lyricView = lyricView;
    
    //播放器音乐封面
    HJMusicPlayCoverView *coverView = [HJMusicPlayCoverView new];
    [self.view addSubview:coverView];
    self.coverView = coverView;
    [self.coverView setupCycleAnimation];
	self.coverView.hidden = YES;
	
	//播放器控制View
	HJMusicPlayControlView *controlView = [HJMusicPlayControlView new];
	controlView.backgroundColor = [UIColor lightGrayColor];
	controlView.playing = [HJMusicPlayer sharedInstance].playing;
	controlView.playMode = [self getPlayMode];
	[controlView setActionChangeBlock:^(HJMusicPlayAction playAction) {
		switch (playAction) {
			case HJMusicPlayActionPlay: {
				//播放
				[[HJMusicPlayer sharedInstance] resume];
				break;
			}
			case HJMusicPlayActionPause: {
				//暂停
				[[HJMusicPlayer sharedInstance] pause];
				break;
			}
			case HJMusicPlayActionPreview: {
				//上一首
				[self playNextWithCurrentMusic:self.playModel playMode:HJMusicPlayActionPreview userAction:YES];
				break;
			}
			case HJMusicPlayActionNext: {
				//下一首
				[self playNextWithCurrentMusic:self.playModel playMode:HJMusicPlayActionNext userAction:YES];
				break;
			}
			case HJMusicPlayActionRandom: {
				//随机播放
				[self savePlayMode:HJMusicPlayModeRandom];
				break;
			}
			case HJMusicPlayActionAllCycle: {
				//全部循环
				[self savePlayMode:HJMusicPlayModeAllCycle];
				break;
			}
			case HJMusicPlayActionSingleCycle: {
				//单曲循环
				[self savePlayMode:HJMusicPlayModeSingleCycle];
				break;
			}
				
			default:
				break;
		}
	}];
	[controlView setSliderValueChangeBlock:^(NSInteger currentTime) {
		[[HJMusicPlayer sharedInstance] seek:currentTime];
	}];
	[self.view addSubview:controlView];
	self.controlView = controlView;
	
	[self setupConstraints];
}

/**
 * 保存播放模式
 */
- (void)savePlayMode:(HJMusicPlayMode)playMode {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:@(playMode) forKey:kHJMusicPlayMode];
	[defaults synchronize];
}

/**
 * 获取播放模式
 */
- (HJMusicPlayMode)getPlayMode {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	HJMusicPlayMode playMode = [defaults integerForKey:kHJMusicPlayMode];
	return playMode;
}

/**
 * 初始化控件约束
 */
- (void)setupConstraints {
	HJWeakSelf;
	[self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.view).offset(64);
	}];
	
	[self.lyricView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.top.bottom.mas_equalTo(weakSelf.coverView);
	}];
	
    CGFloat controlViewHeight = 150;
    if (iPhone4) {
        controlViewHeight = 120;
    }
	[self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(weakSelf.coverView.mas_bottom);
		make.left.right.bottom.mas_equalTo(weakSelf.view);
		make.height.mas_equalTo(controlViewHeight);
	}];
}

@end
