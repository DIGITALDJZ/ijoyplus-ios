//
//  FriendPlayRootViewController.m
//  ijoyplus
//
//  Created by joyplus1 on 12-9-12.
//  Copyright (c) 2012年 joyplus. All rights reserved.
//

#import "MyLocalPlayRootViewController.h"
#import "MyLocalPlayViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AnimationFactory.h"
#import "CustomBackButton.h"
#import "CustomBackButtonHolder.h"
#import "PostViewController.h"
#import "AppDelegate.h"
#import "UIUtility.h"
#import "CMConstants.h"
#import "StringUtility.h"
#import "AFServiceAPIClient.h"
#import "ServiceConstants.h"
#import "RecommandViewController.h"

@interface MyLocalPlayRootViewController ()

@end

@implementation MyLocalPlayRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)initViewController
{
    currentViewController = [[MyLocalPlayViewController alloc]initWithNibName:@"MyLocalPlayViewController" bundle:nil];
    ((FriendLocalPlayViewController *)currentViewController).programId = self.programId;
//    previousViewController = [[DramaPlayViewController alloc]initWithNibName:@"DramaPlayViewController" bundle:nil];
//    nextViewController = [[DramaPlayViewController alloc]initWithNibName:@"DramaPlayViewController" bundle:nil];
    [self addChildViewController:currentViewController];
    currentViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TAB_BAR_HEIGHT);
    [self.view addSubview:currentViewController.view];
}

@end
