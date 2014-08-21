//
//  ICUser.m
//  IsaaCloudExampleApp
//
//  Created by akl on 4/26/14.
//  Copyright (c) 2014 SoInteractive. All rights reserved.
//

#import "ICUser.h"

@implementation ICUser

-(id) init
{
    self.id = [[NSNumber alloc] initWithInt: -1];
    return self;
}

-(id) initWithId:(NSNumber*)id
{
    self.id = id;
    return self;
}

@end
