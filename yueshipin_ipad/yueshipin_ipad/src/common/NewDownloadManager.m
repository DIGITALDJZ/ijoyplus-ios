//
//  DownloadManager.m
//  yueshipin
//
//  Created by joyplus1 on 13-1-31.
//  Copyright (c) 2013年 joyplus. All rights reserved.
//

#import "NewDownloadManager.h"
#import "DownloadItem.h"
#import "CMConstants.h"
#import "AppDelegate.h"
#import "DownloadUrlFinder.h"

@interface NewDownloadManager () 
@property (nonatomic, strong)DownloadItem *downloadingItem;
@property (nonatomic, strong)AFDownloadRequestOperation *downloadingOperation;
@property (nonatomic)float previousProgress;
@end

@implementation NewDownloadManager
@synthesize downloadingItem;
@synthesize downloadingOperation;
@synthesize delegate, subdelegate;
@synthesize previousProgress;

- (void)startDownloadingThreads
{
    [self startDownloadingThread:[AppDelegate instance].downloadItems type:@"start"];
    [self startDownloadingThread:[AppDelegate instance].subdownloadItems type:@"start"];
    [self startDownloadingThread:[AppDelegate instance].downloadItems type:@"waiting"];
    [self startDownloadingThread:[AppDelegate instance].subdownloadItems type:@"waiting"];
}

- (void)startDownloadingThread:(NSArray *)allItem type:(NSString *)type
{
    if([AppDelegate instance].currentDownloadingNum < MAX_DOWNLOADING_THREADS){
        for (DownloadItem *item in allItem) {
            if([item.downloadStatus isEqualToString:type]){
                if (item.url) {
                    [AppDelegate instance].currentDownloadingNum++;
                    item.downloadStatus = @"start";
                    [item save];
                    NSURL *url = [NSURL URLWithString:item.url];
                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
                    
                    NSArray  *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDir = [documentPaths objectAtIndex:0];
                    NSString *filePath;
                    if (item.type == 1) {
                        filePath = [NSString stringWithFormat:@"%@/%@.mp4", documentsDir, item.itemId];
                    } else {
                        filePath = [NSString stringWithFormat:@"%@/%@_%@.mp4", documentsDir, item.itemId, ((SubdownloadItem *)item).subitemId];
                    }
                    downloadingOperation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:filePath shouldResume:YES];
                    downloadingOperation.downloadingDelegate = delegate == nil ? self : delegate;
                    downloadingOperation.subdownloadingDelegate = subdelegate == nil ? self : subdelegate;
                    downloadingOperation.operationId = item.itemId;
                    if(item.type == 1){
                        downloadingOperation.suboperationId = @"";
                    } else {
                        downloadingOperation.suboperationId = ((SubdownloadItem *)item).subitemId;
                    }
                    
                    [downloadingOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"Successfully downloaded file to %@", filePath);
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error: %@", error);
                        [operation cancel];
                    }];
                    [downloadingOperation setProgressiveDownloadProgressBlock:^(NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
                    }];
                    previousProgress = 0;
                    [downloadingOperation start];
                } else {
                    if (![item.downloadStatus isEqualToString:@"error"]) {
                        DownloadUrlFinder *finder = [[DownloadUrlFinder alloc]init];
                        finder.item = item;
                        [finder setupWorkingUrl];
                    }
                }
                break;
            }
        }
    }
}

- (void)setDelegate:(id<DownloadingDelegate>)newdelegate
{
    delegate = newdelegate;
    downloadingOperation.downloadingDelegate = newdelegate;
}

- (void)setSubdelegate:(id<SubdownloadingDelegate>)newdelegate
{
    subdelegate = newdelegate;
    downloadingOperation.subdownloadingDelegate = newdelegate;
}

- (void)downloadFailure:(NSString *)operationId error:(NSError *)error
{
    [AppDelegate instance].currentDownloadingNum--;
    if([AppDelegate instance].currentDownloadingNum < 0){
        [AppDelegate instance].currentDownloadingNum = 0;
    }
}

- (void)downloadSuccess:(NSString *)operationId
{
    downloadingItem.downloadStatus = @"done";
    downloadingItem.percentage = 100;
    [downloadingOperation pause];
    [downloadingOperation cancel];
    [downloadingItem save];
}

- (void)updateProgress:(NSString *)operationId progress:(float)progress
{
    if (progress * 100 - previousProgress * 100 > 10) {
        NSLog(@"percent in downloadmanager= %f", progress);
        previousProgress = progress;
        downloadingItem.percentage = progress;
        [downloadingItem save];
    }
}

- (void)downloadFailure:(NSString *)operationId suboperationId:(NSString *)suboperationId error:(NSError *)error
{
    [self downloadFailure:operationId error:error];
}

- (void)downloadSuccess:(NSString *)operationId suboperationId:(NSString *)suboperationId
{
    [self downloadSuccess:operationId];
}

- (void)updateProgress:(NSString *)operationId  suboperationId:(NSString *)suboperationId progress:(float)progress
{
    [self updateProgress:operationId progress:progress];
}

- (void)stopDownloading
{
    [downloadingOperation pause];
    [downloadingOperation cancel];
}

@end