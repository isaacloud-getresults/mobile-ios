//
//  ProfileViewController.h
//  iGetResults
//
//  Created by mac on 07.08.2014.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IsaaCloudConnector.h"
#import "UserData.h"


@interface MyselfProfileViewController : UIViewController<ICCLoginDelegate, ICCRegistrationDelegate, ICCAdminTokenDelegate>{
    
    NSDictionary* userData;
    NSNumber *liczba;
    NSArray *nameArray;
    IsaaCloudConnector *icc;
      NSArray *pomieszczeniaArray;
    
    UserData  *userformData;
    
}
@property (nonatomic, strong) NSNumber *myData;
@property (strong, nonatomic) IBOutlet UIImageView *profilePhoto;

@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;

@property (strong, nonatomic) IBOutlet UILabel *pointsLabel;
@property (strong, nonatomic) IBOutlet UILabel *wonGamesLabel;
@property (strong, nonatomic) IBOutlet UILabel *interiorLabel;



@end
