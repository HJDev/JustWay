//
//  HJNewsTableViewCell.m
//  JustWay
//
//  Created by HeJun on 29/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import "HJNewsTableViewCell.h"
#import <Masonry.h>

@interface HJNewsTableViewCell()

/** icon 图标 */
@property (nonatomic, weak) UIImageView *iconView;
/** 文件名 */
@property (nonatomic, weak) UILabel		*titleLabel;
/** 文件详细信息 */
@property (nonatomic, weak) UILabel		*subTitleLabel;

@end

@implementation HJNewsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		[self setupViews];
	}
	return self;
}

- (void)setupViews {
	UIImageView *iconView = [UIImageView new];
	[self.contentView addSubview:iconView];
	self.iconView = iconView;
	
	UILabel *titleLabel = [UILabel new];
	titleLabel.font = [UIFont systemFontOfSize:15];
	titleLabel.textColor = HJRGB(0, 0, 0);
	[self.contentView addSubview:titleLabel];
	self.titleLabel = titleLabel;
	
	UILabel *subTitleLabel = [UILabel new];
	subTitleLabel.font = [UIFont systemFontOfSize:12];
	subTitleLabel.textColor = HJRGB(155, 155, 155);
	[self.contentView addSubview:subTitleLabel];
	self.subTitleLabel = subTitleLabel;
	
	[self setupConstraints];
}

/**
 * 初始化控件约束
 */
- (void)setupConstraints {
	HJWeakSelf;
	[self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(35, 35));
		make.centerY.mas_equalTo(weakSelf.contentView);
		make.left.mas_equalTo(10);
	}];
	
	[self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(weakSelf.iconView.mas_right).offset(5);
		make.top.mas_equalTo(weakSelf.iconView);
		make.height.mas_equalTo(weakSelf.titleLabel.font.lineHeight);
		make.right.mas_lessThanOrEqualTo(weakSelf.contentView).offset(-10);
	}];
	
	[self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(weakSelf.titleLabel);
		make.bottom.mas_equalTo(weakSelf.iconView);
		make.height.mas_equalTo(weakSelf.subTitleLabel.font.lineHeight);
		make.right.mas_lessThanOrEqualTo(weakSelf.contentView).offset(-10);
	}];
}

@end
