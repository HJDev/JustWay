//
//  HJMusicPlayLyricView.m
//  JustWay
//
//  Created by HeJun on 30/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import "HJMusicPlayLyricView.h"

@implementation HJMusicPlayLyricView

#pragma mark - setter
- (void)setPlaying:(BOOL)playing {
	_playing = playing;
}

- (void)setLyricUrl:(NSURL *)lyricUrl {
	_lyricUrl = lyricUrl;
	
	[self parseLyric:lyricUrl];
}

#pragma mark - 歌词解析
- (NSDictionary *)parseLyric:(NSURL *)lyricUrl {
	NSString *lyricStr = [NSString stringWithContentsOfURL:lyricUrl encoding:NSUTF8StringEncoding error:nil];
	HJLog(@"lyric : %@", lyricStr);
	
	if (lyricStr.length == 0) {
		return nil;
	}
	NSArray *lyricArray = [lyricStr componentsSeparatedByString:@"\n"];
	for (NSString *lrc in lyricArray) {
		NSArray *lrcArray = [lrc componentsSeparatedByString:@"]"];
		HJLog(@"%@", lrcArray);
	}
	
	return nil;
}

@end
