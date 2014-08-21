//
//  ICGame.h
//  iBeacondDev
//
//  Created by Adam on 05/06/14.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICGame : NSObject

@property NSNumber *id;
@property NSString *name;
@property NSString *expression;
@property NSNumber *gameType;
@property NSArray *notifications;
@property NSNumber *active;
@property NSArray *conditions;
@property NSNumber *transactionSource;

@end
