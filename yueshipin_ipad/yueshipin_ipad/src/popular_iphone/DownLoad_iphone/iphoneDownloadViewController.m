//
//  IphoneDownloadViewController.m
//  yueshipin
//
//  Created by 08 on 13-1-21.
//  Copyright (c) 2013年 joyplus. All rights reserved.
//

#import "IphoneDownloadViewController.h"
#import "UIImageView+WebCache.h"
#import "DownloadItem.h"
#import "DownLoadManager.h"
#import "SegmentUrl.h"
#import "IphoneSubdownloadViewController.h"
#import "AppDelegate.h"
#import "IphoneAVPlayerViewController.h"
#import "Reachability.h"
#import "CMConstants.h"
@interface IphoneDownloadViewController ()

@end

@implementation IphoneDownloadViewController
@synthesize editButtonItem = editButtonItem_;
@synthesize doneButtonItem = doneButtonItem_;
@synthesize itemArr = itemArr_;
@synthesize progressArr = progressArr_;
@synthesize diskUsedProgress = diskUsedProgress_;
@synthesize progressLabelArr = progressLabelArr_;
@synthesize downLoadManager = downLoadManager_;
@synthesize statusImgArr = statusImgArr_;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"视频缓存";
    UIImageView *backGround = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_common.png"]];
    backGround.frame = CGRectMake(0, 0, 320, kFullWindowHeight);
    [self.view addSubview:backGround];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 40, 30);
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setImage:[UIImage imageNamed:@"top_return_common.png"] forState:UIControlStateNormal];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton addTarget:self action:@selector(editPressed:) forControlEvents:UIControlEventTouchUpInside];
    editButton.frame = CGRectMake(0, 0, 37, 30);
    [editButton setImage:[UIImage imageNamed:@"download_edit.png"] forState:UIControlStateNormal];
    [editButton setImage:[UIImage imageNamed:@"download_edit_s.png"] forState:UIControlStateHighlighted];
    [editButton setTitle:@"Edit" forState:UIControlStateNormal];
    editButtonItem_ = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    self.navigationItem.rightBarButtonItem = editButtonItem_;
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton addTarget:self action:@selector(donePressed:) forControlEvents:UIControlEventTouchUpInside];
     doneButton.frame = CGRectMake(0, 0, 37, 30);
    [doneButton setImage:[UIImage imageNamed:@"download_done.png"] forState:UIControlStateNormal];
    [doneButton setImage:[UIImage imageNamed:@"download_done_s.png"] forState:UIControlStateHighlighted];
    [doneButton setTitle:@"done" forState:UIControlStateNormal];
    doneButtonItem_ = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    itemArr_ = [NSMutableArray arrayWithArray:[DownloadItem allObjects]];
    progressArr_ = [NSMutableArray arrayWithCapacity:5];
    progressLabelArr_ = [NSMutableArray arrayWithCapacity:5];
    statusImgArr_ = [NSMutableArray arrayWithCapacity:5];
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:CGRectMake(0, 0, 320, kCurrentWindowHeight-30)];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:gmGridView];
    gMGridView_ = gmGridView;
   
    NSInteger spacing = 5;
    gMGridView_.style = GMGridViewStyleSwap;
    gMGridView_.itemSpacing = spacing;
    gMGridView_.minEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    gMGridView_.centerGrid = NO;
    gMGridView_.actionDelegate = self;
    gMGridView_.dataSource = self;
    gMGridView_.mainSuperView = self.view;
    
    UIImageView *diskView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab2_download_3.png"]];
    diskView.frame = CGRectMake(0, kCurrentWindowHeight-74, 320, 30);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(66, 9, 42, 13)];
    label.text = @"存储容量";
    label.textColor = [UIColor colorWithRed:88/255 green:87/255 blue:87/255 alpha:1];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:9];
    [diskView addSubview:label];
    
    float percent = [self getFreeDiskspacePercent];
    UIImageView *diskFrame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab2_download_2.png"]];
    diskFrame.frame = CGRectMake(8, 6, 302, 18);
    [diskView addSubview:diskFrame];
    
    diskUsedProgress_ = [[DDProgressView alloc] initWithFrame:CGRectMake(7, 4, 306, 27)];
    diskUsedProgress_.progress = percent;
    diskUsedProgress_.innerColor = [UIColor colorWithRed:100/255.0 green:165/255.0 blue:248/255.0 alpha:1];
    diskUsedProgress_.outerColor = [UIColor clearColor];
    
    UILabel *spaceInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 200, 10)];
    spaceInfoLabel.text = [NSString stringWithFormat:@"总空间:%0.2fGB/剩余%0.2fGB",totalSpace_,totalFreeSpace_];
    spaceInfoLabel.textAlignment = NSTextAlignmentCenter;
    spaceInfoLabel.backgroundColor = [UIColor clearColor];
    spaceInfoLabel.font = [UIFont systemFontOfSize:8];
    spaceInfoLabel.textColor = [UIColor whiteColor];
    [diskUsedProgress_ addSubview:spaceInfoLabel];
    
    
    
    [diskView addSubview:diskUsedProgress_];
    
    [self.view addSubview:diskView];
    
    downLoadManager_ = [AppDelegate instance].downLoadManager;
    downLoadManager_.downLoadMGdelegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataSource) name:@"DELETE_ALL_SUBITEMS_MSG" object:nil];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];

}

