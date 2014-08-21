//
//  ThirdTabBarViewController.h
//  iBeacondDev
//
//  Created by mac on 28.07.2014.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IsaaCloudConnector.h"
#import "ICNotification.h"
#import "BeaconCellViewTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import <PebbleKit/PebbleKit.h>




@interface ThirdTabBarViewController : UIViewController<ICCLoginDelegate, ICCRegistrationDelegate, ICCAdminTokenDelegate, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate,PBPebbleCentralDelegate,PBWatchDelegate>{
    
    
    IsaaCloudConnector *icc;
    NSUUID *proximityUUID;
    // NSArray *beaconsList;
   // BOOL endThread;
    //BOOL isForeground;
    PBWatch *_targetWatch;
    PBWatch *connectedWatch;

}
- (IBAction)startMonitoringButton:(id)sender;
- (IBAction)stopMonitoringButton:(id)sender;

@property (strong, nonatomic) IBOutlet UITextView *textField;

@property (strong, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (nonatomic, strong) NSArray *beaconsArray;


- (IBAction)logoutButton:(id)sender;




@end
