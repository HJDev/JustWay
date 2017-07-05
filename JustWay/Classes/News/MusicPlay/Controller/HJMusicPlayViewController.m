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
    [self startPlayWithUrl:self.playUrl];
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
- (void)startPlayWithUrl:(NSString *)urlStr {
    if (urlStr.length == 0) {
        return;
    }
    NSFileManager *fm = [NSFileManager defaultManager];
//    BOOL exit = [fm fileExistsAtPath:urlStr];
    NSURL *url = nil;
//    if (exit) {
        url = [NSURL fileURLWithPath:urlStr];
//    } else {
//        url = [NSURL URLWithString:urlStr];
//    }
    if (url != nil) {
		NSArray *fileNames = [urlStr componentsSeparatedByString:@"/"];
		self.title = fileNames[fileNames.count - 1];
        [[HJMusicPlayer sharedInstance] playWithUrl:url];
		
		NSArray *suffix = [urlStr componentsSeparatedByString:@"."];
		NSString *lrc = [urlStr stringByReplacingOccurrencesOfString:suffix.lastObject withString:@"lrc"];
		if ([fm fileExistsAtPath:lrc]) {
//			if ([urlStr hasSuffix:@"S.H.E - 美丽新世界.m4a"]) {
//				self.lyricView.lyricUrl = [NSURL URLWithString:@"http://image.cdn.teamleader.cn/S.H.E%20-%20%E7%BE%8E%E4%B8%BD%E6%96%B0%E4%B8%96%E7%95%8C.lrc"];
//			} else {
//				self.lyricView.lyricUrl = [NSURL URLWithString:@"http://image.cdn.teamleader.cn/%E5%91%A8%E5%8D%8E%E5%81%A5%20-%20%E9%A3%8E%E9%9B%A8%E6%97%A0%E9%98%BB.lrc"];
//			}
			self.lyricView.lyricUrl = [NSURL fileURLWithPath:lrc];
		} else {
			self.lyricView.lyricUrl = nil;
		}
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
		NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        [[HJMusicPlayer sharedInstance] setPlayEndBlock:^(NSURL *playUrl) {
            if ([playUrl.absoluteString hasSuffix:@".mp3"]) {
				weakSelf.playUrl = [dir stringByAppendingPathComponent:@"S.H.E - 美丽新世界.m4a"];
				[weakSelf startPlayWithUrl:weakSelf.playUrl];
            } else {
//                NSURL *url = [NSURL URLWithString:@"http://122.228.254.11/mp32.9ku.com/upload/2015/11/16/667848.mp3"];
//                [[HJMusicPlayer sharedInstance] playWithUrl:url];
				[weakSelf startPlayWithUrl:[dir stringByAppendingPathComponent:@"周华健 - 风雨无阻.mp3"]];
            }
        }];
        [self.controlView setDuration:[HJMusicPlayer sharedInstance].duration];
//		[[HJMusicPlayer sharedInstance] seek:200];
    }
}

/**
 * 下一曲
 */
- (void)playNext {
	
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
				NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
				self.playUrl = [dir stringByAppendingPathComponent:@"S.H.E - 美丽新世界.m4a"];
				[self startPlayWithUrl:self.playUrl];
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
