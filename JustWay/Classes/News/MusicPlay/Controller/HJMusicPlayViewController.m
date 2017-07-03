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
	if (self.playUrl.length == 0) {
		return;
	}
	NSFileManager *fm = [NSFileManager defaultManager];
	BOOL exit = [fm fileExistsAtPath:self.playUrl];
	NSURL *url = nil;
	if (exit) {
		url = [NSURL fileURLWithPath:self.playUrl];
	} else {
		url = [NSURL URLWithString:self.playUrl];
	}
	if (url != nil) {
		[[HJMusicPlayer sharedInstance] playWithUrl:url];
		[[HJMusicPlayer sharedInstance] addObserver:self forKeyPath:@"currentTime" options:NSKeyValueObservingOptionNew context:nil];
		HJWeakSelf;
		[[HJMusicPlayer sharedInstance] setPlayProgressBlock:^(UInt64 currentTime) {
			[weakSelf.controlView setCurrentTime:currentTime];
		}];
		[self.controlView setDuration:[HJMusicPlayer sharedInstance].duration];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
	HJLog(@"%s", __func__);
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
