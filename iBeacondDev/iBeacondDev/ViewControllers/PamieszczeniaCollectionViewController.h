//
//  PamieszczeniaCollectionViewController.h
//  iGetResults
//
//  Created by mac on 07.08.2014.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import "IsaaCloudConnector.h"
//#import "BeaconManager.h"
#import "ICNotification.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
//#import "ESTBeaconManager.h"
//#import "ESTBeaconRegion.h"
#import "UserData.h"



@interface PamieszczeniaCollectionViewController : UICollectionViewController<ICCLoginDelegate, ICCRegistrationDelegate, ICCAdminTokenDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    NSArray *nameArray;
    NSArray *pomieszczeniaArray;
    
    NSNumber *idpomieszczenia;
    
    IsaaCloudConnector *icc;
    NSTimer *timer;
    
    UserData  *userData;
}




//@property (nonatomic, strong) ESTBeaconManager *beaconManager;
//@property (nonatomic, strong) ESTBeaconRegion *region;

@property (strong, nonatomic) IBOutlet UIImageView *interiorImage;
@property (strong, nonatomic) IBOutlet UILabel *interiorNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *liczbaOsobArray;


@end
