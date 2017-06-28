//
//  HJUploaderServer.h
//  JustWay
//
//  Created by HeJun on 28/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJUploaderServer : NSObject

+ (instancetype)sharedInstance;

/** 启动上传服务器 */
- (BOOL)startWithDir:(NSString *)dir port:(NSUInteger)port;
/** 停止服务器 */
- (void)stop;

/**
 * 获取文件及文件夹列表
 */
- (NSMutableArray *)getFileListWithDir:(NSString *)dir;

@end
