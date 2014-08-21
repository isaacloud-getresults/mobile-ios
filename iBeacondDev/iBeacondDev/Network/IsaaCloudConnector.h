//
//  IsaaCloudConnector.h
//  IsaaCloudExampleApp
//
//  Created by akl on 4/23/14.
//  Copyright (c) 2014 SoInteractive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "LoggedInUser.h"
#import "ICUser.h"
#import "ICNotification.h"
#import "JSONParser.h"
#import "HeaderParam.h"
#import "ICCondition.h"
#import "ICGame.h"
#import <CoreLocation/CoreLocation.h>

@protocol ICCSendEventDelegate <NSObject>
@required
-(void)sendEvent:(BOOL)success withError:(NSError*)error;
@end

@protocol ICCGetUserDelegate <NSObject>
@required
-(void)getUser:(ICUser*)user withError:(NSError*)error;
@end

@protocol ICCAdminTokenDelegate <NSObject>
@required
-(void)adminToken:(NSString*)adminToken withError:(NSError*)error;
@end

@protocol ICCLoginDelegate <NSObject>
@required
-(void)userLoggedInWithUid:(int)uid withError:(NSError*)error;
@end

@protocol ICCLogoutDelegate <NSObject>
@required
-(void)userLoggedOut:(BOOL)success withError:(NSError*)error;
@end

@protocol ICCRegistrationDelegate <NSObject>
@required
-(void)userRegisteredWithUid:(int)uid withError:(NSError*)error;
@end

static const int NO_ACTION = 0;
static const int ACTION_LOGIN_USER = 1;
static const int ACTION_LOGOUT_USER = 2;
static const int ACTION_REGISTER_USER = 3;
static const int GET_ADMIN_TOKEN = 4;
static const int GET_USER = 5;
static const int SEND_EVENT = 6;

@interface IsaaCloudConnector : NSObject<HttpClientDelegate>
{    
    NSString *accessToken;
    NSString *userId;
    LoggedInUser *loggedInUser;
    int action;
    int aid;
    int gid;
    NSString *token;
}

@property (nonatomic, weak) id<ICCSendEventDelegate> sendEventDelegate;
@property (nonatomic, weak) id<ICCGetUserDelegate> getUserDelegate;
@property (nonatomic, weak) id<ICCAdminTokenDelegate> adminTokenDelegate;
@property (nonatomic, weak) id<ICCLoginDelegate> loginDelegate;
@property (nonatomic, weak) id<ICCLogoutDelegate> logoutDelegate;
@property (nonatomic, weak) id<ICCRegistrationDelegate> registrationDelegate;

-(id)init;
-(void)sendPlaceEvent:(NSString*)proximityUUID;
-(void)sendEnterReginEvent:(NSString*)proximityUUID;
-(void)sendExitReginEvent:(NSString*)proximityUUID;
-(void)sendProximityChangedEvent:(CLBeacon*)beacon;
-(void)getAdminTokenAsync;
-(NSString*)getAdminTokenWithError:(NSError**)error;
-(NSArray*)getConditionsWithName:(NSString*)name withAdminToken:(NSString*)adminToken error:(NSError**)error;
-(NSNumber*)addCondition:(ICCondition*)condition withAdminToken:(NSString*)adminToken error:(NSError**)error;
-(NSArray*)getGamesWithName:(NSString*)name withAdminToken:(NSString*)adminToken error:(NSError**)error;
-(NSNumber*)addGame:(ICGame*)game withAdminToken:(NSString*)adminToken error:(NSError**)error;
-(NSNumber*)updateGameNotifications:(ICGame*)game withAdminToken:(NSString*)adminToken error:(NSError**)error;
-(ICNotification*)getNotificationById:(NSNumber*)notificationId withAdminToken:(NSString*)adminToken error:(NSError**)error;
-(NSNumber*)addNotification:(ICNotification*)notification withAdminToken:(NSString*)adminToken error:(NSError**)error;
-(NSNumber*)updateNotificationData:(ICNotification*)notification withAdminToken:(NSString*)adminToken error:(NSError**)error;
-(void)registerUserAsync:(NSString *)login password:(NSString *)pass withAdminToken:(NSString*)adminToken;
-(void)loginUserAsync:(NSString *)login password:(NSString *)pass;
-(void)logoutUserAsync:(int)uid;
-(void)updateFacebookProfileData:(NSString *)firstName lastname:(NSString *)lastName gender:(NSString *)gender birthday:(NSString *)birthday custumfields:(NSString *)customFields;
-(void)getUserAsync:(NSString*)uid;
-(NSString*)getAdminToken;
-(NSString*) getGroupsNameWithID:(NSNumber*)uid;
-(NSArray*)getNotifications;
-(NSArray*) getUsers;
-(NSString*) getMyselfName;
-(NSArray*) getInteriorsALL;
-(NSNumber*)getUserUID;
-(NSDictionary*) getUserWithUID:(NSNumber*)uid;
-(NSArray*) getNumberofUsers:(NSNumber*)uid;
//-(ICUser*) getUserWithICUserForm;
-(NSArray*)getUserWithName;
-(NSString*) getUserWithID:(NSNumber*)uid;
-(NSArray*) getInteriors;
-(void)sendLoginEvent;
-(UIImage*) getMyselfPhoto;
-(void)sendEnterKitchenEvent:(NSString*)proximityUUID;
-(NSMutableArray*) Notyficationsfrommy:(NSNumber*)userID;
@end
