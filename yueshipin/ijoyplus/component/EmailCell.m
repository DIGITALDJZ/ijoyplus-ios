//
//  EmailCell.m
//  ijoyplus
//
//  Created by joyplus1 on 12-9-18.
//  Copyright (c) 2012年 joyplus. All rights reserved.
//

#import "EmailCell.h"

@implementation EmailCell
@synthesize titleLabel;
@synthesize subtitleImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
