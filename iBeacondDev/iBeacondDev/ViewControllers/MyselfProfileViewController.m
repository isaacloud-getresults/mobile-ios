//
//  ProfileViewController.m
//  iGetResults
//
//  Created by mac on 07.08.2014.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import "MyselfProfileViewController.h"

@interface MyselfProfileViewController ()

@end

@implementation MyselfProfileViewController



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
    
  
    // NSLog(@"%@",nameArray);
    
    
    // userArray = [[NSMutableArray alloc]initWithArray:[icc getUserWithUID:self.myData] ];
    // NSLog(@"%@",[icc getUserWithUID:self.myData]);
    
    
   // userData = [[NSDictionary alloc]initWithDictionary:[icc getUserWithUID:[icc getUserUID]]];
   // nameArray = [icc getInteriors];
    
    //[self organizer];
    
    
    // Do any additional setup after loading the view.
    //
    // NSLog(@"%@",[icc getUserWithUID:self.myData]);
    
    
    userformData = [UserData globalUserData];
    
    
    // icc = [[IsaaCloudConnector alloc]init ];
    pomieszczeniaArray = userformData.pomieszczeniaArray;
    // NSLog(@"%@",nameArray);
    
    
    // userArray = [[NSMutableArray alloc]initWithArray:[icc getUserWithUID:self.myData] ];
    // NSLog(@"%@",[icc getUserWithUID:self.myData]);
    
    
    //userData = [[NSDictionary alloc]initWithDictionary:[icc getUserWithUID:self.myData]];
    
    
    nameArray = userformData.nameArray;
    
    
    
    
    for (int i = 0; [nameArray count]>i; i++) {
        
        if ([[[nameArray objectAtIndex:i] objectForKey:@"id"] isEqualToNumber:[icc getUserUID]]){
            
            userData = [nameArray objectAtIndex:i];
            break;
        }
        
    }
    
    

    
    //[self organizer];
    
    
   // liczba = [NSNumber numberWithInt:[userData count]];
    [self organizer];
    

    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
    
   // [self organizer];
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

-(void)organizer{
    
    ////////////////////////////////////////////////////////////////////////////////
    
    self.emailLabel.text = (NSString*)[userData objectForKey:@"email"];
    
    ////////////////////////////////////////////////////////////////////////////////
    
    NSString * value = [userData objectForKey:@"lastName"];
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        self.lastNameLabel.text = @"Nobody";
    }
    else{
        self.lastNameLabel.text = value;
    }
    
    ////////////////////////////////////////////////////////////////////////////////
    
    NSString * value2 = [userData objectForKey:@"firstName"];
    if (value2 == nil || [value2 isKindOfClass:[NSNull class]]) {
        self.firstNameLabel.text = @"Nemo";
    }
    else{
        self.firstNameLabel.text = value2;
    }
    
    ////////////////////////////////////////////////////////////////////////////////
    
    NSNumber * value3 = [userData objectForKey:@"gender"];
    
    NSLog(@"%@",value3);
    
    if ([value3 isEqualToNumber: [NSNumber numberWithInt:1]]) {
        self.genderLabel.text = @"Male";
    }
    else if ([value3 isEqualToNumber: [NSNumber numberWithInt:2]]){
        self.genderLabel.text = @"Female";
    }
    else{
        self.genderLabel.text = @"UNKNOWN";
    }
    
    ////////////////////////////////////////////////////////////////////////////////
    
    NSString* date3 = [userData objectForKey:@"birthDate"];
    if (date3 == nil || [date3 isKindOfClass:[NSNull class]]) {
        self.ageLabel.text = @"UNKNOWN";
    }
    else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* now = [NSDate date];
        NSDate *date23 = [dateFormatter dateFromString:date3];
        NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                           components:NSYearCalendarUnit
                                           fromDate:date23
                                           toDate:now
                                           options:0];
        NSInteger age = [ageComponents year];
        
        self.ageLabel.text = [NSString stringWithFormat:@"%ld",(long)age];
    }
    
    ////////////////////////////////////////////////////////////////////////////////
    
    
    
    
    if ([[userData objectForKey:@"leaderboards"] count] == 0 ) {
        
        self.pointsLabel.text = @"UNKNOWN";
        self.wonGamesLabel.text = @"UNKNOWN";
    }else{
        NSNumber *score = [[NSNumber alloc] init];
        score = [[[userData objectForKey:@"leaderboards"]objectAtIndex:1]objectForKey:@"score" ];
        NSNumber *position = [[NSNumber alloc] init];
        position = [[[userData objectForKey:@"leaderboards"]objectAtIndex:1]objectForKey:@"position" ];
        
        NSString *scoreNumb = [NSString stringWithFormat:@"%@",score];
        NSString *positionNumb = [NSString stringWithFormat:@"%@",position];
        
        self.pointsLabel.text = scoreNumb;
        self.wonGamesLabel.text = positionNumb;
        
        
        NSLog(@"%@",scoreNumb);
        NSLog(@"%@",positionNumb);
        
        NSLog(@"Wykonalo sie");
    }
    
    
    
    NSNumber *valueOfCounter = [[NSNumber alloc]init];
    
    if ([[userData objectForKey:@"counterValues"]count] != 0) {
        //  NSLog(@"%lu",(unsigned long)[[[nameArray objectAtIndex:indexPath.row]objectForKey:@"counterValues"]count]);
        
        for (int i = 0; [[userData objectForKey:@"counterValues"]count] > i; i++) {
            if ([[[[userData objectForKey:@"counterValues"]objectAtIndex:i]objectForKey:@"counter"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                valueOfCounter = [[[userData objectForKey:@"counterValues"]objectAtIndex:i]objectForKey:@"value"];
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
    
    UIImage *imagetoto = [[UIImage alloc]init];
    
    if ([[userData objectForKey:@"custom"] count] != 0 ){
        
        //[[userData objectForKey:@"custom"]objectForKey:@"facebookPhoto"];
        imagetoto = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:[[userData objectForKey:@"custom"]objectForKey:@"facebookPhoto"]]]];
        
    }else{
        imagetoto = [UIImage imageNamed:@"111-user-icon.png"];
        NSLog(@"czy to?");
    }
    
    //   self.profilePhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
    
    self.profilePhoto.image = imagetoto;
    
    
    self.interiorLabel.text = pomieszczenie;
    
    //self.profilePhoto= imageView;
    
    
    //NSLog(@"%@",pomieszczenie);
    self.interiorLabel.text = pomieszczenie;
    
    
}


@end
