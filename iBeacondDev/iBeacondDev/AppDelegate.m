//
//  AppDelegate.m
//  iBeacondDev
//
//  Created by Adam on 26/05/14.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SRWebSocket.h"


@implementation AppDelegate{
    
    PBWatch *_targetWatch;
    NSDictionary *odpowiedz;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
   // SlideMenuViewController *leftMenu = [[SlideMenuViewController alloc] init];
    
    
   // [SlideNavigationController sharedInstance].leftMenu = leftMenu;
    
   

    
    //[PFFacebookUtils initializeFacebook];
    icc = [[IsaaCloudConnector alloc]init ];
 //  NSLog(@"%@", [icc getUserUID]);
    
    [[PBPebbleCentral defaultCentral] setDelegate:self];
    a = true;
    
    uuid_t myAppUUIDbytes;
    NSUUID *myAppUUID = [[NSUUID alloc] initWithUUIDString:@"51b19145-0542-474f-8b62-c8c34ae4b87b"];
    [myAppUUID getUUIDBytes:myAppUUIDbytes];
    
    [[PBPebbleCentral defaultCentral] setAppUUID:[NSData dataWithBytes:myAppUUIDbytes length:16]];
    
    // Initialize with the last connected watch:
    [self setTargetWatch:[[PBPebbleCentral defaultCentral] lastConnectedWatch]];

    NSLog(@"%@",_targetWatch);
    
    
    
    [_targetWatch appMessagesGetIsSupported:^(PBWatch *watch, BOOL isAppMessagesSupported) {
        if (isAppMessagesSupported) {
           
            NSLog(@"SUPORRTED!");
            [_targetWatch appMessagesAddReceiveUpdateHandler:^BOOL(PBWatch *watch, NSDictionary *update2) {
                NSLog(@"Received message: %@", update2);
               // odpowiedz = update;
               
                
                NSLog(@"%ld",[[update2 objectForKey:@(1)] integerValue]);
                switch ([[update2 objectForKey:@(1)] integerValue]) {
                    case 1:
                        
                        [self peirwszaOpcja];
                        
                        break;
                    case 2:
                       // newStateString = @"Running";
                       //index = 1;
                        break;
                    case 3:
                        //newStateString = @"Paused";
                        break;
                    case 4:
                       // newStateString = @"End";
                        break;
                }
               
               
                
                
                return YES;
            }];
        
        }
            }];
    
   
    
 
    /*
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    }
    */
 
  //  UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
  /*
    if (notification) {
        [self showAlarm:notification.alertBody];
        NSLog(@"AppDelegate didFinishLaunchingWithOptions");
        application.applicationIconBadgeNumber = 0;
    }
    */
    [self.window makeKeyAndVisible];
   // [self connectWebSocket];
    
    
   
    
    return YES;
}