- (void)viewWillAppear:(BOOL)animated{
    //重新将downLoadManager的代理指向self;
  downLoadManager_.downLoadMGdelegate = self;
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
[[UIApplication sharedApplication] setIdleTimerDisabled: NO];
}
-(void)initData{
    progressArr_ = [NSMutableArray arrayWithCapacity:5];
    progressLabelArr_ = [NSMutableArray arrayWithCapacity:5];
    statusImgArr_ = [NSMutableArray arrayWithCapacity:5];
    itemArr_ = [NSMutableArray arrayWithArray:[DownloadItem allObjects]];
}
-(void)reloadDataSource{
    [self initData];
    [gMGridView_ reloadData];
}
-(float)getFreeDiskspacePercent{

    NSError *error = nil;
     
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
   
    if (dictionary) {
        
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        
        totalSpace_ = [fileSystemSizeInBytes floatValue]/1024.0f/1024.0f/1024.0f;
        
        totalFreeSpace_ = [freeFileSystemSizeInBytes floatValue]/1024.0f/1024.0f/1024.0f;
    }
    float percent = (totalSpace_-totalFreeSpace_)/totalSpace_;
    
    return percent;
}
-(void)downloadBeginwithId:(NSString *)itemId inClass:(NSString *)className{
//    NSString *query = [NSString stringWithFormat:@"WHERE item_id ='%@'",itemId];
//    NSArray *itemArr = [DownloadItem findByCriteria:query];
//    int percet = 0;
//    if ([itemArr count] >0) {
//        percet = ((DownloadItem *)[itemArr objectAtIndex:0]).percentage;
//    }
    if ([className isEqualToString:@"IphoneDownloadViewController"]){
        [self reloadDataSource];
//        for (UILabel *label in progressLabelArr_) {
//            if (label.tag == [itemId intValue]) {           
//                label.text = [NSString stringWithFormat:@"已下载:%i%%",percet];
//                break;
//            
//        }   
//      }
//        
//    for (UIImageView *imgV in statusImgArr_) {
//        if (imgV.tag == [itemId intValue]) {
//            imgV.image = [UIImage imageNamed:@"download_loading.png"];
//            break;
//        }
//    }
//    
//    for (UIProgressView *proV in progressArr_) {
//        if (proV.tag == [itemId intValue]) {
//            proV.progress = percet/100.0;
//            break;
//        }
//    }

   }

}
- (void)reFreshProgress:(double)progress withId:(NSString *)itemId inClass:(NSString *)className{
    if ([className isEqualToString:@"IphoneDownloadViewController"]) {
        float value = (float)progress;
        for (UIProgressView *progress in progressArr_) {
            if (progress.tag == [itemId intValue]) {
                [progress setProgress:value];
                break;
            }
        }
        int progressValue = (int)(100*value);
        for (UILabel *label in progressLabelArr_) {
            if (label.tag == [itemId intValue]) {
                if (progressValue == 100) {
                    //label.text = [NSString stringWithFormat:@"下载完成"];
                }
                else{
                    label.text = [NSString stringWithFormat:@"已下载:%i%%",progressValue];
                }
                break;
            }
        }
        
    }
}

-(void)downloadFinishwithId:(NSString *)itemId inClass:(NSString *)className{
    if ([className isEqualToString:@"IphoneDownloadViewController"]){
    
        [self reloadDataSource];
    }

}

