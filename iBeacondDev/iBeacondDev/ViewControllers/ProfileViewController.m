//
//  ProfileViewController.m
//  iGetResults
//
//  Created by mac on 07.08.2014.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController



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
    nameArray = [[NSMutableArray alloc]initWithArray:[icc getInteriors] ];
   // NSLog(@"%@",nameArray);
    
    
   // userArray = [[NSMutableArray alloc]initWithArray:[icc getUserWithUID:self.myData] ];
   // NSLog(@"%@",[icc getUserWithUID:self.myData]);

    
    userData = [[NSDictionary alloc]initWithDictionary:[icc getUserWithUID:self.myData]];
    
    //[self organizer];
    
    
    // Do any additional setup after loading the view.
 //
  // NSLog(@"%@",[icc getUserWithUID:self.myData]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
    liczba = [NSNumber numberWithInt:[userData count]];
    [self organizer];
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
    ////////////////////////////////////////////////////////////////////////////////
   // NSNumber *uid = [NSNumber numberWithInt:5];
    
  //  NSString *pomieszczenie = [icc getGroupsNameWithID:uid];
  
  // NSLog(@"%@",pomieszczenie);
    
    NSLog(@"%@",[userData objectForKey:@"counterValues"]);
    for (int i = 0; [[userData objectForKey:@"counterValues"]count] > i; i++) {
      //  NSLog(@"%@",[[[userData objectForKey:@"counterValues"]objectAtIndex:i]objectForKey:@"counter"]);
        
        if ([[[[userData objectForKey:@"counterValues"]objectAtIndex:i]objectForKey:@"counter"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            valueOfCounter = [[[userData objectForKey:@"counterValues"]objectAtIndex:i]objectForKey:@"value"];
        }
    }
    
   NSLog(@"%lu",(unsigned long)[[userData objectForKey:@"custom"] count]);
    
    
    if ([[userData objectForKey:@"custom"] count] != 0 ){
        
        //[[userData objectForKey:@"custom"]objectForKey:@"facebookPhoto"];
        self.profilePhoto.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:[[userData objectForKey:@"custom"]objectForKey:@"facebookPhoto"]]]];
        
    }
    
    
    NSString *pomieszczenie = [icc getGroupsNameWithID:valueOfCounter];
    
    //NSLog(@"%@",pomieszczenie);
    self.interiorLabel.text = pomieszczenie;
    
   /*
   NSString *text = [userData objectForKey:@"leaderboards"];
    NSLog(@"%@",text);
    if (text == nil || [text isKindOfClass:[NSNull class]] ) {
        text = nil;
        self.pointsLabel.text = @"UNKNOWN";
        self.wonGamesLabel.text = @"UNKNOWN";
    }else{
     //   self.pointsLabel.text = [[[userData objectForKey:@"leaderboards"]objectAtIndex:1]objectForKey:@"score" ];
        // self.wonGamesLabel.text = [[[userData objectForKey:@"leaderboards"]objectAtIndex:1]objectForKey:@"position" ];
        
        NSLog(@"Wykonalo sie");
    }
  
    */
    
    // id result = [userData objectForKey:@"leaderboards"];
  /*
    id result = [userData objectForKey:@"leaderboards"];
    if ([result length] > 0) {
         //self.pointsLabel.text = @"UNKNOWN";
        //self.wonGamesLabel.text = @"UNKNOWN";
   
    }else{
    
            NSLog(@"wykonalo sie");
        //    self.pointsLabel.text = [[[userData objectForKey:@"leaderboards"]objectAtIndex:1]objectForKey:@"score" ];
          //  self.wonGamesLabel.text = [[[userData objectForKey:@"leaderboards"]objectAtIndex:1]objectForKey:@"position" ];

    }
    */
    
   
    /*
    id result2 = [userData objectForKey:@"leaderboards"];
    
    if([result2 length] >0)
    {
        NSLog(@"value is not empty! %@",result2);
    }
    else {
        NSLog(@"value is empty! %@",result2);
    }
    
    */
   /*
    NSString * liderboard = [[userData objectForKey:@"leaderboards"]objectAtIndex:1];
   if (liderboard == nil || [liderboard isKindOfClass:[NSNull class]]) {
        self.firstNameLabel.text = @"UNKNOWN";
        NSLog(@"nie wykonalo sie");
    }
    else{
        NSLog(@"wykonalo sie");
        self.pointsLabel.text = [[[userData objectForKey:@"leaderboards"]objectAtIndex:1]objectForKey:@"score" ];
        self.wonGamesLabel.text = [[[userData objectForKey:@"leaderboards"]objectAtIndex:1]objectForKey:@"position" ];
   
      //  NSLog(@"%@",[[[userData objectForKey:@"leaderboards"]objectAtIndex:1]objectForKey:@"position" ]);
    }
   */
 //  NSLog(@"%lu",(unsigned long)[[userData objectForKey:@"wonGames"]count]);
    

}


@end
