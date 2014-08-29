//
//  PamieszczeniaCollectionViewController.m
//  iGetResults
//
//  Created by mac on 07.08.2014.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import "AchievementsViewController.h"
#import "InteriorViewController.h"

@interface AchievementsViewController ()




@end

@implementation AchievementsViewController{
    
    
    
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
    nameArray = [[NSMutableArray alloc]initWithArray:[icc getAchievements] ];
    NSLog(@"%@",nameArray);
    
    // self.beaconManager = [[ESTBeaconManager alloc] init];
    // self.beaconManager.delegate = self;
    
    
    // NSUUID *uuid = [[NSUUID alloc]initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D" ];
    // self.region = [[ESTBeaconRegion alloc] initWithProximityUUID:uuid
    //                           identifier:@"EstimoteSampleRegion"];
    // [self.beaconManager startEstimoteBeaconsDiscoveryForRegion:self.region];
    
    //  NSLog(@"%@",[NSString stringWithFormat:@"RSSI: %ld", ]);
    
    // Do any additional setup after loading the view.
    
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
    return [nameArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UILabel *label1 = (UILabel*)[cell viewWithTag:100];
  
    //  UIImageView *image = (UIImageView*)[cell viewWithTag:102];
    
    [cell.layer setBorderWidth:1.0f];
    [cell.layer setBorderColor:[UIColor purpleColor].CGColor];
    
    
        
        
        label1.text = [[nameArray objectAtIndex:indexPath.row]objectForKey:@"label"];
        
    
    
    
    return cell;
    
}




@end
