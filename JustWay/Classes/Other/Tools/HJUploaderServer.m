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

- (BOOL)startWithDir:(NSString *)dir port:(NSUInteger)port {
	GCDWebUploader *uploader = [[GCDWebUploader alloc] initWithUploadDirectory:dir];
	uploader.delegate = self;
	uploader.allowHiddenItems = YES;
	self.uploader = uploader;
//	if ([uploader startWithPort:port bonjourName:nil]) {
//		NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"GCDWebServer running locally on server %@", nil), uploader.serverURL.absoluteString];
//		HJLog(@"%@", msg);
//	} else {
//		NSString *msg = NSLocalizedString(@"GCDWebServer not running!", nil);
//		HJLog(@"%@", msg);
//	}
	return [uploader startWithPort:port bonjourName:nil];
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
}

- (void)webUploader:(GCDWebUploader*)uploader didMoveItemFromPath:(NSString*)fromPath toPath:(NSString*)toPath {
	HJLog(@"[MOVE] %@ -> %@", fromPath, toPath);
}

- (void)webUploader:(GCDWebUploader*)uploader didDeleteItemAtPath:(NSString*)path {
	HJLog(@"[DELETE] %@", path);
}

- (void)webUploader:(GCDWebUploader*)uploader didCreateDirectoryAtPath:(NSString*)path {
	HJLog(@"[CREATE] %@", path);
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
- (NSMutableArray *)getFileListWithDir:(NSString *)dir {
	if (dir == nil) {
		return [NSMutableArray array];
	}
	
	NSError *error = nil;
	NSFileManager *fm = [NSFileManager defaultManager];
	NSArray *files = [fm contentsOfDirectoryAtPath:dir error:&error];
	
	NSMutableArray *fileList = [NSMutableArray array];
	for (NSString *fileName in files) {
		NSString *filePath = [dir stringByAppendingPathComponent:fileName];
		NSDictionary *filesAttr = [fm attributesOfItemAtPath:filePath error:nil];
		
		CGFloat fileSize = [filesAttr[NSFileSize] floatValue];
		NSString *fileDetail = @"";
		fileDetail = [NSString stringWithFormat:@"%@",
					  [NSByteCountFormatter stringFromByteCount:fileSize countStyle:NSByteCountFormatterCountStyleFile]];
		NSDictionary *dic = @{@"title" : fileName, @"detail" : fileDetail};
		
		[fileList addObject:dic];
	}
	
	HJLog(@"%@", files);
	return fileList;
}

@end
