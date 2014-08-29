//
//  UserData.h
//  iGetResults
//
//  Created by mac on 26.08.2014.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject{
    
     NSArray *nameArray;
     NSArray *pomieszczeniaArray;
    NSArray *notyfikacje;
    
    
    
}


@property (nonatomic, retain)  NSArray *nameArray;
@property (nonatomic, retain) NSArray *pomieszczeniaArray;
@property (nonatomic, retain) NSArray *notyfikacje;


+ (id) globalUserData;


@end
