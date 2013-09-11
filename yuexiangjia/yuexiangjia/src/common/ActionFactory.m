//
//  ActionFactory.m
//  yuexiangjia
//
//  Created by joyplus1 on 13-2-28.
//  Copyright (c) 2013年 joyplus. All rights reserved.
//

#import "ActionFactory.h"
#import "SimpleRemoteAction.h"
#import "ComplexRemoateAction.h"
#import "SendInputMsgAction.h"
#import "SensorTypeAction.h"

@implementation ActionFactory


+ (RemoteAction *) getSimpleActionByEvent:(ControlEvent)event
{
    RemoteAction *remoteAction = [[SimpleRemoteAction alloc]initWithEvent:event];
    return remoteAction;
}

+ (RemoteAction *) getComplexActionByEvent:(ControlEvent)event
{
    RemoteAction *remoteAction = [[ComplexRemoateAction alloc]initWithEvent:event];
    return remoteAction;
}

+ (RemoteAction *) getSendInputMsgAction:(ControlEvent)event
{
    RemoteAction *remoteAction = [[SendInputMsgAction alloc]initWithEvent:event];
    return remoteAction;
}

+ (RemoteAction *) getSensorTypeActionByEventType:(ControlEvent)event
{
    RemoteAction *remoteAction = [[SensorTypeAction alloc]initWithEvent:event];
    return remoteAction;
}

@end
