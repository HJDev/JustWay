//
//  HJMusicPlayControlView.m
//  JustWay
//
//  Created by HeJun on 30/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import "HJMusicPlayControlView.h"
#import <Masonry.h>

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
	
	//资源包
	NSString *bundleName = @"MusicPlayer.bundle";
	//播放进度滑竿
	UISlider *slider = [UISlider new];
	[slider setThumbImage:[UIImage imageWithUnCachedName:[bundleName stringByAppendingPathComponent:@"cm2_fm_playbar_btn"]] forState:UIControlStateNormal];
	[slider setMinimumTrackTintColor:HJRGB(211, 57, 49)];
	[slider setMaximumTrackTintColor:HJRGB(116, 151, 173)];
	[self addSubview:slider];
	self.slider = slider;
	
	UIView *playBottomView = [UIView new];
	[self addSubview:playBottomView];
	self.playBottomView = playBottomView;
	
	//播放模式
	UIButton *playModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[playModeButton setImage:[UIImage imageWithUnCachedName:[bundleName stringByAppendingPathComponent:@"cm2_play_btn_loop"]] forState:UIControlStateNormal];
	[playModeButton setImage:[UIImage imageWithUnCachedName:[bundleName stringByAppendingPathComponent:@"cm2_play_btn_loop_prs"]] forState:UIControlStateHighlighted];
	[self.playBottomView addSubview:playModeButton];
	self.playModeButton = playModeButton;
	
	//播放列表按钮
	UIButton *playListButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[playListButton setImage:[UIImage imageWithUnCachedName:[bundleName stringByAppendingPathComponent:@"cm2_play_btn_src"]] forState:UIControlStateNormal];
	[playListButton setImage:[UIImage imageWithUnCachedName:[bundleName stringByAppendingPathComponent:@"cm2_play_btn_src_prs"]] forState:UIControlStateNormal];
	[self.playBottomView addSubview:playListButton];
	self.playListButton = playListButton;
	
	//上一首按钮
	UIButton *previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[previewButton setImage:[UIImage imageWithUnCachedName:[bundleName stringByAppendingPathComponent:@"cm2_play_btn_prev"]] forState:UIControlStateNormal];
	[previewButton setImage:[UIImage imageWithUnCachedName:[bundleName stringByAppendingPathComponent:@"cm2_play_btn_prev_prs"]] forState:UIControlStateHighlighted];
	[self.playBottomView addSubview:previewButton];
	self.previewButton = previewButton;
	
	//播放按钮
	UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[playButton setImage:[UIImage imageWithUnCachedName:[bundleName stringByAppendingPathComponent:@"cm2_runfm_btn_play"]] forState:UIControlStateNormal];
	[playButton setImage:[UIImage imageWithUnCachedName:[bundleName stringByAppendingPathComponent:@"cm2_runfm_btn_play_prs"]] forState:UIControlStateHighlighted];
	[self.playBottomView addSubview:playButton];
	self.playButton = playButton;
	
	//下一首按钮
	UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[nextButton setImage:[UIImage imageWithUnCachedName:[bundleName stringByAppendingPathComponent:@"cm2_runfm_btn_next"]] forState:UIControlStateNormal];
	[nextButton setImage:[UIImage imageWithUnCachedName:[bundleName stringByAppendingPathComponent:@"cm2_runfm_btn_next_prs"]] forState:UIControlStateHighlighted];
	[self.playBottomView addSubview:nextButton];
	self.nextButton = nextButton;
	
	[self setupConstraints];
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
