//
//  HJMusicPlayViewController.h
//  JustWay
//
//  Created by HeJun on 28/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJCommonBaseViewController.h"
@class HJMusicPlayModel;

@interface HJMusicPlayViewController : HJCommonBaseViewController

/** 音乐播放数据模型 */
//@property (nonatomic, copy) NSURL *playUrl;
@property (nonatomic, strong) HJMusicPlayModel *playModel;
/** 音乐列表 */
@property (nonatomic, strong) NSMutableArray<HJMusicPlayModel *> *musicList;

@end
