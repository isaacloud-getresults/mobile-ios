//
//  JSONParser.h
//  IsaaCloudExampleApp
//
//  Created by akl on 4/28/14.
//  Copyright (c) 2014 SoInteractive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONParser : NSObject

+(NSObject*)createObjectFromData:(NSMutableData*)data withClassName:(NSString*)className error:(NSError**)error;
+(NSObject*)createObjectFromJSON:(NSDictionary*)json withClassName:(NSString*)className;
+(NSString*)arrayToJSON:(NSArray*)array;
+(NSString*)dictionaryToJSON:(NSDictionary*)dictionary;

@end
