//
//  ICUser.h
//  IsaaCloudExampleApp
//
//  Created by akl on 4/26/14.
//  Copyright (c) 2014 SoInteractive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICUser : NSObject

@property NSNumber *updateAt;
@property NSArray *counterValues;
@property NSNumber *id;
@property NSString *email;
@property NSNumber *status;
@property NSDate *createdAt;
@property NSArray *leaderboards;

-(id) init;
-(id) initWithId:(NSNumber*)id;

@end
