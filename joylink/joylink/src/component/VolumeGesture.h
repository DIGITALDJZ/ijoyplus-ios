//
//  VolumeGesture.h
//  yuexiangjia
//
//  Created by joyplus1 on 13-1-25.
//  Copyright (c) 2013年 joyplus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericBaseViewController.h"
@interface VolumeGesture : UIPanGestureRecognizer

@property (nonatomic, weak)id<VolumeGestureDelegate> delegate;
@end
