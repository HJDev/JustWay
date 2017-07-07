//
//  HJMusicPlayLyricView.m
//  JustWay
//
//  Created by HeJun on 30/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import "HJMusicPlayLyricView.h"
#import "HJMusicPlayLyricModel.h"
#import "HJMusicLyricTool.h"
#import "HJMusicLyricTableViewCell.h"
#import <Masonry.h>

@interface HJMusicPlayLyricView()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak)	  UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<HJMusicPlayLyricModel *> *dataList;
@property (nonatomic, assign) NSInteger currentLyricIndex;

@end

@implementation HJMusicPlayLyricView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = MusicPlayLyricBackgroundColor;
		_previousLrc = @"";
		_nextLrc = @"";
		_currentLrc = @"";
		[self setupViews];
	}
	return self;
}

#pragma mark - init
- (void)setupViews {
	UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self addSubview:tableView];
	self.tableView = tableView;
	
	HJWeakSelf;
	CGFloat tableViewMarginTop = 0;
	[self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.mas_equalTo(weakSelf);
		make.top.mas_equalTo(weakSelf).offset(tableViewMarginTop);
		make.bottom.mas_equalTo(weakSelf).offset(-tableViewMarginTop);
	}];
}

#pragma mark - setter
- (void)setPlaying:(BOOL)playing {
	_playing = playing;
}

- (void)setCurrentTime:(CGFloat)currentTime {
	_currentTime = currentTime;
	
	NSInteger i = 0;
	for (HJMusicPlayLyricModel *model in self.dataList) {
		NSInteger nextIndex = i;
		if (i + 1 < self.dataList.count) {
			nextIndex = i + 1;
		}
		HJMusicPlayLyricModel *nextModel = [self.dataList objectAtIndex:nextIndex];
		_nextLrc = nextModel.lyricStr;
		if (model.time <= currentTime && nextModel.time > currentTime) {
			if (i == self.currentLyricIndex) {
				return;
			}
			NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.currentLyricIndex inSection:0];
			HJMusicPlayLyricModel *lastModel = [self.dataList objectAtIndex:self.currentLyricIndex];
			lastModel.current = NO;
			_previousLrc = lastModel.lyricStr;
			HJMusicPlayLyricModel *currentModel = [self.dataList objectAtIndex:i];
			currentModel.current = YES;
			_currentLrc = currentModel.lyricStr;
			self.currentLyricIndex = i;
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
			[self.tableView reloadRowsAtIndexPaths:@[lastIndexPath, indexPath] withRowAnimation:UITableViewRowAnimationNone];
			[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
		}
		i++;
	}
}

- (void)setLyricUrl:(NSURL *)lyricUrl {
	_lyricUrl = lyricUrl;
	
	self.currentLyricIndex = 0;
	self.dataList = [[HJMusicLyricTool alloc] parseLyric:lyricUrl];
	[self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	HJMusicLyricTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJMusicLyricTableViewCell class])];
	if (cell == nil) {
		cell = [[HJMusicLyricTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HJMusicLyricTableViewCell class])];
	}
	if (indexPath.row >= self.dataList.count) {
		return cell;
	}
	HJMusicPlayLyricModel *model = [self.dataList objectAtIndex:indexPath.row];
	cell.model = model;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	HJLog(@"===");
}

#pragma mark - lazyload
- (NSMutableArray<HJMusicPlayLyricModel *> *)dataList {
	if (_dataList == nil) {
		_dataList = [NSMutableArray<HJMusicPlayLyricModel *> new];
	}
	return _dataList;
}

@end
