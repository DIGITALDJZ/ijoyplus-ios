//
//  PlayViewController.h
//  ijoyplus
//
//  Created by joyplus1 on 12-9-11.
//  Copyright (c) 2012年 joyplus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntroductionView.h"
#import "PlayViewController.h"
#import "LoadMoreCell.h"
@interface FriendPlayViewController : PlayViewController{
    NSMutableArray *friendCommentArray;
}

- (CommentCell *)displayFriendCommentCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath commentArray:(NSArray *)dataArray cellIdentifier:(NSString *)cellIdentifier;
- (LoadMoreCell *)displayLoadMoreCell:(UITableView *)tableView;
- (void)postInitialization:(NSDictionary *)result;
@end
