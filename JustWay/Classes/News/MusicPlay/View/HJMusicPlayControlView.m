//
//  HJMusicPlayControlView.m
//  JustWay
//
//  Created by HeJun on 30/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import "HJMusicPlayControlView.h"
#import <Masonry.h>

/** 播放器资源包 */
#define HJMusicPlayBundle @"MusicPlayer.bundle"

@interface HJMusicPlayControlView()

/** 当前播放时间 */
@property (nonatomic, weak) UILabel  *currentTimeLabel;
/** 总共音乐时间长 */
@property (nonatomic, weak) UILabel  *totalTimeLabel;
/** 播放进度滑竿 */
@property (nonatomic, weak) UISlider *slider;

/** 播放控制底部View */
@property (nonatomic, weak) UIView	 *playBottomView;
/** 播放模式按钮 */
@property (nonatomic, weak) UIButton *playModeButton;
/** 播放列表按钮 */
@property (nonatomic, weak) UIButton *playListButton;
/** 播放按钮 */
@property (nonatomic, weak) UIButton *playButton;
/** 上一首按钮 */
@property (nonatomic, weak) UIButton *previewButton;
/** 下一首按钮 */
@property (nonatomic, weak) UIButton *nextButton;

@end

@implementation HJMusicPlayControlView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setupViews];
	}
	return self;
}

#pragma mark - setter
- (void)setDuration:(NSInteger)duration {
	_duration = duration;
	
	NSInteger min = duration / 60;
	NSInteger sec = duration % 60;
	self.totalTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", min, sec];
    
    [self.slider setMaximumValue:duration];
}

- (void)setCurrentTime:(NSInteger)currentTime {
	_currentTime = currentTime;
	
	NSInteger min = currentTime / 60;
	NSInteger sec = currentTime % 60;
	self.currentTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", min, sec];
    
    [self.slider setValue:currentTime animated:YES];
}

- (void)setPlaying:(BOOL)playing {
	_playing = playing;
	
	self.playButton.selected = !playing;
}

/**
 * 初始化控件
 */
