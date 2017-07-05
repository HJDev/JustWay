//
//  HJMusicPlayViewController.h
//  JustWay
//
//  Created by HeJun on 28/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJBaseViewController.h"

@interface HJMusicPlayViewController : HJBaseViewController

/** 音乐播放地址 */
@property (nonatomic, copy) NSString *playUrl;
/** 音乐列表 */
@property (nonatomic, strong) NSMutableArray *musicList;

@end
