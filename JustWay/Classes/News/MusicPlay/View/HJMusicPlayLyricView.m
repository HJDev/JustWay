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
        if (lrc.length == 0) {
            continue;
        }
        NSString *regexStr = @"\\[\\d{2}:\\d{2}\\.\\d{2}\\].+";
        regexStr = @"\\[[a-zA-Z0-9]+:[a-zA-Z0-9_:.]+\\]";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionAnchorsMatchLines error:&error];
        NSArray<NSTextCheckingResult *> *results = [regex matchesInString:lrc options:NSMatchingReportCompletion range:[lrc rangeOfString:lrc]];
        
        NSMutableString *currentLyric = [NSMutableString string];
        for (NSTextCheckingResult *result in results) {
//            HJLog(@"%@", result);
            [currentLyric appendString:[lrc substringWithRange:result.range]];
            [currentLyric appendString:@"_nnn_"];
        }
        HJLog(@"currentLyric : %@", currentLyric);
//		NSArray *lrcArray = [lrc componentsSeparatedByString:@"]"];
//		HJLog(@"%@", lrcArray);
	}
	
	return nil;
}

@end
