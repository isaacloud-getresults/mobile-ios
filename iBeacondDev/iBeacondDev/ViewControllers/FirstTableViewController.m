//
//  FirstTableViewController.m
//  iBeacondDev
//
//  Created by mac on 28.07.2014.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import "FirstTableViewController.h"
#import "ProfileViewController.h"


@interface FirstTableViewController ()<CLLocationManagerDelegate,CBPeripheralManagerDelegate>{
    BOOL turnAdvertisingOn;
}
@end

@implementation FirstTableViewController

//@synthesize nameArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   icc = [[IsaaCloudConnector alloc]init ];
    self.userUid = icc.getUserUID;
    
  // nameArray = [[NSMutableArray alloc]initWithArray:[icc Notyficationsfrommy:self.userUid] ];
  //  NSLog(@"%@",nameArray);
    
   // [self showNotification:[nameArray firstObject]];
   // NSLog(@"%@",[icc getInteriorsALL]);
    nameArray = [icc getUsers];
  //  NSLog(@"%@",nameArray);
    
  //  [self.imionaArray dajMiTablice:nameArray];
    
   //NSString *pomieszczenie = [icc getGroupsNameWithID:userID];
    
   beacon = [[CLBeacon alloc] init];
   // [icc getNotifications];
    
    
    connectedToBeacon = @"FALSE";
    isInRegion = @"FALSE";
    
    /*
    connectedToBeacon = [[NSUserDefaults standardUserDefaults]
                                   stringForKey:@"connectedToBeacon"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"FALSE"
                                              forKey:@"connectedToBeacon"];
    [[NSUserDefaults standardUserDefaults] synchronize];
     
     */
    
    [self startRanging];
    
}



