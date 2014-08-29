//
//  NewsTableViewController.m
//  iGetResults
//
//  Created by mac on 28.08.2014.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import "NewsTableViewController.h"
#import "UserData.h"


@interface NewsTableViewController ()

@end

@implementation NewsTableViewController

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
    
    
    userData = [UserData globalUserData];
    // userData.nameArray = nameArray;
    // userData.pomieszczeniaArray = pomieszczeniaArray;
    
    notyfications =  userData.notyfikacje;
    nameArray =  userData.nameArray;
    
   
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    NSLog(@"UPDATE TABLEVIEW DAILY NEWS");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //   nameArray = [icc getUsers];
        //  NSLog(@"%@",[icc getMyselfData]);
        //   userData.nameArray = nameArray;
        
        notyfications =  userData.notyfikacje;
        
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

    // Return the number of rows in the section.
    return [notyfications count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
    
    
    long currentTime = (long)(NSTimeInterval)([[NSDate date] timeIntervalSince1970]);
    
    
     long theTime = [[[notyfications objectAtIndex:indexPath.row] objectForKey:@"createdAt"] longValue];
    
    
    
    long czas = (currentTime*1000) - theTime;
    
    
    
    long rownicapomioedzy =  czas / (1000*60*60);
   
    
    if (rownicapomioedzy) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld hours ago.",rownicapomioedzy];
        
    }else{
        long rownicapomioedzyminutach =  czas / (1000*60);
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld minutes ago.",rownicapomioedzyminutach];
       
    }
    
    NSDictionary *currunent;
    
    for (int i = 0; [nameArray count] > i; i++) {
        if ([[[nameArray objectAtIndex:i] objectForKey:@"id"] isEqualToNumber:[[notyfications objectAtIndex:indexPath.row] objectForKey:@"subjectId"]]) {
            currunent = [nameArray objectAtIndex:i];
        }
        
        
    }
    
   // cell.textLabel.text =  [[[[notyfications objectAtIndex:indexPath.row] objectForKey:@"data"] objectForKey:@"body"] objectForKey:@"message"];
    
    
    [[notyfications objectAtIndex:indexPath.row] objectForKey:@"subjectId"];
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@",[currunent objectForKey:@"firstName"],[currunent objectForKey:@"lastName"],[[[[notyfications objectAtIndex:indexPath.row] objectForKey:@"data"] objectForKey:@"body"] objectForKey:@"message"]];
    
    cell.tag = indexPath.row;
    
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

@end
