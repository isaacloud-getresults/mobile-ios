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


@interface FirstTableViewController :  UITableViewController<ICCLoginDelegate, ICCRegistrationDelegate, ICCAdminTokenDelegate, UITableViewDelegate, UITableViewDataSource>{
  
    
    NSArray *nameArray;
    IsaaCloudConnector *icc;
    
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
    
}
-(void)showNotification:(NSString *)text;
-(NSMutableArray*)dajMiTablice:(NSMutableArray *)tablica;
//@property (strong) NSMutableArray *nameArray;
@property (strong,nonatomic) NSMutableArray *beaconsArray;
@property (strong,nonatomic) NSMutableArray *imionaArray;
@property(strong,nonatomic) NSNumber *userUid;

@property (strong, nonatomic) CLBeaconRegion *myBeaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end
