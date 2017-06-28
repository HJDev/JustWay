//
//  ViewController.m
//  JustWay
//
//  Created by HeJun on 27/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import "ViewController.h"
#import "GCDWebUploader.h"

@interface ViewController ()<GCDWebUploaderDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) GCDWebUploader *uploader;
@property (nonatomic, weak)   UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
	GCDWebUploader *uploader = [[GCDWebUploader alloc] initWithUploadDirectory:documentsPath];
	uploader.delegate = self;
	uploader.allowHiddenItems = YES;
	self.uploader = uploader;
	if ([uploader startWithPort:2121 bonjourName:nil]) {
//		_label.text = [NSString stringWithFormat:NSLocalizedString(@"GCDWebServer running locally on server %@", nil),  _webServer.serverURL.absoluteString];
		NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"GCDWebServer running locally on server %@", nil), uploader.serverURL.absoluteString];
		NSLog(@"%@", msg);
	} else {
		NSString *msg = NSLocalizedString(@"GCDWebServer not running!", nil);
		NSLog(@"%@", msg);
	}
	
	[self setupViews];
	//初始化文件列表
	NSError *error = nil;
	NSFileManager *fm = [NSFileManager defaultManager];
	NSArray *files = [fm contentsOfDirectoryAtPath:uploader.uploadDirectory error:&error];
	
	NSMutableArray *fileList = [NSMutableArray array];
	for (NSString *fileName in files) {
		NSString *filePath = [uploader.uploadDirectory stringByAppendingPathComponent:fileName];
		NSDictionary *filesAttr = [fm attributesOfItemAtPath:filePath error:nil];
		
		CGFloat fileSize = [filesAttr[NSFileSize] floatValue];
		NSString *fileDetail = @"";
//		if (fileSize < 1024) {
//			fileDetail = [NSString stringWithFormat:@"%.1fB", fileSize];
//		} else if (fileSize >= 1024 && fileSize < 1024 * 1024) {
//			fileDetail = [NSString stringWithFormat:@"%.1fKB", fileSize / 1024.0];
//		} else if (fileSize >= 1024 * 1024) {
//			fileDetail = [NSString stringWithFormat:@"%.1fMB", fileSize / (1024.0 * 1024.0)];
//		}
		fileDetail = [NSString stringWithFormat:@"%@", [self transformedValue:filesAttr[NSFileSize]]];
		fileDetail = [NSString stringWithFormat:@"%@",
					  [NSByteCountFormatter stringFromByteCount:fileSize countStyle:NSByteCountFormatterCountStyleFile]];
		NSDictionary *dic = @{@"title" : fileName, @"detail" : fileDetail};
		
		[fileList addObject:dic];
	}
	self.dataList = [fileList mutableCopy];
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)dealloc {
	[self.uploader stop];
	self.uploader = nil;
}

- (NSString *)transformedValue:(id)value {
	
	double convertedValue = [value doubleValue];
	int multiplyFactor = 0;
	
	NSArray *tokens = [NSArray arrayWithObjects:@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB", @"ZB", @"YB",nil];
	
	while (convertedValue > 1024) {
		convertedValue /= 1024;
		multiplyFactor++;
	}
	
	return [NSString stringWithFormat:@"%4.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
}

/**
 * 初始化控件
 */
- (void)setupViews {
	UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
	tableView.delegate = self;
	tableView.dataSource = self;
	[self.view addSubview:tableView];
	self.tableView = tableView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([UITableViewCell class])];
	}
	
	NSDictionary *dic = [self.dataList objectAtIndex:indexPath.row];
	cell.textLabel.text = dic[@"title"];
	cell.detailTextLabel.text = dic[@"detail"];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - GCDWebUploaderDelegate
- (void)webUploader:(GCDWebUploader*)uploader didUploadFileAtPath:(NSString*)path {
	NSLog(@"[UPLOAD] %@", path);
	
	NSError *error = nil;
	NSFileManager *fm = [NSFileManager defaultManager];
	NSArray *files = [fm contentsOfDirectoryAtPath:uploader.uploadDirectory error:&error];
	
	NSMutableArray *fileList = [NSMutableArray array];
	for (NSString *fileName in files) {
		NSString *filePath = [uploader.uploadDirectory stringByAppendingPathComponent:fileName];
		NSDictionary *filesAttr = [fm attributesOfItemAtPath:filePath error:nil];
		
		CGFloat fileSize = [filesAttr[NSFileSize] floatValue];
		NSString *fileDetail = @"";
		if (fileSize < 1024) {
			fileDetail = [NSString stringWithFormat:@"%.1fB", fileSize];
		} else if (fileSize >= 1024 && fileSize < 1024 * 1024) {
			fileDetail = [NSString stringWithFormat:@"%.1fKB", fileSize / 1024.0];
		} else if (fileSize >= 1024 * 1024) {
			fileDetail = [NSString stringWithFormat:@"%.1fMB", fileSize / (1024.0 * 1024.0)];
		}
		NSDictionary *dic = @{@"title" : fileName, @"detail" : fileDetail};
		
		[fileList addObject:dic];
	}
	self.dataList = [fileList mutableCopy];
	[self.tableView reloadData];
	
	NSLog(@"%@", files);
}

- (void)webUploader:(GCDWebUploader*)uploader didMoveItemFromPath:(NSString*)fromPath toPath:(NSString*)toPath {
	NSLog(@"[MOVE] %@ -> %@", fromPath, toPath);
}

- (void)webUploader:(GCDWebUploader*)uploader didDeleteItemAtPath:(NSString*)path {
	NSLog(@"[DELETE] %@", path);
}

- (void)webUploader:(GCDWebUploader*)uploader didCreateDirectoryAtPath:(NSString*)path {
	NSLog(@"[CREATE] %@", path);
}

#pragma mark - lazyload
- (NSMutableArray *)dataList {
	if (_dataList == nil) {
		_dataList = [NSMutableArray array];
	}
	return _dataList;
}


@end
