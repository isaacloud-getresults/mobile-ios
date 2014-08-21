//
//  ICNotification.h
//  iBeacondDev
//
//  Created by Adam on 30/05/14.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICNotification : NSObject

// Notification object
@property NSNumber *id;
@property NSDictionary *data;
@property NSNumber *notificationType;
@property NSArray *game;

// Helpers
@property NSString *title;
@property NSString *text;


@end
