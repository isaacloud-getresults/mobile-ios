//
//  iPhoneViewController.m
//  iBeacondDev
//
//  Created by mac on 25.07.2014.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import "iPhoneViewController.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FirstTableViewController.h"

@interface iPhoneViewController ()

@property (strong,nonatomic)NSString *facebookFirstName;
@property (strong,nonatomic)NSString *facebookLastname;
@property (strong,nonatomic)NSString *facebookGender;
@property (strong,nonatomic)NSString *facebookEmail;
@property (nonatomic)NSString *facebookID;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;

@property (strong,nonatomic)NSString *userId;
@property (strong,nonatomic)NSString *pass;

@end

@implementation iPhoneViewController


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
/*  isForeground = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    bm =[BeaconManager sharedInstance];
  [bm addDelegete:self];
 
 
 */
    
   
    FBLoginView *loginView = [[FBLoginView alloc] init];
    
    
   
    
       
    // Align the button in the center horizontally
        
    [self.activityIndicator stopAnimating];
    icc = [[IsaaCloudConnector alloc] init];
    icc.registrationDelegate = self;
    icc.loginDelegate = self;
    icc.adminTokenDelegate = self;
    //    [self startNotificationThread];
    
    
   //  
    
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.regemailTextField.delegate = self;
    self.regPasswordTextField.delegate = self;
    self.userNameTextField.delegate = self;
    self.genderTextField.delegate = self;
    
    NSLog(@"START");
    
    
   // [self loginWithFacebook];
    
   //[self registerWithFacebookAnd];
    
   // self.loginButton.readPermissions = @[@"public_profile", @"email"];
   
}

-(void)viewDidAppear:(BOOL)animated{
    
    
    if(FBSession.activeSession.state == FBSessionStateOpen){
        
        
        
    }
    
  
    
}

-(void)loginWithFacebook{
    
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"user_birthday",@"email"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
            
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
             
             [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                 if(!error){
                     NSLog(@"%@",result);
                     
                     userDictionary = (NSDictionary *)result;
                     
                     
                     
                     self.facebookEmail = userDictionary[@"email"];
                     
                    // NSLog(@"%@",self.facebookEmail);
                     
                     self.facebookFirstName = userDictionary[@"first_name"];
                     
                    // NSLog(@"%@",self.facebookFirstName);
                     
                     self.facebookLastname = userDictionary[@"last_name"];
                     
                    // NSLog(@"%@",self.facebookLastname);
                     
                     self.userId = (NSString*)self.facebookEmail;
                     self.pass =@"Getresult1@";
                     
                     
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     [defaults setObject:(NSString*)self.facebookEmail forKey:@"userId"];
                     [defaults setObject:@"Getresult1@" forKey:@"userPassword"];
                     [defaults setObject:(NSString*)userDictionary[@"gender"] forKey:@"facebookGender"];
                     [defaults setObject:(NSString*)self.facebookFirstName forKey:@"facebookFirstName"];
                     [defaults setObject:(NSString*)userDictionary[@"id"] forKey:@"facebookID"];
                     [defaults setObject:(NSString*)self.facebookLastname forKey:@"facebookLastName"];
                     [defaults setObject:(NSString*)userDictionary[@"birthday"] forKey:@"facebookBirthday"];
                     [defaults synchronize];

                     
                     [self loginUser];
                     
                 }else{
                     NSLog(@"error %@",error);
                 }
             }];

    
         
         }];
    }
    
    
    
    /*
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSessionWithAllowLoginUI:YES];
    
    if (FBSession.activeSession.isOpen){
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if(!error){
                //NSLog(@"%@",result);
                
                userDictionary = (NSDictionary *)result;
                
                
                
                self.facebookEmail = userDictionary[@"email"];
                
                NSLog(@"%@",self.facebookEmail);
                
                self.facebookFirstName = userDictionary[@"first_name"];
                
                NSLog(@"%@",self.facebookFirstName);
                
                self.facebookLastname = userDictionary[@"last_name"];
                
                NSLog(@"%@",self.facebookLastname);
                
                self.userId = (NSString*)self.facebookEmail;
                self.pass =@"Getresult1@";
                
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:(NSString*)self.facebookEmail forKey:@"userId"];
                [defaults setObject:@"Getresult1@" forKey:@"userPassword"];
                [defaults synchronize];
                
                [self loginUser];
                
            }else{
                NSLog(@"error %@",error);
            }
        }];
    }

    */
}

