//
//  HJNewsViewController.m
//  JustWay
//
//  Created by HeJun on 28/06/2017.
//  Copyright © 2017 HeJun. All rights reserved.
//

#import "HJNewsViewController.h"
#import "HJUploaderServer.h"
#import "HJNewsModel.h"
#import "HJNewsTableViewCell.h"
#import "HJMusicPlayModel.h"

#import "HJMusicPlayViewController.h"

@interface HJNewsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak)	  UITableView	 *tableView;

@property (nonatomic, strong) NSMutableArray<HJNewsModel *> *dataList;
/** 文件存储目录 */
@property (nonatomic, copy)	  NSString		 *fileDir;
/** 服务器监听端口 */
@property (nonatomic, assign) NSUInteger	 serverPort;
/** 服务器监听地址 */
@property (nonatomic, copy)	  NSString		 *serverUrl;

@end

@implementation HJNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.serverPort = 8082;
	
	[self setupViews];
	[self initData];
	[self.tableView reloadData];
	
	[[HJUploaderServer sharedInstance] addObserver:self forKeyPath:@"fileList" options:NSKeyValueObservingOptionNew context:nil];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
	HJLog(@"%s", __func__);
	[[HJUploaderServer sharedInstance] removeObserver:self forKeyPath:@"fileList" context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
	NSMutableArray *fileList = change[NSKeyValueChangeNewKey];
	
//	HJLog(@"%@ : %@", change, fileList);
	self.dataList = [fileList mutableCopy];
	[self.tableView reloadData];
}

/**
 * 初始化数据
 */
- (void)initData {
	[HJUploaderServer sharedInstance].fileDir = self.fileDir;
	[[HJUploaderServer sharedInstance] getFileLists];
	self.dataList = [HJUploaderServer sharedInstance].fileList;
}

/**
 * 初始化控件
 */
- (void)setupViews {
	UIButton *serverButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[serverButton setTitle:@"启动" forState:UIControlStateNormal];
	[serverButton setTitle:@"暂停" forState:UIControlStateSelected];
	[serverButton setTitleColor:HJRGB(4, 164, 255) forState:UIControlStateNormal];
	serverButton.titleLabel.font = [UIFont systemFontOfSize:15];
	CGRect serverButtonRect = [@"启动" boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : serverButton.titleLabel.font} context:nil];
	serverButton.frame = CGRectMake(0, 0, 44, serverButtonRect.size.width);
	[serverButton addTarget:self action:@selector(handleRightButton:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:serverButton];
	self.navigationItem.rightBarButtonItem = rightButton;
	
	self.edgesForExtendedLayout = UIRectEdgeTop;
	UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HJNavigationStatusHeight, self.view.frame.size.width, self.view.frame.size.height - HJTabbarHeight - HJNavigationStatusHeight) style:UITableViewStylePlain];
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.rowHeight = 55.0f;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:tableView];
	self.tableView = tableView;
}

#pragma mark - user event
/**
 * 点击启动服务器按钮
 */
- (void)handleRightButton:(UIButton *)button {
	HJLog(@"启动服务器");
	if (!button.isSelected) {
		//启动
		HJWeakSelf;
		[[HJUploaderServer sharedInstance] startWithDir:self.fileDir port:self.serverPort block:^(NSObject *obj) {
			if ([obj isKindOfClass:[NSString class]]) {
				NSString *uploadLink = (NSString *)obj;
				[weakSelf setUploadLink:uploadLink];
			} else {
				HJLog(@"启动失败");
			}
		}];
		[UIApplication sharedApplication].idleTimerDisabled = YES;
	} else {
		//暂停
		[[HJUploaderServer sharedInstance] stop];
		self.title = @"动态";
		[UIApplication sharedApplication].idleTimerDisabled = NO;
	}
	button.selected = !button.isSelected;
}

/**
 * 设置上传链接
 */
- (void)setUploadLink:(NSString *)link {
	self.serverUrl = link;
	self.title = link;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	HJNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJNewsTableViewCell class])];
	if (cell == nil) {
		cell = [[HJNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([HJNewsTableViewCell class])];
	}
	
	HJNewsModel *model = self.dataList[indexPath.row];
	cell.model = model;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	HJNewsModel *rowModel = self.dataList[indexPath.row];
	
	if ([rowModel.fileName hasSuffix:@".mp3"] || [rowModel.fileName hasSuffix:@".m4a"]) {
		//获取所有音乐文件
		NSMutableArray *musicList = [NSMutableArray array];
		HJMusicPlayModel *selectPlayModel;
		for (HJNewsModel *model in self.dataList) {
			if ([model.fileName hasSuffix:@".mp3"] || [model.fileName hasSuffix:@".m4a"]) {
				NSString *musicPath = [self.fileDir stringByAppendingPathComponent:model.fileName];
				NSArray *suffix = [musicPath componentsSeparatedByString:@"."];
				NSString *lyricPath = [musicPath stringByReplacingOccurrencesOfString:suffix.lastObject withString:@"lrc"];
				NSFileManager *fm = [NSFileManager defaultManager];
				
				HJMusicPlayModel *playModel = [HJMusicPlayModel new];
				playModel.playUrl = [NSURL fileURLWithPath:musicPath];
				playModel.lyricUrl = [fm fileExistsAtPath:lyricPath] ? [NSURL fileURLWithPath:lyricPath] : nil;
				[musicList addObject:playModel];
				
				if (model == rowModel) {
					selectPlayModel = playModel;
				}
			}
		}
		
		HJMusicPlayViewController *mpVc = [HJMusicPlayViewController new];
		mpVc.playModel = selectPlayModel;
		mpVc.musicList = musicList;
		mpVc.title = rowModel.fileName;
		[self.navigationController pushViewController:mpVc animated:YES];
	}
}

#pragma mark - delete action
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	HJNewsModel *model = [self.dataList objectAtIndex:indexPath.row];
	
	[[NSFileManager defaultManager] removeItemAtPath:model.filePath error:nil];
	[self.dataList removeObject:model];
	[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
	return @"删除";
}

#pragma mark - lazyload
- (NSMutableArray *)dataList {
	if (_dataList == nil) {
		_dataList = [NSMutableArray array];
	}
	return _dataList;
}

- (NSString *)fileDir {
	if (_fileDir == nil) {
		_fileDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
	}
	return _fileDir;
}

@end
