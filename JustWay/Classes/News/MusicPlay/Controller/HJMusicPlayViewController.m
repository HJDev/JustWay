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
    BOOL exit = [fm fileExistsAtPath:urlStr];
    NSURL *url = nil;
//    if (exit) {
        url = [NSURL fileURLWithPath:urlStr];
//    } else {
//        url = [NSURL URLWithString:urlStr];
//    }
    if (url != nil) {
        [[HJMusicPlayer sharedInstance] playWithUrl:url];
        [[HJMusicPlayer sharedInstance] addObserver:self forKeyPath:@"currentTime" options:NSKeyValueObservingOptionNew context:nil];
        HJWeakSelf;
        //播放进度更新
        [[HJMusicPlayer sharedInstance] setPlayProgressBlock:^(UInt64 currentTime) {
            [weakSelf.controlView setCurrentTime:currentTime];
        }];
        //播放完成
        [[HJMusicPlayer sharedInstance] setPlayEndBlock:^(NSURL *playUrl) {
            if ([playUrl.absoluteString hasSuffix:@".mp3"]) {
//                NSURL *url = [NSURL fileURLWithPath:@"/var/mobile/Containers/Data/Application/59CC5090-6487-49F4-8745-7AA5640DAD83/Documents/she - 美丽新世界.m4a"];
//                [[HJMusicPlayer sharedInstance] playWithUrl:url];
                [weakSelf startPlayWithUrl:@"/var/mobile/Containers/Data/Application/59CC5090-6487-49F4-8745-7AA5640DAD83/Documents/she - 美丽新世界.m4a"];
            } else {
//                NSURL *url = [NSURL URLWithString:@"http://122.228.254.11/mp32.9ku.com/upload/2015/11/16/667848.mp3"];
//                [[HJMusicPlayer sharedInstance] playWithUrl:url];
//                [weakSelf startPlayWithUrl:@"http://122.228.254.11/mp32.9ku.com/upload/2015/11/16/667848.mp3"];
                [weakSelf startPlayWithUrl:@"/var/mobile/Containers/Data/Application/BE808683-1DAA-4BA6-8868-7CDE5BC853AC/Documents/大王叫我来巡山.mp3"];
            }
        }];
        [self.controlView setDuration:[HJMusicPlayer sharedInstance].duration];
    }
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
                    [self.coverView setPlaying:NO];
                } else {
                    [[HJMusicPlayer sharedInstance] resume];
                    [self.coverView setPlaying:YES];
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
    coverView.backgroundColor = HJRANDOM;
    [self.view addSubview:coverView];
    self.coverView = coverView;
    [self.coverView setupCycleAnimation];
	
	//播放器控制View
	HJMusicPlayControlView *controlView = [HJMusicPlayControlView new];
	controlView.backgroundColor = HJRANDOM;
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