-(void)registerWithFacebookAnd{
    
    
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"user_birthday",@"email"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
             
             [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                 if(!error){
                   //  NSLog(@"%@",result);
                     
                     userDictionary = (NSDictionary *)result;
                     
                    
                     
                     self.facebookEmail = userDictionary[@"email"];
                     
                     NSLog(@"%@",self.facebookEmail);
                     
                     self.facebookFirstName = userDictionary[@"first_name"];
                     
                     NSLog(@"%@",self.facebookFirstName);
                     
                     self.facebookLastname = userDictionary[@"last_name"];
                     
                     NSLog(@"%@",self.facebookLastname);
                     
                     self.userId = (NSString*)self.facebookEmail;
                     self.pass =@"Getresult1@";
                     
                     
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     [defaults setObject:(NSString*)self.facebookEmail forKey:@"userId"];
                     [defaults setObject:@"Getresult1@" forKey:@"userPassword"];
                     [defaults setObject:(NSString*)userDictionary[@"gender"] forKey:@"facebookGender"];
                     [defaults setObject:(NSString*)self.facebookFirstName forKey:@"facebookFirstName"];
                     [defaults setObject:(NSString*)userDictionary[@"id"] forKey:@"facebookID"];
                     [defaults setObject:(NSString*)self.facebookLastname forKey:@"facebookLastName"];
                     [defaults setObject:(NSString*)userDictionary[@"birthday"] forKey:@"facebookBirthday"];
                     [defaults synchronize];
                     
                     
                     [self createUserAccount];
                     
                 }else{
                     NSLog(@"error %@",error);
                 }
             }];
             
             
             
         }];
    }
    
    
    
    
    
   /*
    
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if(!error){
                //NSLog(@"%@",result);
                
                userDictionary = (NSDictionary *)result;
                
                
                
                self.facebookEmail = userDictionary[@"email"];
                
                NSLog(@"%@",self.facebookEmail);
                
                self.facebookFirstName = userDictionary[@"first_name"];
                
                NSLog(@"%@",self.facebookFirstName);
                
                self.facebookLastname = userDictionary[@"last_name"];
                
                NSLog(@"%@",self.facebookLastname);
                
                
                self.userId = (NSString*)self.facebookEmail;
                self.pass =@"Getresult1@";
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:(NSString*)self.facebookEmail forKey:@"userId"];
                [defaults setObject:@"Getresult1@" forKey:@"userPassword"];
                [defaults synchronize];
                
                [self createUserAccount];
                
            }else{
                NSLog(@"error %@",error);
            }
        }];
 
    
    */
    
}





/*
-(void)appDidEnterBackground
{
    NSLog(@"Background");
    isForeground = NO;
}

-(void)appWillEnterForeground
{
    NSLog(@"Foreground");
    isForeground = YES;
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)createUserAccount
{
    NSLog(@"Creating user account...");
       [icc getAdminTokenAsync];
   // [self startNotificationThread];
    NSLog(@"Created user...");
}
/*
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
        NSArray* nofitications = [icc getNotifications];
        for(ICNotification *n in nofitications)
        {
            NSLog(@"Noti = %@ - %@", n.title, n.text);
            NSString *text = [NSString stringWithFormat:@"IsaaCloud Notification Title=\"%@\" Text=\"%@\"", n.title, n.text];
            [self performSelectorOnMainThread:@selector(setOutput:) withObject:text waitUntilDone:NO];
            if(!isForeground)
            {
                UILocalNotification *ln = [[UILocalNotification alloc] init];
                ln.alertBody = n.text;
                ln.soundName = UILocalNotificationDefaultSoundName;
                [[UIApplication sharedApplication] scheduleLocalNotification:ln];
            }
        }
        NSLog(@"noti");
        [NSThread sleepForTimeInterval:1];
    }
}
*/


