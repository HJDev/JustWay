//
//  HJMusicLyricTableViewCell.h
//  JustWay
//
//  Created by HeJun on 05/07/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HJMusicPlayLyricModel;

#define MusicPlayLyricBackgroundColor [UIColor grayColor]

@interface HJMusicLyricTableViewCell : UITableViewCell

@property (nonatomic, strong) HJMusicPlayLyricModel *model;

@end
