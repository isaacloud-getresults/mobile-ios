//
//  FirstTableViewController.m
//  iBeacondDev
//
//  Created by mac on 28.07.2014.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import "FirstTableViewController.h"
#import "ProfileViewController.h"
#import "DEMOMenuViewController.h"
#import "UserData.h"


@interface FirstTableViewController ()<CLLocationManagerDelegate,CBPeripheralManagerDelegate>{
    BOOL turnAdvertisingOn;
}
@end

@implementation FirstTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
  
  //  self.userUid = icc.getUserUID;
//NSLog(@"DRUGAAAAAAAAAAAAA !!!!");
    
    //nameArray = [icc getUsers];
   // pomieszczeniaArray = [icc getInteriors];
    
   userData = [UserData globalUserData];
   // userData.nameArray = nameArray;
   // userData.pomieszczeniaArray = pomieszczeniaArray;
    
    nameArray =  userData.nameArray;
    pomieszczeniaArray = userData.pomieszczeniaArray;
    
  // nameArray = [[NSMutableArray alloc]initWithArray:[icc Notyficationsfrommy:self.userUid] ];
  //  NSLog(@"%@",nameArray);
    
   // [self showNotification:[nameArray firstObject]];
   // NSLog(@"%@",[icc getInteriorsALL]);
   
  //  NSLog(@"%@",nameArray);
    
   /*
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
    
    
    
    */
   
    
  //  [self.imionaArray dajMiTablice:nameArray];
    
   //NSString *pomieszczenie = [icc getGroupsNameWithID:userID];
    
  // beacon = [[CLBeacon alloc] init];
   // [icc getNotifications];
    
    
  //  connectedToBeacon = @"FALSE";
 //   isInRegion = @"FALSE";
    
    /*
    connectedToBeacon = [[NSUserDefaults standardUserDefaults]
                                   stringForKey:@"connectedToBeacon"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"FALSE"
                                              forKey:@"connectedToBeacon"];
    [[NSUserDefaults standardUserDefaults] synchronize];
     
     */
    
 
    
  //  [self startRanging];
    // [self startNotificationThread];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [timer invalidate];
    timer = nil;
    NSLog(@"wylaczono timer");
    
}


-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"pokazano widok");
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateMethod) userInfo:nil repeats:YES];
}


- (void) updateMethod
{
    NSLog(@"UPDATE TABLEVIEW FIRSTTABLEVIEWCONTROLLER");
    
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      //   nameArray = [icc getUsers];
     //  NSLog(@"%@",[icc getMyselfData]);
    //   userData.nameArray = nameArray;
    
    nameArray = userData.nameArray;
    
       dispatch_async(dispatch_get_main_queue(), ^{
         [self.tableView reloadData];
           
       });
   });
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"myCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
   // dddc.label.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    NSDictionary *currunent = [nameArray objectAtIndex:indexPath.row ];
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[currunent objectForKey:@"firstName"],[currunent objectForKey:@"lastName"]];
    
    cell.tag = indexPath.row;
    
    NSNumber *valueOfCounter = [[NSNumber alloc]init];
    
    if ([[[nameArray objectAtIndex:indexPath.row]objectForKey:@"counterValues"]count] != 0) {
      //  NSLog(@"%lu",(unsigned long)[[[nameArray objectAtIndex:indexPath.row]objectForKey:@"counterValues"]count]);

    for (int i = 0; [[[nameArray objectAtIndex:indexPath.row]objectForKey:@"counterValues"]count] > i; i++) {
                if ([[[[[nameArray objectAtIndex:indexPath.row] objectForKey:@"counterValues"]objectAtIndex:i]objectForKey:@"counter"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    
                        valueOfCounter = [[[[nameArray objectAtIndex:indexPath.row] objectForKey:@"counterValues"]objectAtIndex:i]objectForKey:@"value"];
                    
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
    
    cell.detailTextLabel.text = pomieszczenie;
    
    
   
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          
           UIImage *imagetoto = [[UIImage alloc]init];
          
          if ([[currunent objectForKey:@"custom"] count] != 0 ){
        
        imagetoto = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:[[currunent objectForKey:@"custom"]objectForKey:@"facebookPhoto"]]]];
             
    }else{
       imagetoto = [UIImage imageNamed:@"111-user-icon.png"];
    }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (cell.tag == indexPath.row) {
                
                cell.imageView.image = imagetoto;
                
                CGSize itemSize = CGSizeMake(50, 50);
                UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
                CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                [cell.imageView.image drawInRect:imageRect];
                cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                [cell setNeedsLayout];
            }

            
        });
    });
        
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