-(void)updateFacebookInformations{
    
    
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
   /*
    [defaults setObject:(NSString*)self.facebookEmail forKey:@"userId"];
    [defaults setObject:@"Getresult1@" forKey:@"userPassword"];
    [defaults setObject:(NSString*)userDictionary[@"gender"] forKey:@"facebookGender"];
    [defaults setObject:(NSString*)self.facebookFirstName forKey:@"facebookID"];
    [defaults setObject:(NSString*)self.facebookLastname forKey:@"facebookLastName"];
    [defaults setObject:(NSDate*)userDictionary[@"birthday"] forKey:@"facebookBirthday"];
    [defaults synchronize];
*/
   // NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
    
    
    NSString *custumfield = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal&return_ssl_resources=1",[defaults objectForKey:@"facebookID"]];
    
    NSString *gender = [NSString stringWithFormat:(NSString*)[defaults objectForKey:@"facebookGender"]];
    [gender uppercaseString];
 //   NSString *birthday = [NSString stringWithFormat:(NSString*)[defaults objectForKey:@"birthday"]];
    
    
    
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"MM/dd/yyyy"];
   
    NSDate *todaydate = [dateFormat1 dateFromString:[defaults objectForKey:@"facebookBirthday"]];// date with yyyy-MM-dd format
    
    NSLog(@"%@",todaydate);
    
    
    
    [dateFormat1 setDateFormat:@"yyyy-MM-dd"];
    
    NSString *strToday = [dateFormat1  stringFromDate:todaydate];
    
    NSLog(@"%@",strToday);
    
    
    
    [icc updateFacebookProfileData:[defaults objectForKey:@"facebookFirstName"] lastname:[defaults objectForKey:@"facebookLastName"] gender:[gender uppercaseString] birthday:strToday custumfields:custumfield];
    
    
}


-(void)loginUser
{
    NSLog(@"Logging in user... <<<<< loginUser 1");
    
   

    
    [icc loginUserAsync:(NSString*)self.userId password:self.pass];
    NSLog(@"Logging in user... <<<< loginUser 2");
}

-(void)adminToken:(NSString*)adminToken withError:(NSError*)error{
    if (error == nil)
    {
        NSLog(@"EMAIL=%@",(NSString*)self.userId);
        
        
        
        [icc registerUserAsync:(NSString*)self.userId password:self.pass withAdminToken:adminToken];
        NSLog(@"adminToken");
         
       
    }
    else
    {
        
        NSString *err = (error == nil) ? @"Cannot create user account." : [error localizedDescription];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:err delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        //[self.activityIndicator stopAnimating];
    }
}

-(void)userRegisteredWithUid:(int)uid withError:(NSError*)error
{
    if(uid == -1)
    {
        
        NSString *err = (error == nil) ? @"Cannot create user account." : [error localizedDescription];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:err delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        NSLog(@"Cannot create user account");
        //[self.activityIndicator stopAnimating];
    }
    else
    {
        NSLog(@"userRegisteredWithUid");
        [self loginUser];
    }
}

