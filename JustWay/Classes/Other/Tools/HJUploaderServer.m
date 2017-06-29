//
//  HJUploaderServer.m
//  JustWay
//
//  Created by HeJun on 28/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJUploaderServer.h"
#import "GCDWebUploader.h"
#import "HJNewsModel.h"

@interface HJUploaderServer()<GCDWebUploaderDelegate>

@property (nonatomic, strong) GCDWebUploader *uploader;

@end

@implementation HJUploaderServer

+ (instancetype)sharedInstance {
	static HJUploaderServer *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [HJUploaderServer new];
	});
	return instance;
}

- (BOOL)startWithDir:(NSString *)dir port:(NSUInteger)port block:(void (^)(NSObject *))block {
	GCDWebUploader *uploader = [[GCDWebUploader alloc] initWithUploadDirectory:dir];
	uploader.delegate = self;
	uploader.allowHiddenItems = YES;
	self.uploader = uploader;
	
	BOOL start = [uploader startWithPort:port bonjourName:nil];
	if (start) {
		block(uploader.serverURL.absoluteString);
	} else {
		block(nil);
	}
	return start;
}

- (void)stop {
	if (self.uploader) {
		[self.uploader stop];
		self.uploader = nil;
	}
}

#pragma mark - GCDWebUploaderDelegate
- (void)webUploader:(GCDWebUploader*)uploader didUploadFileAtPath:(NSString*)path {
	HJLog(@"[UPLOAD] %@", path);
	[self getFileLists];
}

- (void)webUploader:(GCDWebUploader*)uploader didMoveItemFromPath:(NSString*)fromPath toPath:(NSString*)toPath {
	HJLog(@"[MOVE] %@ -> %@", fromPath, toPath);
	[self getFileLists];
}

- (void)webUploader:(GCDWebUploader*)uploader didDeleteItemAtPath:(NSString*)path {
	HJLog(@"[DELETE] %@", path);
	[self getFileLists];
}

- (void)webUploader:(GCDWebUploader*)uploader didCreateDirectoryAtPath:(NSString*)path {
	HJLog(@"[CREATE] %@", path);
	[self getFileLists];
}

#pragma mark - GCDWebServerDelegate
- (void)webServerDidStart:(GCDWebServer *)server {
	HJLog(@"[START] %@", server.publicServerURL);
}

- (void)webServerDidStop:(GCDWebServer *)server {
	HJLog(@"[STOP] %@", server.publicServerURL);
}

- (void)webServerDidConnect:(GCDWebServer *)server {
	HJLog(@"[CONNECT] %@", server.publicServerURL);
}

- (void)webServerDidDisconnect:(GCDWebServer *)server {
	HJLog(@"[DISCONNECT] %@", server.publicServerURL);
}

#pragma mark - tools
/**
 * 获取文件及文件夹列表
 */
- (void)getFileLists {
	if (self.fileDir == nil) {
		return ;
	}
	
	NSError *error = nil;
	NSFileManager *fm = [NSFileManager defaultManager];
	NSArray *files = [fm contentsOfDirectoryAtPath:self.fileDir error:&error];
	
	NSMutableArray *fileList = [NSMutableArray array];
	for (NSString *fileName in files) {
		NSString *filePath = [self.fileDir stringByAppendingPathComponent:fileName];
		NSDictionary *filesAttr = [fm attributesOfItemAtPath:filePath error:nil];
		
		NSInteger fileSize = [filesAttr[NSFileSize] floatValue];
		NSString *fileDetail = @"";
		fileDetail = [NSString stringWithFormat:@"%@",
					  [NSByteCountFormatter stringFromByteCount:fileSize countStyle:NSByteCountFormatterCountStyleFile]];
		NSDictionary *dic = @{@"title" : fileName, @"detail" : fileDetail};
		HJNewsModel *model = [HJNewsModel new];
		model.fileName = fileName;
		model.fileSize = fileSize;
		model.filePath = [self.fileDir stringByAppendingPathComponent:fileName];
		
		NSString *dateStr = filesAttr[NSFileCreationDate];
		NSDate *date = [NSDate dateWithFormatedTime:dateStr formate:@"yyyy-MM-dd HH:mm zzz"];
//		model.createTime = [filesAttr[NSFileCreationDate] doubleValue];
		
		[fileList addObject:dic];
	}
	
	HJLog(@"%@", files);
	self.fileList = fileList;
//	return fileList;
}

@end
