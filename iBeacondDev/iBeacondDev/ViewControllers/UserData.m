//
//  UserData.m
//  iGetResults
//
//  Created by mac on 26.08.2014.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import "UserData.h"

@implementation UserData

@synthesize nameArray,pomieszczeniaArray,notyfikacje;

+ (id)globalUserData {
    static UserData *sharedUserData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUserData = [[self alloc] init];
    });
    return sharedUserData;
}

- (id)init {
    
    if (self = [super init]) {
        nameArray = [[NSArray alloc]init];
        pomieszczeniaArray = [[NSArray alloc]init];
        notyfikacje =[[NSArray alloc]init];
        
    }
    return self;
}

@end
