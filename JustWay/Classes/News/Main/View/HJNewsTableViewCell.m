//
//  HJNewsTableViewCell.m
//  JustWay
//
//  Created by HeJun on 29/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import "HJNewsTableViewCell.h"
#import <Masonry.h>
#import "HJNewsModel.h"

/** 动态列表ICON */
#define NewsListIconsBundle @"NewsListIcons.bundle"

@interface HJNewsTableViewCell()

/** icon 图标 */
@property (nonatomic, weak) UIImageView *iconView;
/** 文件名 */
@property (nonatomic, weak) UILabel		*titleLabel;
/** 文件详细信息 */
@property (nonatomic, weak) UILabel		*subTitleLabel;
/** 分割线 */
@property (nonatomic, weak) UIView      *separateLine;

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
	iconView.image = [UIImage imageWithUnCachedName:[NewsListIconsBundle stringByAppendingPathComponent:@"dir_grid_small_hlp"]];
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
    
    UIView *separateLine = [UIView new];
    separateLine.backgroundColor = [UIColor lightGrayColor];
    separateLine.alpha = 0.5;
    [self.contentView addSubview:separateLine];
    self.separateLine = separateLine;
	
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
		make.left.mas_equalTo(weakSelf.iconView.mas_right).offset(10);
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
    
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.titleLabel);
        make.right.bottom.mas_equalTo(weakSelf.contentView);
        make.height.mas_equalTo(1);
    }];
}

- (void)setModel:(HJNewsModel *)model {
	_model = model;
	
	NSString *fileSizeStr = [NSString stringWithFormat:@"%@",
							 [NSByteCountFormatter stringFromByteCount:model.fileSize countStyle:NSByteCountFormatterCountStyleFile]];
	NSString *createTimeStr = [NSDate formateDate:model.createTime formate:@"yyyy-MM-dd HH:mm"];
	self.titleLabel.text = model.fileName;
	self.subTitleLabel.text = [NSString stringWithFormat:@"%@ %@", createTimeStr, fileSizeStr];
	if (model.fileType == NSFileTypeDirectory) {
		self.iconView.image = [UIImage imageWithUnCachedName:[NewsListIconsBundle stringByAppendingPathComponent:@"ico_folder_small"]];
	} else {
		self.iconView.image = [UIImage imageWithUnCachedName:[self getFileTypeIconNameWithFileName:model.fileName]];
	}
}

- (NSString *)getFileTypeIconNameWithFileName:(NSString *)fileName {
	if ([fileName hasSuffix:@".mp3"] || [fileName hasSuffix:@".m4a"]) {
		return [NewsListIconsBundle stringByAppendingPathComponent:@"dir_grid_small_mp3"];
	} else if ([fileName hasSuffix:@".mp4"]) {
		return [NewsListIconsBundle stringByAppendingPathComponent:@"dir_grid_small_mov"];
	} else if ([fileName hasSuffix:@".apk"]) {
		return [NewsListIconsBundle stringByAppendingPathComponent:@"dir_grid_small_apk"];
	} else if ([fileName hasSuffix:@".ipa"]) {
		return [NewsListIconsBundle stringByAppendingPathComponent:@"dir_grid_small_ipa"];
	} else if ([fileName hasSuffix:@".doc"] || [fileName hasSuffix:@".docx"]) {
		return [NewsListIconsBundle stringByAppendingPathComponent:@"dir_grid_small_doc"];
	} else if ([fileName hasSuffix:@".xls"] || [fileName hasSuffix:@"xlsx"]) {
		return [NewsListIconsBundle stringByAppendingPathComponent:@"dir_grid_small_xls"];
	} else if ([fileName hasSuffix:@".ppt"] || [fileName hasSuffix:@"pptx"]) {
		return [NewsListIconsBundle stringByAppendingPathComponent:@"dir_grid_small_ppt"];
	} else if ([fileName hasSuffix:@".txt"]) {
		return [NewsListIconsBundle stringByAppendingPathComponent:@"dir_grid_small_txt"];
	} else if ([fileName hasSuffix:@".pdf"]) {
		return [NewsListIconsBundle stringByAppendingPathComponent:@"dir_grid_small_pdf"];
	} else if ([fileName hasSuffix:@".jpg"] || [fileName hasSuffix:@".jpeg"] || [fileName hasSuffix:@".png"]) {
		return [NewsListIconsBundle stringByAppendingPathComponent:@"dir_grid_small_bmp"];
	} else if ([fileName hasSuffix:@".pages"]) {
		return [NewsListIconsBundle stringByAppendingPathComponent:@"dir_grid_small_pages"];
	} else if ([fileName hasSuffix:@".numbers"]) {
		return [NewsListIconsBundle stringByAppendingPathComponent:@"dir_grid_small_numbers"];
	} else if ([fileName hasSuffix:@".key"]) {
		return [NewsListIconsBundle stringByAppendingPathComponent:@"dir_grid_small_key"];
	} else if ([fileName hasSuffix:@".ai"]) {
		return [NewsListIconsBundle stringByAppendingPathComponent:@"dir_grid_small_ai"];
	} else if ([fileName hasSuffix:@".psd"]) {
		return [NewsListIconsBundle stringByAppendingPathComponent:@"dir_grid_small_psd"];
	} else if ([fileName hasSuffix:@".vsd"]) {
		return [NewsListIconsBundle stringByAppendingPathComponent:@"dir_grid_small_vsd"];
	} else if ([fileName hasSuffix:@".swf"]) {
		return [NewsListIconsBundle stringByAppendingPathComponent:@"dir_grid_small_swf"];
	} else if ([fileName hasSuffix:@".xml"]) {
		return [NewsListIconsBundle stringByAppendingPathComponent:@"dir_grid_small_xml"];
	} else if ([fileName hasSuffix:@".zip"]) {
		return [NewsListIconsBundle stringByAppendingPathComponent:@"dir_grid_small_zip"];
	} else if ([fileName hasSuffix:@".bat"]) {
		return [NewsListIconsBundle stringByAppendingPathComponent:@"dir_grid_small_bat"];
	}
	return [NewsListIconsBundle stringByAppendingPathComponent:@"dir_grid_small_hlp"];
}

@end
