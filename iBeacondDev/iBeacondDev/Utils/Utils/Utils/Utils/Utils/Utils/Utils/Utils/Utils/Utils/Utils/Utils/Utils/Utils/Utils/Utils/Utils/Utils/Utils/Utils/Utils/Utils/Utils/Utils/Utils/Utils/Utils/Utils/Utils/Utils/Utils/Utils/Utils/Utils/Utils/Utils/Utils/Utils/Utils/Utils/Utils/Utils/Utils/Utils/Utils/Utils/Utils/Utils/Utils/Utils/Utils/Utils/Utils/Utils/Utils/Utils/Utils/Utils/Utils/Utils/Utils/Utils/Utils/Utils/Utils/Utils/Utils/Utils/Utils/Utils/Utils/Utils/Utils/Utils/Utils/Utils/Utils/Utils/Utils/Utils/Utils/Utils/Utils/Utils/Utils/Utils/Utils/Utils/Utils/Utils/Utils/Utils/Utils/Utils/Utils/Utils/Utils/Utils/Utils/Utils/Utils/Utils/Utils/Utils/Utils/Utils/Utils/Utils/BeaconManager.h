//
//  BeaconManager.h
//  iBeacondDev
//
//  Created by Adam on 29/05/14.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "DBLocation.h"

@protocol BeaconManagerDelegate <NSObject>
@required
-(void)enterRegion:(CLBeaconRegion*)region;
-(void)exitRegion:(CLBeaconRegion*)region;
-(void)beaconsInRegion:(NSArray *)beacons;
-(void)startMonitoringRegion:(CLBeaconRegion*)region;
-(void)stopMonitoringRegion:(CLBeaconRegion*)region;
-(void)regionStatus:(NSString*)status forRegion:(CLBeaconRegion*)region;
@end

@interface BeaconManager : NSObject<CLLocationManagerDelegate>
{
    UIAlertView *alert;
    NSMutableArray *delegates;
}

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;

+(id)sharedInstance;
-(void)startMonitoringRegion;
-(void)stopMonitoringRegion;
-(void)checkLocationServiceStatus;
-(void)checkRegionStatus;
-(void)createRegionForLocation:(DBLocation*)location;
-(void)addDelegete:(id<BeaconManagerDelegate>)delegate;
-(void)removeDelegete:(id<BeaconManagerDelegate>)delegate;

@end
