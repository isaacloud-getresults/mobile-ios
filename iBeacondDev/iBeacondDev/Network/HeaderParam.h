//
//  HeaderParam.h
//  IsaaCloudExampleApp
//
//  Created by akl on 4/25/14.
//  Copyright (c) 2014 SoInteractive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeaderParam : NSObject

@property NSString *field;
@property NSString *value;
@property BOOL set;

-(id)initWithField:(NSString*)f withValue:(NSString*)v set:(BOOL)s;

@end
