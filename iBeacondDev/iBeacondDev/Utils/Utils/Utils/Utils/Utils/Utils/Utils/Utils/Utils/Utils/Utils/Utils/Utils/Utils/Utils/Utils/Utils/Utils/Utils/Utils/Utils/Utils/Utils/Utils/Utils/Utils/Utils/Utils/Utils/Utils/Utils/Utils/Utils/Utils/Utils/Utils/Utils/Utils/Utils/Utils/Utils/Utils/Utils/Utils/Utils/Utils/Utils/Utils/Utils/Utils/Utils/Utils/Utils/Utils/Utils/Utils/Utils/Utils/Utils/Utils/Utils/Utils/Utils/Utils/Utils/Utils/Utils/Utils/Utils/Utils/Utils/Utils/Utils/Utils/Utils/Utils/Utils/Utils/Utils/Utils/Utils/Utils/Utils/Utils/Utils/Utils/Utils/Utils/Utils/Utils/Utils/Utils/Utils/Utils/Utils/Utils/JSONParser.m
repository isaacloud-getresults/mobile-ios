//
//  JSONParser.m
//  IsaaCloudExampleApp
//
//  Created by akl on 4/28/14.
//  Copyright (c) 2014 SoInteractive. All rights reserved.
//

#import "JSONParser.h"

@implementation JSONParser

+(NSObject*)createObjectFromData:(NSMutableData*)data withClassName:(NSString*)className error:(NSError**)error{
    NSError *err = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
    if(err == nil)
    {
        return [self createObjectFromJSON:json withClassName:className];
    }
    else
    {
        *error = err;
    }
    return nil;
}

+(NSObject*)createObjectFromJSON:(NSDictionary*)json withClassName:(NSString*)className{
    NSObject* object = [[NSClassFromString(className) alloc] init];
    for(id key in json){
        if([key isKindOfClass:[NSArray class]])
        {
            
        }
        else if([key isKindOfClass:[NSDictionary class]])
        {
            
        }
        else if([object respondsToSelector:NSSelectorFromString(key)])
        {
            NSObject *v = [json valueForKey:key];
            if(v != [NSNull null])
                [object setValue:v forKey:key];
        }
    }
    return object;
}

+(NSString*)arrayToJSON:(NSArray*)array
{
    NSString *a = @"[";
    for(int i = 0; i < array.count; i++)
    {
        NSObject* o = [array objectAtIndex:i];
        if([o isKindOfClass:[NSString class]])
        {
            a = [a stringByAppendingFormat:@"\"%@\"", (NSString*)o];
        }
        else if([o isKindOfClass:[NSNumber class]])
        {
             a = [a stringByAppendingFormat:@"%d", [(NSNumber*)o intValue]];
        }
        else
        {
            
        }
        if(i < array.count - 1)
        {
            a = [a stringByAppendingString:@","];
        }
    }
    a = [a stringByAppendingString:@"]"];
    return a;
}

+(NSString*)dictionaryToJSON:(NSDictionary*)dictionary
{
    NSString *a = @"{";
    BOOL cut = NO;
    for(id key in dictionary)
    {
        NSObject* val = [dictionary valueForKey:key];
        if([val isKindOfClass:[NSString class]])
        {
            a = [a stringByAppendingFormat:@"\"%@\":\"%@\"", key, (NSString*)val];
        }
        else if([val isKindOfClass:[NSNumber class]])
        {
            a = [a stringByAppendingFormat:@"\"%@\":%d", key, [(NSNumber*)val intValue]];
        }
        else
        {
            
        }
        a = [a stringByAppendingString:@","];
        cut = YES;
    }
    if(cut)
    {
        a = [a substringToIndex:([a length] - 1)];
    }
    a = [a stringByAppendingString:@"}"];
    return a;
}

@end
