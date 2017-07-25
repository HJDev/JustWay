//
//  HJUploaderServer.h
//  JustWay
//
//  Created by HeJun on 28/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HJNewsModel;

@interface HJUploaderServer : NSObject

+ (instancetype)sharedInstance;

/** 启动上传服务器 */
- (BOOL)startWithDir:(NSString *)dir port:(NSUInteger)port block:(void(^)(NSObject *obj)) block;
/** 停止服务器 */
- (void)stop;

/**
 * 获取文件及文件夹列表
 */
- (void)getFileLists;

@property (nonatomic, strong) NSMutableArray<HJNewsModel *> *fileList;
@property (nonatomic, copy)   NSString		 *fileDir;

@end