- (void)downloadFailedwithId:(NSString *)itemId inClass:(NSString *)className{
    if ([className isEqualToString:@"IphoneDownloadViewController"]){
         [self reloadDataSource];
    }
}
-(void)downloadUrlTnvalidWithId:(NSString *)itemId inClass:(NSString *)className{

    if ([className isEqualToString:@"IphoneDownloadViewController"]){
        [self reloadDataSource];
    }
}
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)editPressed:(id)sender{
   gMGridView_.editing = YES;
    self.navigationItem.rightBarButtonItem = doneButtonItem_;
}

-(void)donePressed:(id)sender{
    gMGridView_.editing = NO;
   self.navigationItem.rightBarButtonItem = editButtonItem_;
}

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView{
    return [itemArr_ count];
}

- (CGSize)sizeForItemsInGMGridView:(GMGridView *)gridView{
    return CGSizeMake(100, 140);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index{
    DownloadItem *downloadItem = [itemArr_ objectAtIndex:index];
    CGSize size = [self sizeForItemsInGMGridView:gridView];
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    if (!cell) {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-3, -3);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        view.backgroundColor = [UIColor clearColor];
        cell.contentView = view;
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UIImageView *frame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab2_detailed_picture_bg"]];
     frame.frame = CGRectMake(15, 15, 71, 104);
    [cell.contentView addSubview:frame];
        
    UIImageView *contentImage = [[UIImageView alloc]initWithFrame:CGRectMake(17, 17, 67, 99)];
    [contentImage setImageWithURL:[NSURL URLWithString:downloadItem.imageUrl] ];
    [cell.contentView addSubview:contentImage];
    
    UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(17, 123, 67, 15)];
    nameLbl.font = [UIFont systemFontOfSize:13];
    nameLbl.backgroundColor = [UIColor clearColor];
    nameLbl.text = downloadItem.name;
    nameLbl.textColor = [UIColor blackColor];
    nameLbl.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:nameLbl];
    
    if(downloadItem.type == 1){
        UILabel *labelDown = [[UILabel alloc] initWithFrame:CGRectMake(17, 101, 67, 15)];
        labelDown.textColor = [UIColor whiteColor];
        labelDown.backgroundColor = [UIColor blackColor];
        labelDown.alpha = 0.6;
        labelDown.textAlignment = NSTextAlignmentCenter;
        labelDown.font = [UIFont systemFontOfSize:10];
        
        
        UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 16, 67, 15)];
        progressLabel.textColor = [UIColor whiteColor];
        progressLabel.tag = [downloadItem.itemId intValue];
        progressLabel.textAlignment = NSTextAlignmentCenter;
        progressLabel.backgroundColor = [UIColor blackColor];
        progressLabel.alpha = 0.6;
        progressLabel.font = [UIFont systemFontOfSize:10];
        
        [progressLabelArr_ addObject:progressLabel];
      
        
        UIImageView *statusImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 44, 44)];
        statusImg.tag = [downloadItem.itemId intValue];
        statusImg.center = CGPointMake(cell.contentView.center.x, cell.contentView.center.y-10);
        [statusImgArr_ addObject:statusImg];
        [cell.contentView addSubview:statusImg];
        
        UIProgressView *progressView = nil;
        if (![downloadItem.downloadStatus isEqualToString:@"finish"]) {
            
            progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
            progressView.frame = CGRectMake(20, 107, 62, 10);
            progressView.tag = [downloadItem.itemId intValue];
            progressView.progress = downloadItem.percentage/100.0;
            progressView.progressTintColor = [UIColor colorWithRed:62/255.0 green:138/255.0 blue:238/255.0 alpha:1];
            [progressArr_ addObject:progressView];
           
        }

        if([downloadItem.downloadStatus isEqualToString:@"loading"]||[downloadItem.downloadStatus isEqualToString:@"fail"]){
            statusImg.image = [UIImage imageNamed:@"download_loading.png"];
            progressLabel.text = [NSString stringWithFormat:@"已下载:%i%%", downloadItem.percentage];
            [cell.contentView addSubview:progressView];
             [cell.contentView addSubview:progressLabel];
        } else if([downloadItem.downloadStatus isEqualToString:@"stop"]){
            statusImg.image = [UIImage imageNamed:@"download_stop.png"];
           
            progressLabel.text = [NSString stringWithFormat:@"下载至:%i%%", downloadItem.percentage];
            labelDown.text = @"暂停";
            [cell.contentView addSubview:labelDown];
            if (downloadItem.percentage > 0) {
                 [cell.contentView addSubview:progressLabel];
            }
        
        } else if([downloadItem.downloadStatus isEqualToString:@"finish"]){
            progressLabel.text = @"";
        } else if([downloadItem.downloadStatus isEqualToString:@"waiting"]){
            statusImg.image = [UIImage imageNamed:@"download_wait.png"];
            progressLabel.text = [NSString stringWithFormat:@"已下载:%i%%", downloadItem.percentage];
            labelDown.text = @"等待下载...";
            [cell.contentView addSubview:labelDown];
            if (downloadItem.percentage > 0) {
                [cell.contentView addSubview:progressLabel];
            }
        
        }
        else if([downloadItem.downloadStatus isEqualToString:@"fail_1011"]){
            labelDown.text =@"下载片源失效";
            [cell.contentView addSubview:labelDown];
          
        }
        
    }
    else{
        NSString *query = [NSString stringWithFormat:@"WHERE item_id ='%@'",downloadItem.itemId];
        NSArray *arr = [SubdownloadItem findByCriteria:query];
        UILabel *labeltotal = [[UILabel alloc] initWithFrame:CGRectMake(17, 97, 67, 20)];
        labeltotal.text = [NSString stringWithFormat:@"共%d集",[arr count]];
        labeltotal.textColor = [UIColor whiteColor];
        labeltotal.textAlignment = NSTextAlignmentCenter;
        labeltotal.backgroundColor = [UIColor blackColor];
        labeltotal.alpha = 0.6;
        labeltotal.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:labeltotal];
       
    
    }
    
    return cell;
}