-(void)viewDidAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    
    return [nameArray count];
}
/*
-(NSMutableArray*)dajMiTablice:(NSMutableArray *)tablica{
    
    NSMutableArray *arrayImion = [[NSMutableArray alloc]init];
    
    for(int i=0;i<[tablica count];i++)
    {
        [arrayImion addObject:[[tablica objectAtIndex:i]objectForKey:@"firstName"]];
        
    }
    
    
    for(int i=0;i<[arrayImion count];i++)
    {
        NSString * value = [arrayImion objectAtIndex:i];
        if (value == nil || [value isKindOfClass:[NSNull class]]) {
            NSLog(@"wykoanan2");
            [arrayImion setObject:@"No name" atIndexedSubscript:i];
        }
        else{
            NSLog(@"to nie dziala");
        }
        
    }
    
    return arrayImion;
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    
    
    
    //  NSLog(@"%@",[[nameArray objectAtIndex:indexPath.row]objectForKey:@"firstName"]);
    
    NSString *imie;
    NSString *nazwisko;
    
    NSString * value = [[nameArray objectAtIndex:indexPath.row]objectForKey:@"firstName"];
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        
        imie = @"Nemo";
    }
    else{
        imie = value;
    }
    
    NSString * value2 = [[nameArray objectAtIndex:indexPath.row]objectForKey:@"lastName"];
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        nazwisko  = @"Nobody";
    }
    else{
        nazwisko = value2;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",imie,nazwisko];
    
    /*
    NSMutableArray *arrayImion = [[NSMutableArray alloc]init];
    NSLog(@"%ld",(long)indexPath.row);
    for(int i=0;i<[nameArray count];i++)
    {
        [arrayImion addObject:[[nameArray objectAtIndex:i]objectForKey:@"firstName"]];
     
    }
    
    
    for(int i=0;i<[arrayImion count];i++)
    {
        NSString * value = [arrayImion objectAtIndex:i];
        if (value == nil || [value isKindOfClass:[NSNull class]]) {
            NSLog(@"wykoanan2");
            [arrayImion setObject:@"Nemo" atIndexedSubscript:i];
        }
        else{
            NSLog(@"to nie dziala");
        }
        
    }
    
    NSMutableArray *arrayNazwisk = [[NSMutableArray alloc]init];
     NSLog(@"%ld",(long)indexPath.row);
    for(int i=0;i<[nameArray count];i++)
    {
        [arrayNazwisk addObject:[[nameArray objectAtIndex:i]objectForKey:@"lastName"]];
        
    }
    
    
    for(int i=0;i<[arrayNazwisk count];i++)
    {
        NSString * value = [arrayNazwisk objectAtIndex:i];
        if (value == nil || [value isKindOfClass:[NSNull class]]) {
              NSLog(@"wykoanan2");
            [arrayNazwisk setObject:@"Nobody" atIndexedSubscript:i];
        }
        else{
              NSLog(@"to nie dziala");
        }
        
    }
     
     */
   // if ([cell.detailTextLabel.text isEqualToString:@"Pomieszczenie"]) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                
    NSNumber *valueOfCounter = [[NSNumber alloc]init];
    
    // NSLog(@"%@",[userData objectForKey:@"counterValues"]);
    for (int i = 0; [[[nameArray objectAtIndex:indexPath.row]objectForKey:@"counterValues"]count] > i; i++) {
        //  NSLog(@"%@",[[[userData objectForKey:@"counterValues"]objectAtIndex:i]objectForKey:@"counter"]);
        
        if ([[[[[nameArray objectAtIndex:indexPath.row] objectForKey:@"counterValues"]objectAtIndex:i]objectForKey:@"counter"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            valueOfCounter = [[[[nameArray objectAtIndex:indexPath.row] objectForKey:@"counterValues"]objectAtIndex:i]objectForKey:@"value"];
        }
    }
    
  //  NSNumber *userID = [[nameArray objectAtIndex:indexPath.row]objectForKey:@"id"];
    
                           
                           
                           NSString *pomieszczenie = [icc getGroupsNameWithID:valueOfCounter];
                       /*
                           if (pomieszczenie == nil || [pomieszczenie isKindOfClass:[NSNull class]]) {
                               cell.detailTextLabel.text = @"UNKNOWN";
                           }
                           else{
                               cell.detailTextLabel.text = pomieszczenie;
                           }
           
                           */
                           
                           
                           if ([[[nameArray objectAtIndex:indexPath.row]objectForKey:@"custom"]count] != 0 ){
                               
                               //[[userData objectForKey:@"custom"]objectForKey:@"facebookPhoto"];
                              cell.imageView.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:[[[nameArray objectAtIndex:indexPath.row]objectForKey:@"custom"]objectForKey:@"facebookPhoto"]]]];
                               
                           }
                           
   
                           
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                
                if ([tableView indexPathForCell:cell].row == indexPath.row) {
                    
                    cell.detailTextLabel.text = pomieszczenie;
                }
                
                
    
   // cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
            });
                       });
        
   // }
            
            
    
    
    
    return cell;
     
     
   
    
    
     
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Beacon Range
-(void)startRanging{
    
 
    
    if (_locationManager!=nil) {
        if(region){
            region.notifyOnEntry = YES;
            region.notifyOnExit = YES;
            region.notifyEntryStateOnDisplay = YES;
            
            [_locationManager startMonitoringForRegion:region];
            [_locationManager startRangingBeaconsInRegion:region];
            
        }
        else{
            _uuid = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.delegate = self;
            region = [[CLBeaconRegion alloc] initWithProximityUUID:_uuid identifier:@"COM.SELF.ID"];
            if(region){
                region.notifyOnEntry = YES;
                region.notifyOnExit = YES;
                region.notifyEntryStateOnDisplay = YES;
                [_locationManager startMonitoringForRegion:region];
                [_locationManager startRangingBeaconsInRegion:region];
                
            }
        }
    }
    else{
        _uuid = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        region = [[CLBeaconRegion alloc] initWithProximityUUID:_uuid identifier:@"COM.SELF.ID"];
        if(region){
            region.notifyOnEntry = YES;
            region.notifyOnExit = YES;
            region.notifyEntryStateOnDisplay = YES;
            [_locationManager startMonitoringForRegion:region];
           [_locationManager startRangingBeaconsInRegion:region];
            
        }
    }
}



