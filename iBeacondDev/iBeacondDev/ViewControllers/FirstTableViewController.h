//
//  FirstTableViewController.h
//  iBeacondDev
//
//  Created by mac on 28.07.2014.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IsaaCloudConnector.h"
#import "ICNotification.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "UserData.h"


@interface FirstTableViewController :  UITableViewController<ICCLoginDelegate, ICCRegistrationDelegate, ICCAdminTokenDelegate, UITableViewDelegate, UITableViewDataSource>{
  
    
    NSArray *nameArray;
    NSArray *pomieszczeniaArray;
    IsaaCloudConnector *icc;
    
    UserData  *userData;
    
    
    CLLocationManager *_locationManager;
    NSUUID *_uuid;
    NSNumber *_power;
    CLBeaconRegion *region;
    CBPeripheralManager *_peripheralManager;
    NSMutableArray *beaconsArray;
    
    CLBeacon *beacon;
    
    NSString *connectedToBeacon;
    NSString *isInRegion;
    NSNumber *beaconMajor ;
    NSNumber *beaconMinor ;
    
    NSString *beaconuuid;
    NSTimer *timer;
    
    BOOL endThread;
    BOOL isForeground;
    
    
    BOOL isPreviousThreadFinished;
    
}

-(void)showNotification:(NSString *)text;
-(void)stopNotificationThread;
-(void)stopRanging;


//@property (strong) NSMutableArray *nameArray;
@property (strong,nonatomic) NSMutableArray *beaconsArray;
@property (strong,nonatomic) NSMutableArray *imionaArray;
@property(strong,nonatomic) NSNumber *userUid;

@property (strong, nonatomic) CLBeaconRegion *myBeaconRegion;
@property (strong, nonatomic) CLLocationManager *_locationManager;

@end
