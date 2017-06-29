//
//  HJNewsModel.h
//  JustWay
//
//  Created by HeJun on 29/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJNewsModel : NSObject

/** 文件名 */
@property (nonatomic, copy)	  NSString		 *fileName;
/** 文件大小 */
@property (nonatomic, assign) NSInteger		 fileSize;
/** 创建时间 */
@property (nonatomic, assign) NSTimeInterval createTime;
/** 文件路径 */
@property (nonatomic, copy)	  NSString		 *filePath;

@end