-(void)stopRanging{
    [_locationManager stopRangingBeaconsInRegion:region];
    [_locationManager stopMonitoringForRegion:region];
}

#pragma mark - Beacon broadcast
/*
-(void)initiatePeripheralManagerForBeaconBroadcast{
    if (_peripheralManager) {
       [self advertiseBeacon];
        return;
    }
    
    //This starts a check on the update state delegate to see if bluetooth is powered on or not
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    turnAdvertisingOn = YES;
}

-(void)stopBeaconBroadCast{
    if (_peripheralManager) {
        turnAdvertisingOn = NO;
        [_peripheralManager stopAdvertising];
    }
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    NSLog(@"peripheral %@",peripheral);
    
    //Check if the BLE state was on or not
    if (peripheral.state == CBPeripheralManagerStatePoweredOn && turnAdvertisingOn) {
        [self advertiseBeacon];
    }
}

-(void)advertiseBeacon{
    _uuid = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
    _power = @(broadcastpower);
    CLBeaconRegion *newregion = [[CLBeaconRegion alloc] initWithProximityUUID:_uuid major:10 minor:5 identifier:@"COM.SELF.ID"];
    NSMutableDictionary *peripheralData = [newregion peripheralDataWithMeasuredPower:_power];
    
    NSLog(@"start advertising %@",peripheralData);
    //Advertise the same beacon region and Range the same beacon region
    [_peripheralManager startAdvertising:peripheralData];
    
}

*/




#pragma mark - Location manager beacon region delegate

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    NSLog(@"Enter Region  %@",region);

   //[_locationManager startRangingBeaconsInRegion:region];
    
    
    isInRegion = @"TRUE";
    
   // NSLog(@"%@",[beaconsArray objectAtIndex:2]);
    //NSLog(@"%@",[beaconsArray objectAtIndex:1]);
    
    
    //[self sendLocalNotificationForReqgionConfirmationWithText:@"REGION INSIDE"];
   
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    
    
 
    NSLog(@"Exit Region  %@",region);
    
    
    
    
   // [self sendLocalNotificationForReqgionConfirmationWithText:@"REGION OUTSIDE"];
   // [_locationManager stopRangingBeaconsInRegion:region];
    
  //  CLBeacon *beacon = [[CLBeacon alloc] init];
  //  beacon = [beaconsArray lastObject];
   // NSLog(@"%@",[beaconsArray objectAtIndex:2]);
    // NSLog(@"%@",[beaconsArray objectAtIndex:1]);
  /*
    if ([beacon.minor intValue] == 5) {
        [self showNotificationwychodzi];
    }else if ([beacon.minor intValue] == 4){
        [self showNotificationwychodzizzsalonu];
    }else{
        [self showNotificationnieznana];
    }
    
    */
    
    
    NSString *alertText = [NSString stringWithFormat:@"%@.%@.exit",
                           beaconMajor, beaconMinor];
    NSLog(@"%@",alertText);
    
    [icc sendPlaceEvent:alertText];
    
    connectedToBeacon = @"FALSE";
    isInRegion = @"FALSE";
    /*
    [[NSUserDefaults standardUserDefaults] setObject:@"FALSE"
                                              forKey:@"connectedToBeacon"];
    [[NSUserDefaults standardUserDefaults] synchronize];
     */
}




