//
//  SecondTableViewController.h
//  iBeacondDev
//
//  Created by mac on 28.07.2014.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IsaaCloudConnector.h"
//#import "BeaconManager.h"
#import "ICNotification.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "ESTBeaconManager.h"
#import "ESTBeaconRegion.h"



@interface SecondTableViewController : UITableViewController<ICCLoginDelegate, ICCRegistrationDelegate, ICCAdminTokenDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    NSMutableArray *nameArray;
    
}


@property (strong) NSMutableArray *nameArray;




@end
