//
//  NewsTableViewController.h
//  iGetResults
//
//  Created by mac on 28.08.2014.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"

@interface NewsTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>{
    
     UserData  *userData;
    
    NSArray *notyfications;
    NSArray *nameArray;
    
    NSTimer *timer;
}

@end
