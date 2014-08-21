//
//  InteriorViewController.m
//  iGetResults
//
//  Created by mac on 13.08.2014.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import "InteriorViewController.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[icc getNumberofUsers:self.myData] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
          NSNumber *userId = [[icc getNumberofUsers:self.myData]objectAtIndex:indexPath.row];
        
        dispatch_sync(dispatch_get_main_queue(), ^{

    
    
    
  
    
    //[icc getUserWithID:userId];
    
    
    cell.textLabel.text = [icc getUserWithID:userId];
            
        });
    });
    
    return cell;
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
