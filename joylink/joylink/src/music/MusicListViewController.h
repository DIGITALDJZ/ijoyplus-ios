//
//  GroupImageViewController.h
//  yuexiangjia
//
//  Created by joyplus1 on 13-1-21.
//  Copyright (c) 2013年 joyplus. All rights reserved.
//

#import "GenericBaseViewController.h"
#import "HomeViewController.h"
@interface MusicListViewController : GenericBaseViewController
@property (nonatomic, weak)id<HomeViewControllerDelegate>homeDelegate;
@end
