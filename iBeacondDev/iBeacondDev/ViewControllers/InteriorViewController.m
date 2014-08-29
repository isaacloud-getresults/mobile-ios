//
//  InteriorViewController.m
//  iGetResults
//
//  Created by mac on 13.08.2014.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import "InteriorViewController.h"
#import "InerAchievViewController.h"


@interface InteriorViewController ()

@end

@implementation InteriorViewController

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
    //nameArray = [icc getUsers];
    
    // NSLog(@"ID: %@",self.myData);
    
    // Do any additional setup after loading the view.
    
    
    userformData = [UserData globalUserData];
    // userData.nameArray = nameArray;
    // userData.pomieszczeniaArray = pomieszczeniaArray;
    
    nameArray =  userformData.nameArray;
    pomieszczeniaArray = userformData.pomieszczeniaArray;
    
    usersOfInterior = [[NSMutableArray alloc]init];
    
    
  //  cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[currunent objectForKey:@"firstName"],[currunent objectForKey:@"lastName"]];
    
    //cell.tag = indexPath.row;
    
    NSLog(@"ID POMIESZCZENIA : %@",self.myData);
    
    
    for (int i = 0; [nameArray count]>i; i++) {
        
        
        
        // NSLog(@"%@",[userData objectForKey:@"counterValues"]);
        for (int x = 0; [[[nameArray objectAtIndex:i]objectForKey:@"counterValues"]count] > x; x++) {
            
            if ([[[[[nameArray objectAtIndex:i] objectForKey:@"counterValues"]objectAtIndex:x]objectForKey:@"counter"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                if ([[[[[nameArray objectAtIndex:i] objectForKey:@"counterValues"]objectAtIndex:x]objectForKey:@"value"] isEqualToNumber:self.myData]) {
                    
                    NSString *imie = [NSString stringWithFormat:@"%@ %@",[[nameArray objectAtIndex:i] objectForKey:@"firstName"],[[nameArray objectAtIndex:i] objectForKey:@"lastName"]];
                    [usersOfInterior addObject:imie];
                    NSLog(@"%@",imie);
                    
                    
                    //NSLog(@"%@",[[array objectAtIndex:i] objectForKey:@"id"]);
                }
            }
        }
        
    }

    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // return [[icc getNumberofUsers:self.myData] count];
    return [usersOfInterior count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    
    
    
  //  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      //
       //   NSNumber *userId = [[icc getNumberofUsers:self.myData]objectAtIndex:indexPath.row];
        
     //   dispatch_sync(dispatch_get_main_queue(), ^{

    
    
    
  
    
    //[icc getUserWithID:userId];
    
    
    cell.textLabel.text = [usersOfInterior objectAtIndex:indexPath.row];
            
    //    });
   // });
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if ([segue.identifier isEqualToString:@"toAchievements"])
    {
        
        InerAchievViewController *dest = [segue destinationViewController];
        dest.myData = self.myData;
        
    }
    
    
    
    
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

@end
