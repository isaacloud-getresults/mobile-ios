//
//  HeaderParam.m
//  IsaaCloudExampleApp
//
//  Created by akl on 4/25/14.
//  Copyright (c) 2014 SoInteractive. All rights reserved.
//

#import "HeaderParam.h"

@implementation HeaderParam

-(id)initWithField:(NSString*)f withValue:(NSString*)v set:(BOOL)s
{
    self.field = f;
    self.value = v;
    self.set = s;
    return self;
}

@end
