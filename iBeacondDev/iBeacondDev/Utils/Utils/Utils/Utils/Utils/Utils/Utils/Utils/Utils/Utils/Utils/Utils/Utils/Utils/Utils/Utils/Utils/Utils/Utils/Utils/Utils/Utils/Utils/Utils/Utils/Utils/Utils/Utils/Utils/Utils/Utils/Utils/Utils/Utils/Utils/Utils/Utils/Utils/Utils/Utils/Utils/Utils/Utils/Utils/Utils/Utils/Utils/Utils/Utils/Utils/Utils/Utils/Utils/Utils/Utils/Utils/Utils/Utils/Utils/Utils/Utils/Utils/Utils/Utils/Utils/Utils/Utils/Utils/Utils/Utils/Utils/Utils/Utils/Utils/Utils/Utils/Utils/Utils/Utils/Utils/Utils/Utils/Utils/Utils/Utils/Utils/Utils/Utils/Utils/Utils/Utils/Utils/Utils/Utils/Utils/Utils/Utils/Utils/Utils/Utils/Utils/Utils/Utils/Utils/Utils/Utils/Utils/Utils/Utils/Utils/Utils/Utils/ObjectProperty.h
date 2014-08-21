//
//  ObjectProperty.h
//  IsaaCloudExampleApp
//
//  Created by akl on 4/28/14.
//  Copyright (c) 2014 SoInteractive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectProperty : NSObject

@property NSString *name;
@property NSString *value;

-(id) initWithName:(NSString*)n withValue:(NSString*)v;

@end
