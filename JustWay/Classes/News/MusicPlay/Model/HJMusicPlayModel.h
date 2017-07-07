//
//  HJMusicPlayModel.h
//  JustWay
//
//  Created by HeJun on 06/07/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJMusicPlayModel : NSObject

/** 歌曲名称 */
@property (nonatomic, copy) NSString *playName;
/** 歌曲地址 */
@property (nonatomic, strong) NSURL	 *playUrl;
/** 歌词地址 */
@property (nonatomic, strong) NSURL  *lyricUrl;
/** 歌曲封面地址 */
@property (nonatomic, strong) NSURL  *coverUrl;
/** 演唱者 */
@property (nonatomic, copy) NSString *artist;

@end
