//
//  HJMusicLyricTableViewCell.m
//  JustWay
//
//  Created by HeJun on 05/07/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import "HJMusicLyricTableViewCell.h"
#import "HJMusicPlayLyricModel.h"
#import <Masonry.h>

@interface HJMusicLyricTableViewCell()

@property (nonatomic, weak) UILabel *lyricLabel;

@end
@implementation HJMusicLyricTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.contentView.backgroundColor = [UIColor grayColor];
		[self setupViews];
	}
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setter
- (void)setModel:(HJMusicPlayLyricModel *)model {
	_model = model;
	
	self.lyricLabel.attributedText = model.lyricAttr;
}

- (void)setupViews {
	UILabel *lyricLabel = [UILabel new];
	lyricLabel.numberOfLines = 0;
	lyricLabel.textAlignment = NSTextAlignmentCenter;
	[self.contentView addSubview:lyricLabel];
	self.lyricLabel = lyricLabel;
	
	HJWeakSelf;
	[self.lyricLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(weakSelf.contentView).offset(lyricLabelMarginLeft);
		make.right.mas_equalTo(weakSelf.contentView).offset(-lyricLabelMarginLeft);
		make.top.bottom.mas_equalTo(weakSelf.contentView);
	}];
}

@end
