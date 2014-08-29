//
//  LiderboardTableViewController.h
//  iGetResults
//
//  Created by mac on 29.08.2014.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"

@interface LiderboardTableViewController : UITableViewController{
    
    
    NSDictionary* userData;
    NSNumber *liczba;
    NSArray *nameArray;
    //IsaaCloudConnector *icc;
    NSMutableArray *pomieszczeniaArray;
    
    UserData  *userformData;
    
    
}

@end
