//
//  AppDelegate.h
//  iBeacondDev
//
//  Created by Adam on 26/05/14.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PebbleKit/PebbleKit.h>
#import "IsaaCloudConnector.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate, PBPebbleCentralDelegate>{
    
    IsaaCloudConnector *icc;
    NSNumber *uid;
    BOOL a;
}

@property (strong, nonatomic) UIWindow *window;


-(void)sessionStateChanged:(FBSession *)session
                     state:(FBSessionState)status
                     error:(NSError *)error;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;

- (BOOL)openSessionWithoutAllowLoginUI:(BOOL)allowLoginUI;


-(void)peirwszaOpcja;

@end
