//
//  ICCondition.h
//  iBeacondDev
//
//  Created by Adam on 04/06/14.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICCondition : NSObject

@property NSNumber *id;
@property NSString *name;
@property NSString *leftSide;
@property NSString *rightSide;
@property NSNumber *operator;
@property NSNumber *conditionType;
@property NSNumber *transactionSource;

@end