- (void)GMGridView:(GMGridView *)gridView deleteItemAtIndex:(NSInteger)index
{
    if (index >= [itemArr_ count]) {
        return;
    }
    
    [itemArr_ removeObjectAtIndex:index];
    
    //对于错误信息
    NSError *error;
    // 创建文件管理器
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    //指向文件目录
    NSString *documentsDirectory= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSArray *fileList = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error];
    
    
    DownloadItem *item = [[DownloadItem allObjects] objectAtIndex:index];
    NSString *itemId = item.itemId;
    NSString *subquery = [NSString stringWithFormat:@"WHERE item_id = '%@'",itemId];
    if ([item.downloadType isEqualToString:@"m3u8"]) {   //m3u8 直接删除对应的文件夹
        NSArray *arr = [SegmentUrl findByCriteria:itemId];
        for (SegmentUrl *sg in arr) {
            [sg deleteObject];
        }
        NSString *deletePath = [documentsDirectory stringByAppendingPathComponent:itemId];
        [fileMgr removeItemAtPath:deletePath error:&error];
        [DownLoadManager stop:itemId];
        [DownLoadManager stopAndClear:itemId];
        
    }
    else{
    
        //删除从表的内容
        NSArray *subItems = [SubdownloadItem findByCriteria:subquery];
        for (SubdownloadItem *subItem in subItems) {
            [subItem deleteObject];
            [DownLoadManager stopAndClear:subItem.subitemId];
        }
        //停止该下载线程，并从下载队列中删除
        [DownLoadManager stopAndClear:itemId];
        
        //删除 对应的文件
//        NSString *fileName = [item.itemId stringByAppendingString:@".mp4"];
//        NSString *subfileName = [NSString stringWithFormat:@"%@_",itemId];
        for (NSString *nameStr in fileList) {
            if (/*[nameStr hasPrefix:fileName] || [nameStr hasPrefix:subfileName]||*/[nameStr hasPrefix:itemId]) {
                NSString *deleteFilePath = [documentsDirectory stringByAppendingPathComponent:nameStr];
                [fileMgr removeItemAtPath:deleteFilePath error:&error];
            }
        }

    }
       

    [item deleteObject];
    
    
}

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position{
    if (position >= [itemArr_ count]) {
        return;
    }
    
     DownloadItem *item = [[DownloadItem allObjects] objectAtIndex:position];
    if (item.type == 1) {
        
            if ([item.downloadStatus isEqualToString:@"finish"]) {
           
            //对于错误信息
            NSError *error;
            // 创建文件管理器
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            //指向文件目录
            NSString *documentsDirectory= [NSHomeDirectory()
                                           stringByAppendingPathComponent:@"Documents"];
            NSArray *fileList = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error];
            
            NSString *playPath = nil;
              
            if (![item.downloadType isEqualToString:@"m3u8"]) {
                NSString *fileName = [item.itemId stringByAppendingString:@".mp4"];
                for (NSString *str in fileList) {
                    if ([str isEqualToString:fileName]) {
                        playPath = [documentsDirectory stringByAppendingPathComponent:str];
                        break;
                    }
                }
            }
            else{
                [[AppDelegate instance] startHttpServer];
                NSString *subPath = [NSString stringWithFormat:@"%@_%@",item.itemId,@"1"];
                playPath =[LOCAL_HTTP_SERVER_URL stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/1.m3u8",item.itemId,subPath]];
            }
            
            if (playPath) {                
                IphoneAVPlayerViewController *iphoneAVPlayerViewController = [[IphoneAVPlayerViewController alloc] init];
                iphoneAVPlayerViewController.local_file_path = playPath;
                if ([item.downloadType isEqualToString:@"m3u8"]){
                  iphoneAVPlayerViewController.isM3u8 = YES;
                  iphoneAVPlayerViewController.playDuration = item.duration;
                  iphoneAVPlayerViewController.lastPlayTime = CMTimeMakeWithSeconds(1, NSEC_PER_SEC);
                }
                
                iphoneAVPlayerViewController.islocalFile = YES;
                iphoneAVPlayerViewController.nameStr = item.name;
                [self presentViewController:iphoneAVPlayerViewController animated:YES completion:nil];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"未找到影片" delegate:self
                                                      cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        
       else if ([item.downloadStatus isEqualToString:@"waiting"] || [item.downloadStatus isEqualToString:@"loading"]) {
           Reachability *hostReach = [Reachability reachabilityForInternetConnection];
           if([hostReach currentReachabilityStatus] == NotReachable){
           
               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"网络中断，请检查您的网络。" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
               [alert show];
               return;
           }
               
            item.downloadStatus = @"stop";
          
            [DownLoadManager stop:item.itemId];
            
            [item save];
           
           for (UILabel *label in progressLabelArr_) {
               if (label.tag == [item.itemId intValue]) {
                    label.text =  [NSString stringWithFormat:@"下载至:%i%%", item.percentage];
                   break;
               }
           }
           
           for (UIImageView *imgV in statusImgArr_) {
               if (imgV.tag == [item.itemId intValue]) {
                   imgV.image = [UIImage imageNamed:@"download_stop.png"];
                   break;
               }
           }
           
           for (UIProgressView *progressView in progressArr_) {
               if (progressView.tag == [item.itemId intValue]) {
                   progressView.progress = item.percentage/100.0;
                   break;
               }
           }
           [self initData]; 
          [self reloadDataSource];
        }
       else if ([item.downloadStatus isEqualToString:@"stop"] || [item.downloadStatus isEqualToString:@"fail"]){
           Reachability *hostReach = [Reachability reachabilityForInternetConnection];
           if([hostReach currentReachabilityStatus] == NotReachable){
               
               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"网络中断，请检查您的网络。" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
               [alert show];
               return;
           }
           
           item.downloadStatus = @"waiting";
           [item save];
           for (UILabel *label in progressLabelArr_) {
               if (label.tag == [item.itemId intValue]) {
                   label.text =  [NSString stringWithFormat:@"已下载:%i%%", item.percentage];
                   break;
               }
           }
           
           for (UIImageView *imgV in statusImgArr_) {
               if (imgV.tag == [item.itemId intValue]) {
                   imgV.image = [UIImage imageNamed:@"download_wait.png"];
                   break;
               }
           }
           
           for (UIProgressView *progressView in progressArr_) {
               if (progressView.tag == [item.itemId intValue]) {
                   progressView.progress = item.percentage/100.0;
                   break;
               }
               
           }

           [DownLoadManager continueDownload:item.itemId];
           [self reloadDataSource];
       }
    
    }
    else{
        
        IphoneSubdownloadViewController *subdownloadViewController = [[IphoneSubdownloadViewController alloc] init];
        subdownloadViewController.prodId = item.itemId;
        subdownloadViewController.imageUrl = [NSURL URLWithString:item.imageUrl];
        subdownloadViewController.title = item.name;
        [self.navigationController pushViewController:subdownloadViewController animated:YES];
    
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
