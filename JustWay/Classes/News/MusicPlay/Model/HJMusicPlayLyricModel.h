//
//  HJMusicPlayLyricModel.h
//  JustWay
//
//  Created by HeJun on 05/07/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 歌词左右边距 */
static const CGFloat lyricLabelMarginLeft = 50;

@interface HJMusicPlayLyricModel : NSObject

/** 歌词时间 */
@property (nonatomic, assign) CGFloat  time;
/** 歌词文本 */
@property (nonatomic, copy)	  NSString *lyricStr;
/** 是否为当前歌词 */
@property (nonatomic, assign) BOOL	   current;
#pragma mark - 富文本
/** 歌词富文本 */
@property (nonatomic, copy, readonly) NSMutableAttributedString *lyricAttr;

@end
