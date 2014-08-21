//
//  ObjectProperty.m
//  IsaaCloudExampleApp
//
//  Created by akl on 4/28/14.
//  Copyright (c) 2014 SoInteractive. All rights reserved.
//

#import "ObjectProperty.h"

@implementation ObjectProperty

-(id) initWithName:(NSString*)n withValue:(NSString*)v
{
    self.name = n;
    self.value = v;
    return self;
}

@end
