//
//  PamieszczeniaCollectionViewController.m
//  iGetResults
//
//  Created by mac on 07.08.2014.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import "PamieszczeniaCollectionViewController.h"
#import "InteriorViewController.h"
#import "FirstTableViewController.h"
#import "UserData.h"

@interface PamieszczeniaCollectionViewController ()




@end

@implementation PamieszczeniaCollectionViewController{
    
   
    
}

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

    icc = [[IsaaCloudConnector alloc]init ];
  //  nameArray = [[NSMutableArray alloc]initWithArray:[icc getInteriors] ];
   // NSLog(@"%@",nameArray);
    
   
     userData = [UserData globalUserData];
    
   
    
  pomieszczeniaArray = userData.pomieszczeniaArray;
    nameArray = userData.nameArray;
    
    
   // self.beaconManager = [[ESTBeaconManager alloc] init];
   // self.beaconManager.delegate = self;
    
    
   // NSUUID *uuid = [[NSUUID alloc]initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D" ];
   // self.region = [[ESTBeaconRegion alloc] initWithProximityUUID:uuid
                           //                           identifier:@"EstimoteSampleRegion"];
   // [self.beaconManager startEstimoteBeaconsDiscoveryForRegion:self.region];
    
    //  NSLog(@"%@",[NSString stringWithFormat:@"RSSI: %ld", ]);
    
    // Do any additional setup after loading the view.
    
   
    
    
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
    NSLog(@"UPDATE");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        nameArray = userData.nameArray;
        
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            
        });
    });
    
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

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [pomieszczeniaArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UILabel *label1 = (UILabel*)[cell viewWithTag:100];
    UILabel *label2 = (UILabel*)[cell viewWithTag:101];
  //  UIImageView *image = (UIImageView*)[cell viewWithTag:102];
    
    [cell.layer setBorderWidth:1.0f];
    [cell.layer setBorderColor:[UIColor purpleColor].CGColor];
    
    
    label1.text = [[pomieszczeniaArray objectAtIndex:indexPath.row]objectForKey:@"label"];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
            
            
        
            
            
            idpomieszczenia = [[pomieszczeniaArray objectAtIndex:indexPath.row]objectForKey:@"id"];
        int z = 0;
        
        for (int i = 0; [nameArray count]>i; i++) {
            
            
            
            // NSLog(@"%@",[userData objectForKey:@"counterValues"]);
            for (int x = 0; [[[nameArray objectAtIndex:i]objectForKey:@"counterValues"]count] > x; x++) {
                
                if ([[[[[nameArray objectAtIndex:i] objectForKey:@"counterValues"]objectAtIndex:x]objectForKey:@"counter"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    if ([[[[[nameArray objectAtIndex:i] objectForKey:@"counterValues"]objectAtIndex:x]objectForKey:@"value"] isEqualToNumber:idpomieszczenia]) {
                        z++;
                        
                        //NSLog(@"%@",[[array objectAtIndex:i] objectForKey:@"id"]);
                    }
                }
            }
            
        }
        
            
            NSString *liczbaOsob = [NSString stringWithFormat:@"%d",z];
        
        
            
             dispatch_sync(dispatch_get_main_queue(), ^{
        label2.text = liczbaOsob;
        });
    });

    
   
    
    return cell;
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
        if ([segue.identifier isEqualToString:@"toInterior"])
        {
           
            InteriorViewController *dest = [segue destinationViewController];
            NSIndexPath *path = [self.collectionView indexPathForCell:sender];
            dest.myData = [[pomieszczeniaArray objectAtIndex:path.row]objectForKey:@"id"];
            
        }
   

    
    
}


@end
