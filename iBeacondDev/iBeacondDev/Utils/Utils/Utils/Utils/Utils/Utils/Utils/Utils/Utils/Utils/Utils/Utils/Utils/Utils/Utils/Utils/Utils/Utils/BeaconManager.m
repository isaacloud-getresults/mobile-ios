//
//  BeaconManager.m
//  iBeacondDev
//
//  Created by Adam on 29/05/14.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import "BeaconManager.h"

@implementation BeaconManager

// B9407F30-F5F8-466E-AFF9-25556B57FE6D <- estimote
// f7826da6-4fa2-4e98-8024-bc5b71e0893e <- kontkat io

+(id)sharedInstance
{
    static BeaconManager *sharedInstance = nil;
    @synchronized(self){
        if(sharedInstance == nil)
        {
            sharedInstance = [[super alloc] init];
        }
    }
    return  sharedInstance;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        delegates = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addDelegete:(id<BeaconManagerDelegate>)delegate
{
    [delegates addObject:delegate];
}

-(void)removeDelegete:(id<BeaconManagerDelegate>)delegate
{
    [delegates removeObject:delegate];
}

-(void)createRegionForLocation:(DBLocation*)location
{
    if(self.locationManager != nil && self.beaconRegion != nil)
    {
        [self stopMonitoringRegion];
        [self.locationManager stopRangingBeaconsInRegion: self.beaconRegion];
        [self.locationManager setDelegate:nil];
    }
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString: location.proximityUUID];
    self.locationManager = [[CLLocationManager alloc] init];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:[NSString stringWithFormat: @"pl.sointeractive.iBeacondDev.%@",location.name]];
    self.beaconRegion.notifyOnEntry = YES;
    self.beaconRegion.notifyOnExit = YES;
    [self.locationManager setDelegate:self];
    [self startMonitoringRegion];
}

-(void)startMonitoringRegion
{
    if(self.beaconRegion != nil)
    {
        [self.locationManager startMonitoringForRegion: self.beaconRegion];
        for(id<BeaconManagerDelegate> del in delegates)
            if([del respondsToSelector:@selector(startMonitoringRegion:)])
                [del startMonitoringRegion:self.beaconRegion];
    }
}

-(void)stopMonitoringRegion
{
    if(self.beaconRegion != nil)
    {
        [self.locationManager stopMonitoringForRegion: self.beaconRegion];
        for(id<BeaconManagerDelegate> del in delegates)
            if([del respondsToSelector:@selector(stopMonitoringRegion:)])
                [del stopMonitoringRegion:self.beaconRegion];
    }
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    for(id<BeaconManagerDelegate> del in delegates)
        if([del respondsToSelector:@selector(enterRegion:)])
            [del enterRegion:self.beaconRegion];
    [self.locationManager startRangingBeaconsInRegion: self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    for(id<BeaconManagerDelegate> del in delegates)
        if([del respondsToSelector:@selector(exitRegion:)])
            [del exitRegion:self.beaconRegion];
    [self.locationManager stopRangingBeaconsInRegion: self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    [self.locationManager requestStateForRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    for(id<BeaconManagerDelegate> del in delegates)
        if([del respondsToSelector:@selector(beaconsInRegion:)])
            [del beaconsInRegion:beacons];
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    for(id<BeaconManagerDelegate> del in delegates)
        if([del respondsToSelector:@selector(stopMonitoringRegion:)])
            [del stopMonitoringRegion:self.beaconRegion];
}

-(void)checkRegionStatus
{
    if(self.beaconRegion != nil)
    {
        [self.locationManager requestStateForRegion:self.beaconRegion];
    }
}

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSString *status = nil;
    if(state == CLRegionStateInside)
    {
        [self.locationManager startRangingBeaconsInRegion: self.beaconRegion];
        status = @"inside";
    }
    else if(state == CLRegionStateOutside)
    {
        status = @"outside";
    }
    else
    {
        status = @"unknown";
    }
    for(id<BeaconManagerDelegate> del in delegates)
        if([del respondsToSelector:@selector(regionStatus:forRegion:)])
            [del regionStatus:status forRegion:self.beaconRegion];
}

-(void)checkLocationServiceStatus
{
    if(alert != nil)
    {
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    }
    if(![CLLocationManager locationServicesEnabled] || ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied))
    {
        NSString *msg = @"Enable location services.";
        alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    NSSet *regions = self.locationManager.monitoredRegions;
    BOOL onList = NO;
    for(CLBeaconRegion *br in regions)
    {
        onList |= [br.identifier isEqualToString:self.beaconRegion.identifier];
    }
    if(!onList)
         [self startMonitoringRegion];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    [self checkLocationServiceStatus];
}

@end
