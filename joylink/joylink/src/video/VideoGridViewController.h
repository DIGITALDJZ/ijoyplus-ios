//
//  GroupImageViewController.h
//  yuexiangjia
//
//  Created by joyplus1 on 13-1-21.
//  Copyright (c) 2013年 joyplus. All rights reserved.
//

#import "BaseLocalViewController.h"
#import "HomeViewController.h"
@interface VideoGridViewController : BaseLocalViewController
@property (nonatomic, weak)id<HomeViewControllerDelegate>homeDelegate;
@end
