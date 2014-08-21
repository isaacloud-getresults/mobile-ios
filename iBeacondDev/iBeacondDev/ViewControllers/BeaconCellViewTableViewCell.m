//
//  BeaconCellViewTableViewCell.m
//  iBeacondDev
//
//  Created by mac on 29.07.2014.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import "BeaconCellViewTableViewCell.h"

@implementation BeaconCellViewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
