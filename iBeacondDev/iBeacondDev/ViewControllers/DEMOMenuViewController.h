//
//  DEMOMenuViewController.h
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "IsaaCloudConnector.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "UserData.h"

@interface DEMOMenuViewController : UITableViewController<ICCLoginDelegate, ICCRegistrationDelegate, ICCAdminTokenDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    IsaaCloudConnector *icc;
    CLLocationManager *_locationManager;
    NSUUID *_uuid;
    NSNumber *_power;
    CLBeaconRegion *region;
    CBPeripheralManager *_peripheralManager;
    NSMutableArray *beaconsArray;
    
    NSString *beaconuuid;
    CLBeacon *beacon;
    
    NSString *connectedToBeacon;
    NSString *isInRegion;
    NSNumber *beaconMajor ;
    NSNumber *beaconMinor ;

    
    NSDictionary* userformData;
    NSArray *nameArray;
    NSArray *pomieszczeniaArray;
    
    NSNumber *idpomieszczenia;
    
    UILabel *label2;
    UILabel *label;
    UserData  *userData;

    BOOL endThread;
    BOOL isForeground;
    NSTimer *timer;
    
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
