//
//  LoggedInUser.h
//  IsaaCloudExampleApp
//
//  Created by akl on 4/26/14.
//  Copyright (c) 2014 SoInteractive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoggedInUser : NSObject

+(id)getInstance;
@property NSString *accesToken;
@property int uid;

-(void)logOut;

@end
