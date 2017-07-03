//
//  HJMusicPlayCoverView.m
//  JustWay
//
//  Created by HeJun on 30/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import "HJMusicPlayCoverView.h"
#import <Masonry.h>

/** 底部透明块的宽度 */
#define TransparentViewWidth ([UIApplication sharedApplication].keyWindow.bounds.size.width * (9.0 / 11.0))
/** 黑色块距左边控件距离 */
#define BlacViewMarginLeft 10
/** 封面图片距左边控件距离 */
#define CoverViewMarginLeft 30
/** 封面旋转动画KEY */
#define kCoverAnimation @"rotationAnimation"

@interface HJMusicPlayCoverView()

/** 底部透明View */
@property (nonatomic, weak) UIView      *transparentView;
/** 中间黑色View */
@property (nonatomic, weak) UIImageView *blackView;
/** 封面图片 */
@property (nonatomic, weak) UIImageView *coverImageView;
/** 唱片探针 */
@property (nonatomic, weak) UIImageView *probeImageView;

/** 动画速度 */
@property (nonatomic, assign) CGFloat   animationSpeed;
/** 底部透明块的直径 */
@property (nonatomic, assign) CGFloat   transparentViewWidth;

@end

@implementation HJMusicPlayCoverView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.transparentViewWidth = TransparentViewWidth;
        if (iPhone4) {
            self.transparentViewWidth = self.transparentViewWidth - 70;
        } else if (iPhone5) {
            self.transparentViewWidth = self.transparentViewWidth - 30;
        } else if (iPhone6) {
            self.transparentViewWidth = self.transparentViewWidth + 5;
        }
        [self setupViews];
        
        UITapGestureRecognizer *mainTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMainTap)];
        [self addGestureRecognizer:mainTap];
        self.userInteractionEnabled = YES;
    }
    return self;
}

#pragma mark - user event
/**
 * 点击View
 */
- (void)handleMainTap {
    if (self.coverImageView.layer.speed != 0.0) {
        [self stopCycleAnimation];
    } else {
        [self startCycleyAnimation];
    }
}

/**
 * 初始化控件
 */
- (void)setupViews {
    //底部透明View
    UIView *transparentView = [UIView new];
    transparentView.backgroundColor = HJRGBA(255, 255, 255, 0.1);
    transparentView.layer.cornerRadius = self.transparentViewWidth * 0.5;
    transparentView.clipsToBounds = YES;
    [self addSubview:transparentView];
    self.transparentView = transparentView;
    
    //中间黑色View
    //资源包
    NSString *bundleName = @"MusicPlayer.bundle";
    CGFloat blackViewWidth = (self.transparentViewWidth - BlacViewMarginLeft * 2);
    UIImageView *blackView = [UIImageView new];
//    blackView.backgroundColor = [UIColor blackColor];
    blackView.image = [UIImage imageWithUnCachedName:[bundleName stringByAppendingPathComponent:@"cm2_default_cover_play@2x.jpg"]];
    blackView.layer.cornerRadius = blackViewWidth * 0.5;
    blackView.clipsToBounds = YES;
    [self addSubview:blackView];
    self.blackView = blackView;
    
    //封面图片
    UIImageView *coverImageView = [UIImageView new];
    coverImageView.layer.cornerRadius = (blackViewWidth - CoverViewMarginLeft * 2) * 0.5;
    coverImageView.clipsToBounds = YES;
    [self addSubview:coverImageView];
    self.coverImageView = coverImageView;
    self.coverImageView.backgroundColor = HJRANDOM;
    self.coverImageView.image = [UIImage imageWithUnCachedName:@"image"];
    
    //唱片探针
    UIImageView *probeImageView = [UIImageView new];
    probeImageView.image = [UIImage imageWithUnCachedName:[bundleName stringByAppendingPathComponent:@"cm2_play_needle_play"]];
    [self addSubview:probeImageView];
    self.probeImageView = probeImageView;
    
    [self setupConstraints];
}

/**
 * 初始化控件约束
 */
- (void)setupConstraints {
    HJWeakSelf;
    [self.transparentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakSelf.transparentViewWidth);
        make.height.mas_equalTo(weakSelf.transparentView.mas_width);
        make.center.mas_equalTo(weakSelf);
    }];
    
    [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.transparentView).offset(BlacViewMarginLeft);
        make.right.mas_equalTo(weakSelf.transparentView).offset(-BlacViewMarginLeft);
        make.height.mas_equalTo(weakSelf.blackView.mas_width);
        make.center.mas_equalTo(weakSelf.transparentView);
    }];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.blackView).offset(CoverViewMarginLeft);
        make.right.mas_equalTo(weakSelf.blackView).offset(-CoverViewMarginLeft);
        make.width.mas_equalTo(weakSelf.coverImageView.mas_height);
        make.center.mas_equalTo(weakSelf.transparentView);
    }];
    
    CGFloat probeImageViewMarginTop = -16.0;
    if (iPhone6PLUS) {
        probeImageViewMarginTop = -31;
    }
    [self.probeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf).offset(probeImageViewMarginTop);
        make.centerX.mas_equalTo(weakSelf).offset(30);
        make.size.mas_equalTo(weakSelf.probeImageView.image.size);
    }];
}

/**
 * 添加封面旋转动画
 */
- (void)setupCycleAnimation {
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    baseAnimation.toValue = @(2 * M_PI);
    baseAnimation.duration = 50;
    baseAnimation.repeatCount = NSIntegerMax;
    baseAnimation.removedOnCompletion = NO;
    [self.coverImageView.layer addAnimation:baseAnimation forKey:kCoverAnimation];
    
    self.animationSpeed = self.coverImageView.layer.speed;
    
}

/**
 * 移除封面旋转动画
 */
- (void)removeCycleAnimation {
    [self.coverImageView.layer removeAnimationForKey:kCoverAnimation];
}

/**
 * 停止封面旋转动画
 */
- (void)stopCycleAnimation {
    CFTimeInterval currTimeoffset = [self.coverImageView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.coverImageView.layer.speed = 0.0;
    self.coverImageView.layer.timeOffset = currTimeoffset;
}

- (void)startCycleyAnimation {
    CFTimeInterval pausedTime = [self.coverImageView.layer timeOffset];
    self.coverImageView.layer.speed = self.animationSpeed;
    self.coverImageView.layer.timeOffset = 0.0;
    self.coverImageView.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.coverImageView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.coverImageView.layer.beginTime = timeSincePause;
}

@end
