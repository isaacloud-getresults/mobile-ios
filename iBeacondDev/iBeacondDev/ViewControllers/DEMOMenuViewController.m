//
//  DEMOMenuViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOMenuViewController.h"
#import "DEMOHomeViewController.h"
#import "DEMOSecondViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "DEMONavigationController.h"


#import "TabBarController.h"
#import "FirstTableViewController.h"
#import "MyselfProfileViewController.h"
#import "AchievementsViewController.h"
#import "LiderboardTableViewController.h"


#import "UserData.h"

@interface DEMOMenuViewController ()<CLLocationManagerDelegate,CBPeripheralManagerDelegate>{
     BOOL turnAdvertisingOn;
}
@end

@implementation DEMOMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  //  NSLog(@"Pierwsza !!!!");
    icc = [[IsaaCloudConnector alloc]init];
    
    nameArray = [icc getUsers];
    pomieszczeniaArray = [icc getInteriors];
    [icc getNotifications];
    userData.notyfikacje = [icc getNotificationsArray];
    userData = [UserData globalUserData];
    userData.nameArray = nameArray;
    userData.pomieszczeniaArray = pomieszczeniaArray;
    
    
    for (int i = 0; [nameArray count]>i; i++) {
        
        if ([[[nameArray objectAtIndex:i] objectForKey:@"id"] isEqualToNumber:[icc getUserUID]]){
            
            userformData = [nameArray objectAtIndex:i];
            break;
        }
        
    }
    
       
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 204.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
     //   [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:filePath]]];
        
       
        UIImage *imagetoto = [[UIImage alloc]init];
        
        if ([[userformData objectForKey:@"custom"] count] != 0 ){
            
            //[[userData objectForKey:@"custom"]objectForKey:@"facebookPhoto"];
            imagetoto = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:[[userformData objectForKey:@"custom"]objectForKey:@"facebookPhoto"]]]];
            
        }else{
            imagetoto = [UIImage imageNamed:@"111-user-icon.png"];
           // NSLog(@"czy to?");
        }

        
        
        
        imageView.image = imagetoto;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
 NSNumber *valueOfCounter;
        
        if ([[userformData objectForKey:@"counterValues"]count] != 0) {
            
            for (int i = 0; [[userformData objectForKey:@"counterValues"]count] > i; i++) {
                if ([[[[userformData objectForKey:@"counterValues"]objectAtIndex:i]objectForKey:@"counter"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    
                    valueOfCounter = [[[userformData objectForKey:@"counterValues"]objectAtIndex:i]objectForKey:@"value"];
                    
                    break;
                }
            }
        }else{
            valueOfCounter = [NSNumber numberWithInteger:3];
        }
        //    NSString *pomieszczenie = [icc getGroupsNameWithID:valueOfCounter];
        NSString *pomieszczenie = [[NSString alloc]init];
        
        //  cell.detailTextLabel.text = valueOfCounter;
        
        for (int i = 0; [pomieszczeniaArray count] > i; i++) {
            if ([[[pomieszczeniaArray objectAtIndex:i] objectForKey:@"id"] isEqualToNumber:valueOfCounter]) {
                pomieszczenie  = [[pomieszczeniaArray objectAtIndex:i] objectForKey:@"label"];
                break;
            }
        }

 
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        label.text = [NSString stringWithFormat:@"%@ %@",[userformData objectForKey:@"firstName"],[userformData objectForKey:@"lastName"]];
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
       label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 185, 0, 24)];
        label2.text = pomieszczenie;
        label2.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label2 sizeToFit];
        label2.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        
        [view addSubview:imageView];
        [view addSubview:label];
        [view addSubview:label2];
        view;
    });
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"plist.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"plist.plist"] ];
    }
    
    
    
    
    NSMutableDictionary *data;
    
    if ([fileManager fileExistsAtPath: path])
    {
        data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    }
    else
    {
        NSString *pfile = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
        data = [[NSMutableDictionary alloc] initWithContentsOfFile:pfile];
        
    }
    
    
    
    beaconuuid = [NSString stringWithFormat:@"%@",[data valueForKey:@"UUID"]];
    
    
    
    
    
    
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
    [self startNotificationThread];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateMethod) userInfo:nil repeats:YES];
    
    

    
}


-(void)viewDidAppear:(BOOL)animated{
    
    label.text = [NSString stringWithFormat:@"%@ %@",[userformData objectForKey:@"firstName"],[userformData objectForKey:@"lastName"]];
    NSLog(@"to dziala");
    
}

