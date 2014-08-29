//
//  LiderboardTableViewController.m
//  iGetResults
//
//  Created by mac on 29.08.2014.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import "LiderboardTableViewController.h"
#import "UserData.h"

@interface LiderboardTableViewController ()

@end

@implementation LiderboardTableViewController

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
    
    
    userformData = [UserData globalUserData];
    
    nameArray = userformData.nameArray;
    
    
    pomieszczeniaArray = [[NSMutableArray alloc]init ];
    
    for (int i = 0; [nameArray count] > i; i++) {
        
         if ([[[nameArray objectAtIndex:i] objectForKey:@"leaderboards"] count] != 0) {
             
             [pomieszczeniaArray addObject:[nameArray objectAtIndex:i] ];
             
             
         }
    }

    NSLog(@"%@",pomieszczeniaArray);


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
    return [pomieszczeniaArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ldCell" forIndexPath:indexPath];
    
    
    NSLog(@"%ld",(long)indexPath.row);
    
    
      //cell.tag = indexPath.row;
    long value = indexPath.row;
    
    value = indexPath.row +1;
   
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
         NSString *name;
        
        NSString *score;
         for (int i = 0; [pomieszczeniaArray count] > i; i++) {
        
        if ([[[[[pomieszczeniaArray objectAtIndex:i] objectForKey:@"leaderboards"]objectAtIndex:1]objectForKey:@"index"] isEqualToNumber:[NSNumber numberWithInteger:value]]) {
            name = [NSString stringWithFormat:@"%ld. %@ %@",value,[[pomieszczeniaArray objectAtIndex:i] objectForKey:@"firstName"],[[pomieszczeniaArray objectAtIndex:i] objectForKey:@"lastName"]];
            
            score= [NSString stringWithFormat:@"score: %@",[[[[pomieszczeniaArray objectAtIndex:i] objectForKey:@"leaderboards"] objectAtIndex:1] objectForKey:@"score"]];
            break;
            
        }
    }

        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
          
            
            cell.textLabel.text = name;
            cell.detailTextLabel.text = score;
            
            
       });
    });
    
    
    
   
        
        
        
     /*
        
      
        if ([[[[[pomieszczeniaArray objectAtIndex:i] objectForKey:@"leaderboards"]objectAtIndex:1]objectForKey:@"index"] isEqualToNumber:[NSNumber numberWithInteger:value]]) {
         cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@ %@",value,[[pomieszczeniaArray objectAtIndex:i] objectForKey:@"firstName"],[[pomieszczeniaArray objectAtIndex:i] objectForKey:@"lastName"]];
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"score: %@",[[[[pomieszczeniaArray objectAtIndex:i] objectForKey:@"leaderboards"] objectAtIndex:1] objectForKey:@"score"]];
            break;
      
        }
    }
      */
  //  cell.textLabel.text = @"test";
    
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
