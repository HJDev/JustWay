//
//  HJMusicPlayLyricModel.m
//  JustWay
//
//  Created by HeJun on 05/07/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import "HJMusicPlayLyricModel.h"

@implementation HJMusicPlayLyricModel

/** 歌词文本 */
- (NSString *)lyricStr {
	if (_lyricStr == nil) {
		_lyricStr = @"";
	}
	return _lyricStr;
}

- (void)setCurrent:(BOOL)current {
	_current = current;
	
	NSMutableAttributedString *lyricAttr = [[NSMutableAttributedString alloc] initWithString:self.lyricStr];
	if (current) {
		[lyricAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:[lyricAttr.string rangeOfString:lyricAttr.string]];
		[lyricAttr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:[lyricAttr.string rangeOfString:lyricAttr.string]];
	} else {
		[lyricAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:[lyricAttr.string rangeOfString:lyricAttr.string]];
		[lyricAttr addAttribute:NSForegroundColorAttributeName value:HJRGB(179, 179, 179) range:[lyricAttr.string rangeOfString:lyricAttr.string]];
	}
	_lyricAttr = lyricAttr;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"time : %.2f lyric : %@", self.time, self.lyricStr];
}

@end