- (void) updateMethod
{
   // NSLog(@"UPDATE");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //  NSLog(@"%@",[icc getMyselfData]);
        userData.nameArray = [icc getUsers];
        nameArray = userData.nameArray;
        
        
        for (int i = 0; [nameArray count]>i; i++) {
            
            if ([[[nameArray objectAtIndex:i] objectForKey:@"id"] isEqualToNumber:[icc getUserUID]]){
                
                userformData = [nameArray objectAtIndex:i];
                break;
            }
            
        }
        
        
        
        
        
         NSNumber *valueOfCounter;
        
        if ([[userformData objectForKey:@"counterValues"]count] != 0) {
            
            for (int i = 0; [[userformData objectForKey:@"counterValues"]count] > i; i++) {
                if ([[[[userformData objectForKey:@"counterValues"]objectAtIndex:i]objectForKey:@"counter"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    
                    valueOfCounter = [[[userformData objectForKey:@"counterValues"]objectAtIndex:i]objectForKey:@"value"];
                  //  NSLog(@"VALUE OF COUNTER @@@@@@@@@@@@ VALUE OF COUNTER @@@@@@@@@@@@@@@     %@",valueOfCounter);
                    break;
                }
            }
        }else{
            valueOfCounter = [NSNumber numberWithInteger:3];
        }
        //    NSString *pomieszczenie = [icc getGroupsNameWithID:valueOfCounter];
        NSString *pomieszczenie = [[NSString alloc]init];
        
        //  cell.detailTextLabel.text = valueOfCounter;
        
        for (int i = 0; [pomieszczeniaArray count] > i; i++) {
            if ([[[pomieszczeniaArray objectAtIndex:i] objectForKey:@"id"] isEqualToNumber:valueOfCounter]) {
                pomieszczenie  = [[pomieszczeniaArray objectAtIndex:i] objectForKey:@"label"];
                break;
            }
        }

    //    NSLog(@"%@",pomieszczenie);
        
        
        
    //
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
          //  NSLog(@"%@",label2.text);
            label2.text = pomieszczenie;
        });
    });
    
}




#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  //  NSLog(@"%ld %ld",(long)indexPath.row,(long)indexPath.section);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TabBarController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"nowy"];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
       // TabBarController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"nowy"];
       // navigationController.viewControllers = @[homeViewController];
        
        TabBarController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"nowy"];
                                   [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (indexPath.section == 0 && indexPath.row == 1){
        
      // ProfileViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"profileView"];
      // [self.navigationController pushViewController:vc animated:YES];
        
         MyselfProfileViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"profileView2"];
         navigationController.viewControllers = @[homeViewController];
       
        
       // toProfile
    }else if (indexPath.section == 0 && indexPath.row == 2){
        AchievementsViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"achievements"];
        navigationController.viewControllers = @[avc];
        
        
        // achievements
        
    }else if (indexPath.section == 0 && indexPath.row == 3){
        
        LiderboardTableViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"liderboard"];
        navigationController.viewControllers = @[avc];
        
        
    }
    else if (indexPath.section == 1 && indexPath.row == 1){
     //  [FBSession.activeSession closeAndClearTokenInformation];
        
        [timer invalidate];
        timer = nil;
    
        [self stopNotificationThread];
        [self stopRanging];
        
        icc.registrationDelegate = nil;
        icc.loginDelegate = nil;
        icc.adminTokenDelegate = nil;
        [icc logoutUserAsync:[[LoggedInUser getInstance] uid]];
        [FBSession.activeSession closeAndClearTokenInformation];
      

    
        [self performSegueWithIdentifier:@"backToLoginSegue" sender:self];
        
       // TabBarController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"nowy"];
       // navigationController.viewControllers = @[homeViewController];
        
        
    }
    
    
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
    
}

#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    
    if (sectionIndex == 0){
        return 4;}
    else{
        return 1;
    }

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        NSArray *titles = @[@"Home", @"Profile", @"Achievements",@"Liderboard"];
        cell.textLabel.text = titles[indexPath.row];
    } else {
        NSArray *titles = @[@"Wyloguj"];
        cell.textLabel.text = titles[indexPath.row];
    }
    
    return cell;
}


/////////////////////////////


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
            _uuid = [[NSUUID alloc] initWithUUIDString:beaconuuid];
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
        _uuid = [[NSUUID alloc] initWithUUIDString:beaconuuid];
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
        //   [self showNotification:[nameArray firstObject]];
        
        
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

/*
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
*/

-(void)stopNotificationThread
{
    endThread = YES;
}

-(void)startNotificationThread
{
    endThread = NO;
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(checkNotifications) object:nil];
    [thread start];
}

-(void)checkNotifications
{
    while(!endThread)
    {
        
        userData.notyfikacje = [icc getNotificationsArray];
        NSArray* nofitications = [icc getNotifications];
        
        // [icc getNotifications];
        for(ICNotification *n in nofitications)
        {
            NSLog(@"Noti = %@ - %@", n.title, n.text);
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^
             {
                 NSLog(@"show alert!");
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[[n.data valueForKey:@"body"]valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
             }];
            if(!isForeground)
            {
                UILocalNotification *ln = [[UILocalNotification alloc] init];
                ln.alertBody = [[n.data valueForKey:@"body"]valueForKey:@"message"];
                ln.soundName = UILocalNotificationDefaultSoundName;
                [[UIApplication sharedApplication] scheduleLocalNotification:ln];
            }
        }
        NSLog(@"noti");
        [NSThread sleepForTimeInterval:2];
    }
}






@end
