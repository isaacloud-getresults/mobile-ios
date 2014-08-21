//
//  BeaconCellViewTableViewCell.h
//  iBeacondDev
//
//  Created by mac on 29.07.2014.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeaconCellViewTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *uuidTableView;
@property (strong, nonatomic) IBOutlet UILabel *majorTextField;
@property (strong, nonatomic) IBOutlet UILabel *minorTextField;
@property (strong, nonatomic) IBOutlet UILabel *rssiTextField;


@end