- (void)setupViews {
	//当播放时间
	UIFont *timeFont = [UIFont systemFontOfSize:10];
	UIColor *timeColor = HJRGB(204, 231, 252);
	UILabel *currentTimeLabel = [UILabel new];
	currentTimeLabel.font = timeFont;
	currentTimeLabel.textColor = timeColor;
	currentTimeLabel.text = @"00:00";
	[self addSubview:currentTimeLabel];
	self.currentTimeLabel = currentTimeLabel;
	
	//音乐总时间
	UILabel *totalTimeLabel = [UILabel new];
	totalTimeLabel.font = timeFont;
	totalTimeLabel.textColor = timeColor;
	totalTimeLabel.text = @"00:00";
	[self addSubview:totalTimeLabel];
	self.totalTimeLabel = totalTimeLabel;
	
	//播放进度滑竿
	UISlider *slider = [UISlider new];
	[slider setThumbImage:[UIImage imageWithUnCachedName:[HJMusicPlayBundle stringByAppendingPathComponent:@"cm2_fm_playbar_btn"]] forState:UIControlStateNormal];
	[slider setMinimumTrackTintColor:HJBaseColor];
	[slider setMaximumTrackTintColor:HJRGB(116, 151, 173)];
	[self addSubview:slider];
	self.slider = slider;
	
	UIView *playBottomView = [UIView new];
	[self addSubview:playBottomView];
	self.playBottomView = playBottomView;
	
	//播放模式
	UIButton *playModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[playModeButton setImage:[UIImage imageWithUnCachedName:[HJMusicPlayBundle stringByAppendingPathComponent:@"cm2_play_btn_loop"]] forState:UIControlStateNormal];
	[playModeButton setImage:[UIImage imageWithUnCachedName:[HJMusicPlayBundle stringByAppendingPathComponent:@"cm2_play_btn_loop_prs"]] forState:UIControlStateHighlighted];
	playModeButton.tag = HJMusicPlayActionAllCycle;
	[playModeButton addTarget:self action:@selector(handlePlayModeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.playBottomView addSubview:playModeButton];
	self.playModeButton = playModeButton;
	
	//播放列表按钮
	UIButton *playListButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[playListButton setImage:[UIImage imageWithUnCachedName:[HJMusicPlayBundle stringByAppendingPathComponent:@"cm2_play_btn_src"]] forState:UIControlStateNormal];
	[playListButton setImage:[UIImage imageWithUnCachedName:[HJMusicPlayBundle stringByAppendingPathComponent:@"cm2_play_btn_src_prs"]] forState:UIControlStateNormal];
	[playListButton addTarget:self action:@selector(handlePlayListButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.playBottomView addSubview:playListButton];
	self.playListButton = playListButton;
	
	//上一首按钮
	UIButton *previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[previewButton setImage:[UIImage imageWithUnCachedName:[HJMusicPlayBundle stringByAppendingPathComponent:@"cm2_play_btn_prev"]] forState:UIControlStateNormal];
	[previewButton setImage:[UIImage imageWithUnCachedName:[HJMusicPlayBundle stringByAppendingPathComponent:@"cm2_play_btn_prev_prs"]] forState:UIControlStateHighlighted];
	[previewButton addTarget:self action:@selector(handlePreviewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.playBottomView addSubview:previewButton];
	self.previewButton = previewButton;
	
	//播放按钮
	UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[playButton setImage:[UIImage imageWithUnCachedName:[HJMusicPlayBundle stringByAppendingPathComponent:@"cm2_fm_btn_play"]] forState:UIControlStateSelected];
	[playButton setImage:[UIImage imageWithUnCachedName:[HJMusicPlayBundle stringByAppendingPathComponent:@"cm2_fm_btn_play_prs"]] forState:UIControlStateSelected | UIControlStateHighlighted];
	
	[playButton setImage:[UIImage imageWithUnCachedName:[HJMusicPlayBundle stringByAppendingPathComponent:@"cm2_fm_btn_pause"]] forState:UIControlStateNormal];
	[playButton setImage:[UIImage imageWithUnCachedName:[HJMusicPlayBundle stringByAppendingPathComponent:@"cm2_fm_btn_pause_prs"]] forState:UIControlStateHighlighted];
	[playButton addTarget:self action:@selector(handlePlayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.playBottomView addSubview:playButton];
	self.playButton = playButton;
	
	//下一首按钮
	UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[nextButton setImage:[UIImage imageWithUnCachedName:[HJMusicPlayBundle stringByAppendingPathComponent:@"cm2_fm_btn_next"]] forState:UIControlStateNormal];
	[nextButton setImage:[UIImage imageWithUnCachedName:[HJMusicPlayBundle stringByAppendingPathComponent:@"cm2_fm_btn_next_prs"]] forState:UIControlStateHighlighted];
	[nextButton addTarget:self action:@selector(handleNextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.playBottomView addSubview:nextButton];
	self.nextButton = nextButton;
	
	[self setupConstraints];
}

#pragma mark - user event
/**
 * 点击播放模式按钮
 */
- (void)handlePlayModeButtonClick:(UIButton *)button {
	if (button.tag == HJMusicPlayActionAllCycle) {
		button.tag = HJMusicPlayActionSingleCycle;
		
		[button setImage:[UIImage imageWithUnCachedName:[HJMusicPlayBundle stringByAppendingPathComponent:@"cm2_play_btn_one"]] forState:UIControlStateNormal];
		[button setImage:[UIImage imageWithUnCachedName:[HJMusicPlayBundle stringByAppendingPathComponent:@"cm2_play_btn_one_prs"]] forState:UIControlStateHighlighted];
		
		if (self.actionChangeBlock) {
			self.actionChangeBlock(HJMusicPlayActionSingleCycle);
		}
	} else if (button.tag == HJMusicPlayActionSingleCycle) {
		button.tag = HJMusicPlayActionRandom;
		
		[button setImage:[UIImage imageWithUnCachedName:[HJMusicPlayBundle stringByAppendingPathComponent:@"cm2_play_btn_order"]] forState:UIControlStateNormal];
		[button setImage:[UIImage imageWithUnCachedName:[HJMusicPlayBundle stringByAppendingPathComponent:@"cm2_play_btn_order_prs"]] forState:UIControlStateHighlighted];
		
		if (self.actionChangeBlock) {
			self.actionChangeBlock(HJMusicPlayActionRandom);
		}
	} else if (button.tag == HJMusicPlayActionRandom) {
		button.tag = HJMusicPlayActionAllCycle;
		
		[button setImage:[UIImage imageWithUnCachedName:[HJMusicPlayBundle stringByAppendingPathComponent:@"cm2_play_btn_loop"]] forState:UIControlStateNormal];
		[button setImage:[UIImage imageWithUnCachedName:[HJMusicPlayBundle stringByAppendingPathComponent:@"cm2_play_btn_loop_prs"]] forState:UIControlStateHighlighted];
		
		if (self.actionChangeBlock) {
			self.actionChangeBlock(HJMusicPlayActionAllCycle);
		}
	}
	
}
/**
 * 点击播放列表按钮
 */
- (void)handlePlayListButtonClick:(UIButton *)button {
	if (self.actionChangeBlock) {
		self.actionChangeBlock(HJMusicPlayActionPlayList);
	}
}
/**
 * 点击上一首按钮
 */
- (void)handlePreviewButtonClick:(UIButton *)button {
	if (self.actionChangeBlock) {
		self.actionChangeBlock(HJMusicPlayActionPreview);
	}
}
/**
 * 点击播放、暂停按钮
 */
- (void)handlePlayButtonClick:(UIButton *)button {
	button.selected = !button.isSelected;
	if (self.actionChangeBlock) {
		self.actionChangeBlock(button.isSelected ? HJMusicPlayActionPause : HJMusicPlayActionPlay);
	}
}
/**
 * 点击下一首按钮
 */
- (void)handleNextButtonClick:(UIButton *)button {
	if (self.actionChangeBlock) {
		self.actionChangeBlock(HJMusicPlayActionNext);
	}
}

/**
 * 初始化控件约束
 */
- (void)setupConstraints {
	HJWeakSelf;
	CGFloat timeMarginLeft = 10;
	CGFloat timeWidth = 30;
	[self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(timeWidth, weakSelf.currentTimeLabel.font.lineHeight));
		make.left.mas_equalTo(weakSelf).offset(timeMarginLeft);
		make.centerY.mas_equalTo(weakSelf.slider);
	}];
	[self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(timeWidth, weakSelf.totalTimeLabel.font.lineHeight));
		make.right.mas_equalTo(weakSelf).offset(-timeMarginLeft);
		make.centerY.mas_equalTo(weakSelf.slider);
	}];
	CGFloat sliderMarginLeft = 5;
	CGFloat sliderMarginTop = 10;
	[self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(weakSelf.currentTimeLabel.mas_right).offset(sliderMarginLeft);
		make.right.mas_equalTo(weakSelf.totalTimeLabel.mas_left).offset(-sliderMarginLeft).priorityLow();
		make.top.mas_equalTo(weakSelf).offset(sliderMarginTop);
	}];
    if (iPhone4) {
        sliderMarginTop = 0;
    }
	[self.playBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.bottom.mas_equalTo(weakSelf);
		make.top.mas_equalTo(weakSelf.slider.mas_bottom).offset(sliderMarginTop).priorityLow();
	}];
	CGFloat playModeMarginLeft = 15;
	[self.playModeButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(weakSelf.playModeButton.imageView.image.size);
		make.left.mas_equalTo(weakSelf.playBottomView).offset(playModeMarginLeft);
		make.centerY.mas_equalTo(weakSelf.playButton);
    }];
	[self.playListButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(weakSelf.playListButton.imageView.image.size);
		make.right.mas_equalTo(weakSelf.playBottomView).offset(-playModeMarginLeft);
		make.centerY.mas_equalTo(weakSelf.playButton);
	}];
    
	[self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(weakSelf.playButton.imageView.image.size);
		make.centerY.mas_equalTo(weakSelf.playBottomView);
		make.centerX.mas_equalTo(weakSelf.playBottomView);
	}];
	CGFloat previewButtonMarginRight = 15;
	[self.previewButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(weakSelf.previewButton.imageView.image.size);
		make.right.mas_equalTo(weakSelf.playButton.mas_left).offset(-previewButtonMarginRight);
		make.centerY.mas_equalTo(weakSelf.playButton);
    }];
	[self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(weakSelf.nextButton.imageView.image.size);
		make.left.mas_equalTo(weakSelf.playButton.mas_right).offset(previewButtonMarginRight);
		make.centerY.mas_equalTo(weakSelf.playButton);
	}];
}

@end
