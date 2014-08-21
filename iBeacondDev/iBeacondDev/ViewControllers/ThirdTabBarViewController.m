//
//  ThirdTabBarViewController.m
//  iBeacondDev
//
//  Created by mac on 28.07.2014.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import "ThirdTabBarViewController.h"


@interface ThirdTabBarViewController ()




@end

@implementation ThirdTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[PBPebbleCentral defaultCentral] setDelegate:self];
    
    
    NSLog(@"%@",[[PBPebbleCentral defaultCentral] lastConnectedWatch]);
    NSLog(@"%@",[PBPebbleCentral defaultCentral]);
    
    connectedWatch = [[PBPebbleCentral defaultCentral] lastConnectedWatch];
    NSLog(@"Last connected watch: %@", connectedWatch);
    
   
    [connectedWatch appMessagesLaunch:^(PBWatch *watch, NSError *error) {
        if (!error) {
            NSLog(@"Successfully launched app.");
        }
        else {
            NSLog(@"Error launching app - Error: %@", error);
        }
    }
     ];
    
    
    [connectedWatch appMessagesAddReceiveUpdateHandler:^BOOL(PBWatch *watch, NSDictionary *update) {
        NSLog(@"Received message: %@", update);
        return YES;
    }];
    
    
  //  NSUUID *uuid = [[NSUUID alloc]initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D" ];
  //  self.region = [[ESTBeaconRegion alloc] initWithProximityUUID:uuid
                                                     // identifier:@"EstimoteSampleRegion"];
   
    
    

}


- (void)setTargetWatch:(PBWatch*)watch {
    _targetWatch = watch;
    
    // NOTE:
    // For demonstration purposes, we start communicating with the watch immediately upon connection,
    // because we are calling -appMessagesGetIsSupported: here, which implicitely opens the communication session.
    // Real world apps should communicate only if the user is actively using the app, because there
    // is one communication session that is shared between all 3rd party iOS apps.
    
    // Test if the Pebble's firmware supports AppMessages / Weather:
    [watch appMessagesGetIsSupported:^(PBWatch *watch, BOOL isAppMessagesSupported) {
        if (isAppMessagesSupported) {
            // Configure our communications channel to target the weather app:
            // See demos/feature_app_messages/weather.c in the native watch app SDK for the same definition on the watch's end:
            uint8_t bytes[] = {0x28, 0xAF, 0x3D, 0xC7, 0xE4, 0x0D, 0x49, 0x0F, 0xBE, 0xF2, 0x29, 0x54, 0x8C, 0x8B, 0x06, 0x00};
            NSData *uuid = [NSData dataWithBytes:bytes length:sizeof(bytes)];
            [[PBPebbleCentral defaultCentral] setAppUUID:uuid];
            
            NSString *message = [NSString stringWithFormat:@"Yay! %@ supports AppMessages :D", [watch name]];
            [[[UIAlertView alloc] initWithTitle:@"Connected!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        } else {
            
            NSString *message = [NSString stringWithFormat:@"Blegh... %@ does NOT support AppMessages :'(", [watch name]];
            [[[UIAlertView alloc] initWithTitle:@"Connected..." message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}


- (void)pebbleCentral:(PBPebbleCentral*)central watchDidConnect:(PBWatch*)watch isNew:(BOOL)isNew {
    NSLog(@"Pebble connected: ");
}


-(void)viewWillDisappear:(BOOL)animated
{
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BeaconCellViewTableViewCell *cell = (BeaconCellViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"BeaconCell" forIndexPath:indexPath];
   // ESTBeacon *beacon = [self.beaconsArray objectAtIndex:indexPath.row];
    
        cell.minorTextField.text = [NSString stringWithFormat:@"Minorr: "];
        cell.majorTextField.text = [NSString stringWithFormat:@"Major: "];
        cell.uuidTableView.text = [NSString stringWithFormat:@"MacAddress: "];
        cell.rssiTextField.text = [NSString stringWithFormat:@"RSSI: "];

    NSLog(@"%@",[NSString stringWithFormat:@"RSSI: "]);
    
    
    return cell;
}





///////////////////////////////////////////////////////////////////////////////
/////////////
/////////////////////////////////////////




-(void)showNotification{
    
    UILocalNotification* localNotification = [[UILocalNotification alloc]init];
    localNotification.fireDate = [NSDate date];
    localNotification.alertBody = @"Your alert message";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.soundName = (UILocalNotificationDefaultSoundName);
    localNotification.applicationIconBadgeNumber = 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}



- (IBAction)startMonitoringButton:(id)sender {
    
    
    
    
}

- (IBAction)stopMonitoringButton:(id)sender {
    
   
  
}

- (IBAction)logoutButton:(id)sender {
    
    
}
@end
