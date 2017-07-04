//
//  HJMusicPlayLyricView.h
//  JustWay
//
//  Created by HeJun on 30/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJMusicPlayLyricView : UIView

/** 播放状态(YES : 正在播放 NO : 暂停) */
@property (nonatomic, assign) BOOL playing;
/** 歌词文件 */
@property (nonatomic, strong) NSURL *lyricUrl;

@end
