//
//  MoreListViewController.h
//  yueshipin
//
//  Created by 08 on 12-12-26.
//  Copyright (c) 2012年 joyplus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreListViewController : UITableViewController{
    NSArray *listArr_;
    int type_;
}

@property (nonatomic, strong)NSArray *listArr;
@property (nonatomic, assign)int type;
@end
