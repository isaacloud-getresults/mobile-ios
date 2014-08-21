//
//  InteriorViewController.h
//  iGetResults
//
//  Created by mac on 13.08.2014.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IsaaCloudConnector.h"


@interface InteriorViewController : UIViewController<ICCLoginDelegate, ICCRegistrationDelegate, ICCAdminTokenDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    
    IsaaCloudConnector *icc;
}


@property (nonatomic, strong) NSNumber *myData;

@end
