//
//  HJMusicLyricTool.m
//  JustWay
//
//  Created by HeJun on 05/07/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import "HJMusicLyricTool.h"
#import "HJMusicPlayLyricModel.h"

@implementation HJMusicLyricTool

#pragma mark - 歌词解析
/**
 * 歌词解析
 *
 * @param lyricUrl 歌词文件URL
 */
- (NSMutableArray *)parseLyric:(NSURL *)lyricUrl {
	NSString *lyricStr = [NSString stringWithContentsOfURL:lyricUrl encoding:NSUTF8StringEncoding error:nil];
	HJLog(@"lyric : %@", lyricStr);
	
	if (lyricStr.length == 0) {
		return nil;
	}
	
	NSArray *lyricArray = [lyricStr componentsSeparatedByString:@"\n"];
	NSInteger offset = 0;
	NSMutableArray *lyricList = [NSMutableArray array];
	for (NSString *lrc in lyricArray) {
		if (lrc.length == 0) {
			continue;
		}
		NSString *regexStr = @"\\[\\d{2}:\\d{2}\\.\\d{2}\\].+";
		regexStr = @"\\[([0-9]|[offset])+:[0-9:.]+\\]";
		NSError *error = nil;
		NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionAnchorsMatchLines error:&error];
		NSArray<NSTextCheckingResult *> *results = [regex matchesInString:lrc options:NSMatchingReportCompletion range:[lrc rangeOfString:lrc]];
		
		if (results.count == 0) {
			continue;
		}
		NSString *lrcStr = [self lyricStrWithLrc:lrc results:results];
		for (NSTextCheckingResult *result in results) {
			NSString *timeStr = [lrc substringWithRange:result.range];
			NSString *tStr = [timeStr substringWithRange:NSMakeRange(1, MAX(timeStr.length - 2, 0))];
			if ([tStr hasPrefix:@"offset:"]) {
				NSString *offsetStr = [tStr stringByReplacingOccurrencesOfString:@"offset:" withString:@""];
				offset = [offsetStr integerValue];
				continue;
			}
			NSInteger time = [self lyricTime:tStr offset:offset];
			HJMusicPlayLyricModel *model = [HJMusicPlayLyricModel new];
			model.lyricStr = [lrcStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			model.time = time;
			model.current = NO;
			[lyricList addObject:model];
		}
	}
	[lyricList sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
		HJMusicPlayLyricModel *model1 = (HJMusicPlayLyricModel *)obj1;
		HJMusicPlayLyricModel *model2 = (HJMusicPlayLyricModel *)obj2;
		if (model1.time > model2.time) {
			return NSOrderedDescending;
		} else if (model1.time < model2.time) {
			return NSOrderedAscending;
		} else {
			return NSOrderedSame;
		}
	}];
	return [lyricList mutableCopy];
	
}

/**
 * 获取歌词文本
 * @param lrc	  当前行的所有歌词文本
 * @param results 匹配到的所有时间信息数组
 */
- (NSString *)lyricStrWithLrc:(NSString *)lrc results:(NSArray<NSTextCheckingResult *> *)results {
	NSTextCheckingResult *result = results[results.count - 1];
	//	NSString *timeStr = [lrc substringWithRange:result.range];
	NSString *lrcStr = @"";
	NSInteger location = result.range.location + result.range.length - 1;
	if (MAX(0, location) + 1 < lrc.length) {
		lrcStr = [lrc substringFromIndex:MAX(0, location) + 1];
	}
	return lrcStr;
}

/**
 * 解析歌词时间
 */
- (CGFloat)lyricTime:(NSString *)timeStr offset:(NSInteger)offset {
	NSArray *timeStrArray = [timeStr componentsSeparatedByString:@":"];
	if (timeStrArray.count != 2) {
		return 0;
	}
	CGFloat time = [timeStrArray[0] integerValue] * 60 + [timeStrArray[1] floatValue];
	time = time + offset / 1000.0;
	return time;
}

@end
