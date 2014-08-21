//
//  LoggedInUser.m
//  IsaaCloudExampleApp
//
//  Created by akl on 4/26/14.
//  Copyright (c) 2014 SoInteractive. All rights reserved.
//

#import "LoggedInUser.h"

@implementation LoggedInUser

static LoggedInUser *instance = nil;

+(id)getInstance
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [[self alloc] init];
        }
    }
    return instance;
}

-(id) init
{
    if(self == [super init])
        return self;
    else
        return nil;
}

-(void)logOut
{
    instance = nil;
}

@end
