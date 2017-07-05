//
//  HJMusicLyricTool.h
//  JustWay
//
//  Created by HeJun on 05/07/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJMusicLyricTool : NSObject

/**
 * 歌词解析
 *
 * @param lyricUrl 歌词文件URL
 */
- (NSMutableArray *)parseLyric:(NSURL *)lyricUrl;

@end