-(void)peirwszaOpcja{
    
    
    if (![[icc getUserUID] isEqualToNumber:[NSNumber numberWithInt:0]] && a) {
        
       NSNumber *valueOfCounter = [[NSNumber alloc]init];
        
       NSDictionary *user =   [icc getUserWithUID:[icc getUserUID]];
    
      
        
        NSLog(@"%@",[user objectForKey:@"counterValues"]);
        for (int i = 0; [[user objectForKey:@"counterValues"]count] > i; i++) {
            //  NSLog(@"%@",[[[userData objectForKey:@"counterValues"]objectAtIndex:i]objectForKey:@"counter"]);
            
            if ([[[[user objectForKey:@"counterValues"]objectAtIndex:i]objectForKey:@"counter"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                valueOfCounter = [[[user objectForKey:@"counterValues"]objectAtIndex:i]objectForKey:@"value"];
            }
        }
        
        // NSLog(@"%@",valueOfCounter);
        
        NSString *pomieszczenie = [icc getGroupsNameWithID:valueOfCounter];
        
        NSNumber *score = [[NSNumber alloc] init];
        NSNumber *position = [[NSNumber alloc] init];
        
        
        if ([[user objectForKey:@"leaderboards"] count] == 0 ) {
            
            score = [NSNumber numberWithUint8:0];
             position = [NSNumber numberWithUint8:0];
            
        }else{
           
            score = [[[user objectForKey:@"leaderboards"]objectAtIndex:1]objectForKey:@"score" ];
          
            position = [[[user objectForKey:@"leaderboards"]objectAtIndex:1]objectForKey:@"position" ];
            
            }
        NSNumber *iloscPomieszczen = [NSNumber numberWithInteger:[[icc getInteriors]count]];
    
       NSNumber *iloscAchievemnt = [NSNumber numberWithInteger:[[user objectForKey:@"gainedAchievements"]count ]];
        
    NSDictionary *update = @{ @(1):[NSNumber numberWithUint8:1],
                              @(2):[icc getUserWithID:[icc getUserUID]],
                              @(3):pomieszczenie,
                              @(4):score,
                              @(5):position,
                              @(6):iloscPomieszczen,
                              @(7):iloscAchievemnt};
       a = FALSE;
    
    [_targetWatch appMessagesPushUpdate:update onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
        
        NSLog(@"%@",update);
        
        if (!error) {
            NSLog(@"Successfully sent message.");
        }
        else {
            NSLog(@"Error sending message: %@", error);
        }
    }];

    
    }
    
}

- (void)setTargetWatch:(PBWatch*)watch {
    _targetWatch = watch;
    
    // NOTE:
    // For demonstration purposes, we start communicating with the watch immediately upon connection,
    // because we are calling -appMessagesGetIsSupported: here, which implicitely opens the communication session.
    // Real world apps should communicate only if the user is actively using the app, because there
    // is one communication session that is shared between all 3rd party iOS apps.
    
    // Test if the Pebble's firmware supports AppMessages / Weather:
    [watch appMessagesGetIsSupported:^(PBWatch *watch, BOOL isAppMessagesSupported) {
        if (isAppMessagesSupported) {
            // Configure our communications channel to target the weather app:
            // See demos/feature_app_messages/weather.c in the native watch app SDK for the same definition on the watch's end:
            //uint8_t bytes[] = {0x28, 0xAF, 0x3D, 0xC7, 0xE4, 0x0D, 0x49, 0x0F, 0xBE, 0xF2, 0x29, 0x54, 0x8C, 0x8B, 0x06, 0x00};
           // NSData *uuid = [NSData dataWithBytes:bytes length:sizeof(bytes)];
            //[[PBPebbleCentral defaultCentral] setAppUUID:uuid];
            
            NSString *message = [NSString stringWithFormat:@"Yay! %@ supports AppMessages :D", [watch name]];
            [[[UIAlertView alloc] initWithTitle:@"Connected!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        } else {
            
            NSString *message = [NSString stringWithFormat:@"Blegh... %@ does NOT support AppMessages :'(", [watch name]];
            [[[UIAlertView alloc] initWithTitle:@"Connected..." message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}


/*
 *  PBPebbleCentral delegate methods
 */

- (void)pebbleCentral:(PBPebbleCentral*)central watchDidConnect:(PBWatch*)watch isNew:(BOOL)isNew {
    NSLog(@"Connected!");
    
    
    [self setTargetWatch:watch];
    
    NSLog(@"Connected!");
}

- (void)pebbleCentral:(PBPebbleCentral*)central watchDidDisconnect:(PBWatch*)watch {
    [[[UIAlertView alloc] initWithTitle:@"Disconnected!" message:[watch name] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    if (_targetWatch == watch || [watch isEqual:_targetWatch]) {
        [self setTargetWatch:nil];
    }
}


//- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
//    NSLog(@"%@",[NSString stringWithFormat:@"%@", message]);
//}
/*
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [self showAlarm:notification.alertBody];
    application.applicationIconBadgeNumber = 0;
    NSLog(@"AppDelegate didReceiveLocalNotification %@", notification.userInfo);
}
*/
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
       // [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
       // [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        //[self userLoggedOut];
    }
}
-(void)fbResync
{
    ACAccountStore *accountStore;
    ACAccountType *accountTypeFB;
    if ((accountStore = [[ACAccountStore alloc] init]) && (accountTypeFB = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook] ) ){
        
        NSArray *fbAccounts = [accountStore accountsWithAccountType:accountTypeFB];
        id account;
        if (fbAccounts && [fbAccounts count] > 0 && (account = [fbAccounts objectAtIndex:0])){
            
            [accountStore renewCredentialsForAccount:account completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
                //we don't actually need to inspect renewResult or error.
                if (error){
                    
                    
                    
                }
            }];
        }
    }
}
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    
    
    return [FBSession openActiveSessionWithReadPermissions:nil
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                             [self sessionStateChanged:session state:state error:error];
                                         }];
    
}

- (BOOL)openSessionWithoutAllowLoginUI:(BOOL)allowLoginUI
{
    
    return [FBSession openActiveSessionWithReadPermissions:nil
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                             //[self sessionStateChanged:session state:state error:error];
                                         }];
    
}





-(void)showMessage:(NSString *)message
         withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:self
                      cancelButtonTitle:@"Ok!"
                      otherButtonTitles:nil] show];
}


- (void)showAlarm:(NSString *)text {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alarm"
                                                        message:text delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    
    
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
   
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if([[UIApplication sharedApplication] backgroundRefreshStatus] != UIBackgroundRefreshStatusAvailable){
        NSString *msg = @"\"Background App Refresh\" must be enabled for this application.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
