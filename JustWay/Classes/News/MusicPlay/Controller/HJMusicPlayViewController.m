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
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [[UIApplication sharedApplication] becomeFirstResponder];
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
        }];
		//播放状态改变
		[[HJMusicPlayer sharedInstance] setPlayStatusChangedBlock:^(BOOL playing) {
			weakSelf.controlView.playing = playing;
			weakSelf.coverView.playing = playing;
		}];
        //播放完成
        [[HJMusicPlayer sharedInstance] setPlayEndBlock:^(NSURL *playUrl) {
			[weakSelf playNextWithCurrentMusic:weakSelf.playModel playMode:HJMusicPlayActionAllCycle];
        }];
        [self.controlView setDuration:[HJMusicPlayer sharedInstance].duration];
//		[[HJMusicPlayer sharedInstance] seek:200];
    }
}

/**
 * 下一曲
 */
- (void)playNextWithCurrentMusic:(HJMusicPlayModel *)currentMusic playMode:(HJMusicPlayAction)playAction {
	if (self.musicList.count > 1) {
		NSInteger currentIndex = [self.musicList indexOfObject:currentMusic];
		NSInteger nextIndex = 0;
		if (currentIndex + 1 < self.musicList.count) {
			nextIndex = currentIndex + 1;
		}
		self.playModel = [self.musicList objectAtIndex:nextIndex];
	}
	[self startPlayWithModel:self.playModel];
	
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
				[self playNextWithCurrentMusic:self.playModel playMode:HJMusicPlayActionNext];
                break;
            }
            case UIEventSubtypeRemoteControlPreviousTrack: {
                HJLog(@"上一首");
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
	[controlView setActionChangeBlock:^(HJMusicPlayAction playAction) {
		switch (playAction) {
			case HJMusicPlayActionPlay: {
				[[HJMusicPlayer sharedInstance] resume];
//				weakSelf.coverView.playing = YES;
				break;
			}
			case HJMusicPlayActionPause: {
				[[HJMusicPlayer sharedInstance] pause];
//				weakSelf.coverView.playing = NO;
				break;
			}
			case HJMusicPlayActionNext: {
				[self playNextWithCurrentMusic:self.playModel playMode:HJMusicPlayActionAllCycle];
				break;
			}
				
			default:
				break;
		}
	}];
	[self.view addSubview:controlView];
	self.controlView = controlView;
	
	[self setupConstraints];
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