-(void)userLoggedInWithUid:(int)uid withError:(NSError*)error;
{
    NSLog(@"Logging in user... <<< userloggedwithuid");
    
    NSLog(@"userloggedwithuid  UID = %i",uid);

    if(uid == -1){
        
        NSString *err = (error == nil) ? @"Cannot log in user." : [error localizedDescription];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:err delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        NSLog(@"Cannot login user");
        [self.activityIndicator stopAnimating];
        }
    else
    {
        
        if (FBSession.activeSession.state == FBSessionStateOpen
            || FBSession.activeSession.state == FBSessionStateOpenTokenExtended){
            
            [self updateFacebookInformations];
            
            NSLog(@"Otwartee");
        }
         
        NSLog(@"Welcome %@ (%d)", self.userId, uid);
        
        [icc sendLoginEvent];
        
       // [self.activityIndicator stopAnimating];
        NSLog(@"przelacznie...");
        
        [self performSegueWithIdentifier:@"login" sender:self];
    }
}
/*
-(void)setStatus:(NSString*)text
{
    self.statusLabel.text = text;
    [self setOutput:text];
}

-(void)setRegionStatus:(NSString*)text
{
    self.regionStatusLabel.text = text;
    [self setOutput:text];
}

-(void)setOutput:(NSString*)text
{
    self.outputTextView.text = [self.outputTextView.text stringByAppendingFormat:@"%@\n", text];
    [self.outputTextView scrollRangeToVisible:NSMakeRange([self.outputTextView.text length], 0)];
}




-(void)restartIsaaCloudConnection
{
    icc.registrationDelegate = nil;
    icc.loginDelegate = nil;
    icc.adminTokenDelegate = nil;
    [icc logoutUserAsync:[[LoggedInUser getInstance] uid]];
   
    icc = [[IsaaCloudConnector alloc] init];
    icc.registrationDelegate = self;
    icc.loginDelegate = self;
    icc.adminTokenDelegate = self;
 //   [self stopNotificationThread];
 //   [self startNotificationThread];
}

-(void)restartBeacons
{
    [bm createRegion];
}
*/
/*
- (IBAction)registerButton:(id)sender {
    
    [self.activityIndicator startAnimating];
    
    [self createUserAccount];
    
    NSLog(@">>>>>>>>>>>>>>>>>>registered");
    
    
    
    
}

- (IBAction)loginTextDidEnd:(id)sender {
    [self.passwordText resignFirstResponder];
}

- (IBAction)passwordTextDidEnd:(id)sender {
    
    [self.loginText resignFirstResponder];
}
 
 
- (IBAction)loginButton:(id)sender {
    
    [self.activityIndicator startAnimating];
    
    [self loginUser];
    
    NSLog(@">>>>>>>>>>>>>>>>>>zalogowany");
    
  
    
}
- (IBAction)loaduserbutton:(id)sender {
    
    self.loginText.text = @"tester@test.pl";
    self.passwordText.text = @"Getresult1@";
    
}
 
 */
-(void)toggleHiddenState:(BOOL)shouldHide{
   // self.lblUsername.hidden = shouldHide;
   // self.lblEmail.hidden = shouldHide;
    //self.profilePicture.hidden = shouldHide;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)loginUserButton:(id)sender {
    
   // [self.activityIndicator startAnimating];
    
    self.userId = self.emailTextField.text;
    self.pass = self.passwordTextField.text;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.userId forKey:@"userId"];
    [defaults setObject:self.pass forKey:@"userPassword"];
    [defaults synchronize];
    
    [self loginUser];
    
    NSLog(@">>>>>>>>>>>>>>>>>>zalogowany");
}

- (IBAction)registerButtonPressed:(id)sender {
    
   // [self.activityIndicator startAnimating];
    
    self.userId = self.regemailTextField.text;
    self.pass = self.regPasswordTextField.text;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.userId forKey:@"userId"];
    [defaults setObject:self.pass forKey:@"userPassword"];
    [defaults synchronize];
    
    [self createUserAccount];
    
    NSLog(@">>>>>>>>>>>>>>>>>>registered");
}
- (IBAction)loginWithFacebookButton:(id)sender {
    // if the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended){
        //close the session and remove the access token from the cache.
        //the session state handler in the app delegate will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        //if the session state is not any of the two "open" states when the button is clicked
    }else{
        //open a sessiom showing user the login UI
        //must ALWAYS ask for basic_info when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"user_birthday",@"email"]
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                          //get app delegate
                                          AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
                                          //call the app delegates session changed method
                                          [appDelegate sessionStateChanged:session state:status error:error];
                                          
                                      }];
    }
    
    
    [self loginWithFacebook];
}




- (IBAction)registerWithFacebook:(id)sender {
    
    // if the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended){
        //close the session and remove the access token from the cache.
        //the session state handler in the app delegate will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        //if the session state is not any of the two "open" states when the button is clicked
    }else{
        //open a sessiom showing user the login UI
        //must ALWAYS ask for basic_info when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"user_birthday",@"email"]
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                          //get app delegate
                                          AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
                                          //call the app delegates session changed method
                                          [appDelegate sessionStateChanged:session state:status error:error];
                                          
                                      }];
    }
    
    [self registerWithFacebookAnd];

}
@end