-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
   
    
    NSLog(@"Monitoring for %@",region);
    
    //[self sendLocalNotificationForReqgionConfirmationWithText:@"MONITORING STARTED"];
    
    
    
}
/*
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    if (state == CLRegionStateInside) {
        [_locationManager startRangingBeaconsInRegion:region];
        NSLog(@"@@@@@ Minor: %@, Major: %@",beacon.minor,beacon.major);
       // [self showNotification];
       // [self sendLocalNotificationForReqgionConfirmationWithText:@"REGION INSIDE"];
        
    }
    else{
        //[[BluetoothManager shared] scan];
     //   [self showNotificationwychodzi];
       // [self sendLocalNotificationForReqgionConfirmationWithText:@"REGION OUTSIDE"];
        [_locationManager stopRangingBeaconsInRegion:region];
        NSLog(@"@@@@@@Minor: %@, Major: %@",beacon.minor,beacon.major);
        
        
    }
    //[_locationManager startRangingBeaconsInRegion:region];
    
}
*/



-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
   
    beacon = [beacons lastObject];
    
    NSString *bMajor = (NSString*)beacon.major;
    NSString *empty = NULL;
    
    
   // NSLog(@"%d",(int)([isInRegion isEqualToString:@"TRUE"]));
    
    if (!(bMajor == empty)  && ([connectedToBeacon isEqualToString:@"FALSE"]) && ([isInRegion isEqualToString:@"TRUE"])) {
        
        beaconMajor = beacon.major;
        beaconMinor = beacon.minor;
        
        NSString *alertText = [NSString stringWithFormat:@"%@.%@",
                               beaconMajor, beaconMinor];
        NSLog(@"%@",alertText);
       [icc sendPlaceEvent:alertText];
        
       // UILocalNotification *notification = [[UILocalNotification alloc] init];
       // notification.alertBody = alertText;
       // notification.soundName = UILocalNotificationDefaultSoundName;
        
       // [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        /*
        [[NSUserDefaults standardUserDefaults] setObject:@"TRUE"
                                                  forKey:@"connectedToBeacon"];
        [[NSUserDefaults standardUserDefaults] synchronize];
         */
        connectedToBeacon=@"TRUE";
        [self showNotification:[nameArray firstObject]];
    
    
    }

     NSLog(@"%@",beacons);

    
    /*
     beacon = [beacons lastObject];
    
    
    if(beacon.minor != NULL && beacon.major != NULL){
        
        NSLog(@"$$ Minor: %@, Major: %@",beacon.minor,beacon.major);
    }
        
    */
    
   // NSLog(@"$$ Minor: %@, Major: %@",beacon.minor,beacon.major);
    //  NSLog(@"%@",beaconsArray);
    
  // NSLog(@"%lu",(unsigned long)[beaconsArray count]);
    

  /*
    NSArray *farBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityFar]];
    if([farBeacons count]){
        NSLog(@"far beacons %@",farBeacons);
           }
    
   
    */
    
}

-(void)showNotification:(NSString *)text{
    
    UILocalNotification* localNotification = [[UILocalNotification alloc]init];
    localNotification.fireDate = [NSDate date];
    localNotification.alertBody = text;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.soundName = (UILocalNotificationDefaultSoundName);
    localNotification.applicationIconBadgeNumber = 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}


-(void)sendLocalNotificationForReqgionConfirmationWithText:(NSString *)text {
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotif.alertBody = [NSString stringWithFormat:NSLocalizedString(@"%@", nil),
                            text];
    localNotif.alertAction = NSLocalizedString(@"View Details", nil);
    
    localNotif.applicationIconBadgeNumber = 1;
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:text forKey:@"KEY"];
    localNotif.userInfo = infoDict;
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification NS_AVAILABLE_IOS(4_0){
    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:notification.alertBody message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        if ([segue.identifier isEqualToString:@"NextSegue"])
        {
            ProfileViewController *dest = [segue destinationViewController];
            NSIndexPath *path = [self.tableView indexPathForCell:sender];
            dest.myData = [[nameArray objectAtIndex:path.row]objectForKey:@"id"];
        }
    }
}




@end
