//
//  ICError.h
//  IsaaCloudExampleApp
//
//  Created by akl on 5/5/14.
//  Copyright (c) 2014 SoInteractive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICError : NSObject

@property NSString *message;
@property NSArray *data;
@property NSNumber *code;

@end
