//
//  HJMusicPlayModel.m
//  JustWay
//
//  Created by HeJun on 06/07/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import "HJMusicPlayModel.h"

@implementation HJMusicPlayModel

- (NSString *)playName {
	if (_playName == nil) {
		_playName = [self.playUrl lastPathComponent];
	}
	return _playName;
}

- (NSString *)artist {
	if (_artist == nil) {
		_artist = @"未知";
	}
	return _artist;
}

@end
