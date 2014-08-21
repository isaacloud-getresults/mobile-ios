//
//  iPhoneViewController.h
//  iBeacondDev
//
//  Created by mac on 25.07.2014.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IsaaCloudConnector.h"
#import "ICNotification.h"
#import <CoreLocation/CoreLocation.h>

@interface iPhoneViewController : UIViewController<ICCLoginDelegate, ICCRegistrationDelegate, ICCAdminTokenDelegate,UITextFieldDelegate>
{
   
    IsaaCloudConnector *icc;
    
    NSDictionary *userDictionary;
   
    //BOOL endThread;
    //BOOL isForeground;
}

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;


@property (strong, nonatomic) IBOutlet UITextField *regemailTextField;
@property (strong, nonatomic) IBOutlet UITextField *regPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *genderTextField;

- (IBAction)loginUserButton:(id)sender;
- (IBAction)registerButtonPressed:(id)sender;
-(void)updateFacebookInformations;

@property (strong, nonatomic) IBOutlet UITextField *loginText;
@property (strong, nonatomic) IBOutlet UITextField *passwordText;
- (IBAction)loginButton:(id)sender;
- (IBAction)registerButton:(id)sender;
- (IBAction)loginTextDidEnd:(id)sender;
- (IBAction)passwordTextDidEnd:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)loaduserbutton:(id)sender;

@property (nonatomic, assign) id currentResponder;

- (IBAction)loginWithFacebookButton:(id)sender;

- (IBAction)registerWithFacebook:(id)sender;


-(void)toggleHiddenState:(BOOL)shouldHide;
@end
