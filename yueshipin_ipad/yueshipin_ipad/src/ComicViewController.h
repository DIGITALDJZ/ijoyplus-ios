//
//  HomeViewController.h
//  yueshipin_ipad
//
//  Created by joyplus1 on 12-11-20.
//  Copyright (c) 2012年 joyplus. All rights reserved.
//

#import "CommonHeader.h"
#import "MenuViewController.h"

@interface ComicViewController : SlideBaseViewController<UITableViewDataSource, UITableViewDelegate, MNMBottomPullToRefreshManagerClient, EGORefreshTableHeaderDelegate, UIScrollViewDelegate>

- (id)initWithFrame:(CGRect)frame;

@end
