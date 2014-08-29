//
//  IsaaCloudConnector.m
//  IsaaCloudExampleApp
//
//  Created by akl on 4/23/14.
//  Copyright (c) 2014 SoInteractive. All rights reserved.
//

#import "IsaaCloudConnector.h"

@implementation IsaaCloudConnector

-(id)init
{
    loggedInUser = [LoggedInUser getInstance];
    action = NO_ACTION;
    [self loadConnectionParams];
    return self;
}

-(void)loadConnectionParams
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSObject *oGID = [defaults objectForKey:@"IC GID"];
    NSObject *oAID = [defaults objectForKey:@"IC AID"];
    NSObject *oT = [defaults objectForKey:@"IC Token"];
    if(oGID != nil && oAID != nil && oT != nil)
    {
        gid = [(NSNumber*)oGID intValue];
        aid = [(NSNumber*)oAID intValue];
        token = (NSString*)oT;
    }
    else
    {
       // NSString *pfile = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
       // NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:pfile];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"plist.plist"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath: path])
        {
            path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"plist.plist"] ];
        }
        
        
        
        
        NSMutableDictionary *data;
        
        if ([fileManager fileExistsAtPath: path])
        {
            data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
        }
        else
        {
            NSString *pfile = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
            data = [[NSMutableDictionary alloc] initWithContentsOfFile:pfile];
           
        }
        
    

        gid = [(NSNumber*)[data valueForKey:@"IC GID"] intValue];
        aid = [(NSNumber*)[data valueForKey:@"IC AID"] intValue];
        token = [data valueForKey:@"IC Token"];
        mobileID =[(NSNumber*)[data valueForKey:@"mobileNotification"] intValue];
    }
}

-(void)sendEnterReginEvent:(NSString*)proximityUUID
{
    if(loggedInUser.accesToken != nil)
    {
        NSString *body = [NSString stringWithFormat: @"{\"body\":{\"region\":\"enter\",\"proximityUUID\":\"%@\"},\"sourceId\":2,\"subjectType\":\"USER\",\"subjectId\":%d}",proximityUUID, loggedInUser.uid];
        [self sendEventAsyncWithBody:body];
    }
}

-(void)sendPlaceEvent:(NSString*)proximityUUID{
    if(loggedInUser.accesToken != nil)
    {
        NSString *body = [NSString stringWithFormat: @"{\"body\":{\"place\":\"%@\"},\"sourceId\":1,\"subjectType\":\"USER\",\"subjectId\":%d}",proximityUUID, loggedInUser.uid];
        [self sendEventAsyncWithBody:body];
        NSLog(@"%@",body);
        
    }
}

-(void)sendExitPlaceEvent:(NSString*)proximityUUID
{
    if(loggedInUser.accesToken != nil)
    {
        NSString *body = [NSString stringWithFormat: @"{\"body\":{\"place\":\"%@_exit\"},\"sourceId\":1,\"subjectType\":\"USER\",\"subjectId\":%d}",proximityUUID, loggedInUser.uid];
        [self sendEventAsyncWithBody:body];
    }
}



-(void)sendExitReginEvent:(NSString*)proximityUUID
{
    if(loggedInUser.accesToken != nil)
    {
        NSString *body = [NSString stringWithFormat: @"{\"body\":{\"region\":\"exit\",\"proximityUUID\":\"%@\"},\"sourceId\":2,\"subjectType\":\"USER\",\"subjectId\":%d}",proximityUUID, loggedInUser.uid];
        [self sendEventAsyncWithBody:body];
    }
}

-(void)sendLoginEvent
{
    if(loggedInUser.accesToken != nil)
    {
        NSString *body = [NSString stringWithFormat: @"{\"body\":{\"activity\":\"login\"},\"sourceId\":1,\"subjectType\":\"USER\",\"subjectId\":%d}", loggedInUser.uid];
        [self sendEventAsyncWithBody:body];
    }
}

-(void)sendProximityChangedEvent:(CLBeacon*)beacon
{
    if(loggedInUser.accesToken != nil)
    {
        NSString *distance = @"unknown";
        if([beacon proximity] == CLProximityImmediate)
        {
            distance = @"immediate";
        }
        else if([beacon proximity] == CLProximityNear)
        {
            distance = @"near";
        }
        else if([beacon proximity] == CLProximityFar)
        {
            distance = @"far";
        }
        //NSLog(@"M:%@ d:%@",[beacon minor],distance);
        NSString *body = [NSString stringWithFormat: @"{\"body\":{\"region\":\"%@\",\"major\":%@,\"minor\":%@,\"distance\":\"%@\"},\"sourceId\":2,\"subjectType\":\"USER\",\"subjectId\":%d}",[beacon.proximityUUID UUIDString], beacon.major, beacon.minor, distance, loggedInUser.uid];
        [self sendEventAsyncWithBody:body];
    }
}

-(void)sendEventAsyncWithBody:(NSString*)body
{
    action = SEND_EVENT;
    if(loggedInUser.accesToken == nil)
    {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"User not logged in." forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"ICError" code:1 userInfo:details];
        id<ICCGetUserDelegate> del = self.getUserDelegate;
        if([del respondsToSelector:@selector(getUser:withError:)])
            [del getUser:nil withError:error];
        return;
    }
    HttpClient *hc = [[HttpClient alloc] initWithDelegate:self];
    NSString *url = @"https://api.isaacloud.com/v1/queues/events";
    NSString *method = @"POST";
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:loggedInUser.accesToken] set:NO]];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Content-Type" withValue:@"text/json" set:YES]];
    [hc sendRequestAsync:url withHeaders:headers withBody:body withHTTPMethod:method];
}

-(NSNumber*)getUserUID{
    NSNumber *uid = [NSNumber numberWithInt:loggedInUser.uid];
    return uid;
}

-(void)getAdminTokenAsync
{
    action = GET_ADMIN_TOKEN;
    HttpClient *hc = [[HttpClient alloc] initWithDelegate:self];
    NSString *url = @"https://oauth.isaacloud.com/token";
    NSString *method = @"POST";
    NSString *body = @"grant_type=client_credentials";
    NSString *appToken = [NSString stringWithFormat: @"Basic %@", token];
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:appToken set:NO]];
    [hc sendRequestAsync:url withHeaders:headers withBody:body withHTTPMethod:method];
}


-(NSString*)getAdminToken
{
    action = GET_ADMIN_TOKEN;
    HttpClient *hc = [[HttpClient alloc] initWithDelegate:self];
    NSString *url = @"https://oauth.isaacloud.com/token";
    NSString *method = @"POST";
    NSString *body = @"grant_type=client_credentials";
    NSString *appToken = [NSString stringWithFormat: @"Basic %@", token];
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:appToken set:NO]];
    [hc sendRequestAsync:url withHeaders:headers withBody:body withHTTPMethod:method];
    NSError *err2 = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[hc responseData] options:kNilOptions error:&err2];
    NSString *at = [json objectForKey:@"access_token"];
    return at;
}


-(NSString*)getAdminTokenWithError:(NSError**)error
{
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = @"https://oauth.isaacloud.com/token";
    NSString *method = @"POST";
    NSString *body = @"grant_type=client_credentials";
    NSString *appToken = [NSString stringWithFormat: @"Basic %@", token];
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:appToken set:NO]];
    NSError *err;
    if([hc sendRequest:url withHeaders:headers withBody:body withHTTPMethod:method error:&err])
    {
        NSError *err2 = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[hc responseData] options:kNilOptions error:&err2];
        if(err2 == nil)
        {
            NSString *at = [json objectForKey:@"access_token"];
            if(at != nil)
            {
                return at;
            }
            else
            {
                NSMutableDictionary* details = [NSMutableDictionary dictionary];
                [details setValue:@"Permission denied." forKey:NSLocalizedDescriptionKey];
                *error = [NSError errorWithDomain:@"ICError" code:1 userInfo:details];
            }
        }
        else
        {
            *error = err2;
        }
    }
    else
    {
        *error = err;
    }
    return nil;
}

-(NSArray*)getConditionsWithName:(NSString*)name withAdminToken:(NSString*)adminToken error:(NSError**)error
{
    if(adminToken == nil)
    {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Permisiobn denied." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"ICError" code:1 userInfo:details];
        return nil;
    }
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = [NSString stringWithFormat:@"https://api.isaacloud.com/v1/admin/conditions?query=name:%@", name];
    NSString *method = @"GET";
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:adminToken] set:NO]];
    NSError *err;
    if([hc sendRequest:url withHeaders:headers withBody:nil withHTTPMethod:method error:&err])
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSError *err2 = nil;
        NSArray *json = [NSJSONSerialization JSONObjectWithData:[hc responseData] options:kNilOptions error:&err2];
        if(err2 == nil)
        {
            for(NSDictionary* d in json)
            {
                ICCondition *cond = (ICCondition*)[JSONParser createObjectFromJSON:d withClassName:@"ICCondition"];
                [array addObject:cond];
            }
            return array;
        }
        else
        {
            *error = err2;
        }
    }
    else
    {
        *error = err;
    }
    return nil;
}

-(NSNumber*)addCondition:(ICCondition*)condition withAdminToken:(NSString*)adminToken error:(NSError**)error
{
    if(adminToken == nil)
    {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Permisiobn denied." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"ICError" code:1 userInfo:details];
        return nil;
    }
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = @"https://api.isaacloud.com/v1/admin/conditions";
    NSString *method = @"POST";
    NSString *body = [NSString stringWithFormat: @"{\"name\":\"%@\",\"leftSide\":\"%@\",\"rightSide\":\"%@\",\"operator\":%d,\"conditiontype\":%d,\"transactionSource\":%d}", condition.name, condition.leftSide, condition.rightSide, [condition.operator intValue], [condition.conditionType intValue], [condition.transactionSource intValue]];
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:adminToken] set:NO]];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Content-Type" withValue:@"text/json" set:YES]];
    NSError *err;
    if([hc sendRequest:url withHeaders:headers withBody:body withHTTPMethod:method error:&err])
    {
        NSError *err2 = nil;
        NSArray *data = [NSJSONSerialization JSONObjectWithData:hc.responseData options:kNilOptions error:&err2];
        if(err2 == nil)
        {
            NSNumber *cid = [data valueForKey:@"id"];
            if(cid == nil)
            {
                NSMutableDictionary* details = [NSMutableDictionary dictionary];
                [details setValue:@"Cannot add condition." forKey:NSLocalizedDescriptionKey];
                *error = [NSError errorWithDomain:@"ICError" code:1 userInfo:details];
            }
            return cid;
        }
        else
        {
            *error = err2;
        }
    }
    else
    {
        *error = err;
    }
    return nil;
}

-(NSArray*)getGamesWithName:(NSString*)name withAdminToken:(NSString*)adminToken error:(NSError**)error
{
    if(adminToken == nil)
    {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Permisiobn denied." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"ICError" code:1 userInfo:details];
        return nil;
    }
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = [NSString stringWithFormat:@"https://api.isaacloud.com/v1/admin/games?query=name:%@", name];
    NSString *method = @"GET";
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:adminToken] set:NO]];
    NSError *err;
    if([hc sendRequest:url withHeaders:headers withBody:nil withHTTPMethod:method error:&err])
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSError *err2 = nil;
        NSArray *json = [NSJSONSerialization JSONObjectWithData:[hc responseData] options:kNilOptions error:&err2];
        if(err2 == nil)
        {
            for(NSDictionary* d in json)
            {
                ICGame *game = (ICGame*)[JSONParser createObjectFromJSON:d withClassName:@"ICGame"];
                [array addObject:game];
            }
            return array;
        }
        else
        {
            *error = err2;
        }
    }
    else
    {
        *error = err;
    }
    return nil;
}

-(NSNumber*)addGame:(ICGame*)game withAdminToken:(NSString*)adminToken error:(NSError**)error
{
    if(adminToken == nil)
    {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Permisiobn denied." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"ICError" code:1 userInfo:details];
        return nil;
    }
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = @"https://api.isaacloud.com/v1/admin/games";
    NSString *method = @"POST";
    NSString *body = [NSString stringWithFormat: @"{\"name\":\"%@\",\"expression\":\"%@\",\"gameType\":%d,\"active\":%d,\"conditions\":%@,\"transactionSource\":%d}", game.name, game.expression, [game.gameType intValue], [game.active intValue], [JSONParser arrayToJSON:game.conditions], [game.transactionSource intValue]];
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:adminToken] set:NO]];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Content-Type" withValue:@"text/json" set:YES]];
    NSError *err;
    if([hc sendRequest:url withHeaders:headers withBody:body withHTTPMethod:method error:&err])
    {
        NSError *err2 = nil;
        NSArray *data = [NSJSONSerialization JSONObjectWithData:hc.responseData options:kNilOptions error:&err2];
        if(err2 == nil)
        {
            NSNumber *gameid = [data valueForKey:@"id"];
            if(gameid == nil)
            {
                NSMutableDictionary* details = [NSMutableDictionary dictionary];
                [details setValue:@"Cannot add condition." forKey:NSLocalizedDescriptionKey];
                *error = [NSError errorWithDomain:@"ICError" code:1 userInfo:details];
            }
            return gameid;
        }
        else
        {
            *error = err2;
        }
    }
    else
    {
        *error = err;
    }
    return nil;
}

-(NSNumber*)updateGameNotifications:(ICGame*)game withAdminToken:(NSString*)adminToken error:(NSError**)error
{
    if(adminToken == nil)
    {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Permisiobn denied." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"ICError" code:1 userInfo:details];
        return nil;
    }
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = [NSString stringWithFormat: @"https://api.isaacloud.com/v1/admin/games/%d", [game.id intValue]];
    NSString *method = @"PUT";
    NSString *body = [NSString stringWithFormat: @"{\"notifications\":%@}", [JSONParser arrayToJSON:game.notifications]];
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:adminToken] set:NO]];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Content-Type" withValue:@"text/json" set:YES]];
    NSError *err;
    if([hc sendRequest:url withHeaders:headers withBody:body withHTTPMethod:method error:&err])
    {
        NSError *err2 = nil;
        NSArray *data = [NSJSONSerialization JSONObjectWithData:hc.responseData options:kNilOptions error:&err2];
        if(err2 == nil)
        {
            NSNumber *gameid = [data valueForKey:@"id"];
            if(gameid == nil)
            {
                NSMutableDictionary* details = [NSMutableDictionary dictionary];
                [details setValue:@"Cannot add condition." forKey:NSLocalizedDescriptionKey];
                *error = [NSError errorWithDomain:@"ICError" code:1 userInfo:details];
            }
            return gameid;
        }
        else
        {
            *error = err2;
        }
    }
    else
    {
        *error = err;
    }
    return nil;
}

-(ICNotification*)getNotificationById:(NSNumber*)notificationId withAdminToken:(NSString*)adminToken error:(NSError**)error
{
    if(adminToken == nil)
    {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Permisiobn denied." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"ICError" code:1 userInfo:details];
        return nil;
    }
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = [NSString stringWithFormat:@"https://api.isaacloud.com/v1/admin/notifications/%d", [notificationId intValue]];
    NSString *method = @"GET";
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:adminToken] set:NO]];
    NSError *err;
    if([hc sendRequest:url withHeaders:headers withBody:nil withHTTPMethod:method error:&err])
    {
        NSError *err2 = nil;
        ICNotification *notification = (ICNotification*)[JSONParser createObjectFromData:hc.responseData withClassName:@"ICNotification" error:&err2];
        if(err2 == nil)
        {
            return notification;
        }
        else
        {
            *error = err2;
        }
    }
    else
    {
        *error = err;
    }
    return nil;
}

-(NSNumber*)addNotification:(ICNotification*)notification withAdminToken:(NSString*)adminToken error:(NSError**)error
{
    if(adminToken == nil)
    {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Permisiobn denied." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"ICError" code:1 userInfo:details];
        return nil;
    }
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = @"https://api.isaacloud.com/v1/admin/notifications";
    NSString *method = @"POST";
    NSString *body = [NSString stringWithFormat: @"{\"data\":%@,\"notificationType\":%d,\"game\":%@}",[JSONParser dictionaryToJSON:notification.data], [notification.notificationType intValue], [JSONParser arrayToJSON:notification.game]];
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:adminToken] set:NO]];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Content-Type" withValue:@"text/json" set:YES]];
    NSError *err;
    if([hc sendRequest:url withHeaders:headers withBody:body withHTTPMethod:method error:&err])
    {
        NSError *err2 = nil;
        NSArray *data = [NSJSONSerialization JSONObjectWithData:hc.responseData options:kNilOptions error:&err2];
        if(err2 == nil)
        {
            NSNumber *nId = [data valueForKey:@"id"];
            if(nId == nil)
            {
                NSMutableDictionary* details = [NSMutableDictionary dictionary];
                [details setValue:@"Cannot add condition." forKey:NSLocalizedDescriptionKey];
                *error = [NSError errorWithDomain:@"ICError" code:1 userInfo:details];
            }
            return nId;
        }
        else
        {
            *error = err2;
        }
    }
    else
    {
        *error = err;
    }
    return nil;
}

-(NSNumber*)updateNotificationData:(ICNotification*)notification withAdminToken:(NSString*)adminToken error:(NSError**)error
{
    
    
    
    if(adminToken == nil)
    {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Permisiobn denied." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"ICError" code:1 userInfo:details];
        return nil;
    }
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = [NSString stringWithFormat: @"https://api.isaacloud.com/v1/admin/notifications/%d", [notification.id intValue]];
    NSString *method = @"PUT";
    NSString *body = [NSString stringWithFormat: @"{\"data\":%@}",[JSONParser dictionaryToJSON:notification.data]];
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:adminToken] set:NO]];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Content-Type" withValue:@"text/json" set:YES]];
    NSError *err;
    if([hc sendRequest:url withHeaders:headers withBody:body withHTTPMethod:method error:&err])
    {
        NSError *err2 = nil;
        NSArray *data = [NSJSONSerialization JSONObjectWithData:hc.responseData options:kNilOptions error:&err2];
        if(err2 == nil)
        {
            NSNumber *nId = [data valueForKey:@"id"];
            if(nId == nil)
            {
                NSMutableDictionary* details = [NSMutableDictionary dictionary];
                [details setValue:@"Cannot add condition." forKey:NSLocalizedDescriptionKey];
                *error = [NSError errorWithDomain:@"ICError" code:1 userInfo:details];
            }
            return nId;
        }
        else
        {
            *error = err2;
        }
    }
    else
    {
        *error = err;
    }
    return nil;
}

-(void)registerUserAsync:(NSString *)login password:(NSString *)pass withAdminToken:(NSString*)adminToken
{
    if(adminToken == nil)
    {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Permisiobn denied." forKey:NSLocalizedDescriptionKey];
        NSError *err = [NSError errorWithDomain:@"ICError" code:1 userInfo:details];
        id<ICCRegistrationDelegate> del = self.registrationDelegate;
        if([del respondsToSelector:@selector(userRegisteredWithUid:withError:)])
            [del userRegisteredWithUid:-1 withError:err];
        return;
    }
    action = ACTION_REGISTER_USER;
    HttpClient *hc = [[HttpClient alloc] initWithDelegate:self];
    NSString *url = @"https://api.isaacloud.com/v1/admin/users";
    NSString *method = @"POST";
    NSString *body = [NSString stringWithFormat: @"{\"email\":\"%@\",\"password\":\"%@\",\"gender\":0,\"status\":1,\"role\":\"user\"}", login, pass];
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:adminToken] set:NO]];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Content-Type" withValue:@"text/json" set:YES]];
    [hc sendRequestAsync:url withHeaders:headers withBody:body withHTTPMethod:method];
}


-(void)updateFacebookProfileData:(NSString *)firstName lastname:(NSString *)lastName gender:(NSString *)gender birthday:(NSString *)birthday custumfields:(NSString *)customFields
{
    
    NSString *admintoken = [self getAdminTokenWithError:nil];
    
    
    NSLog(@"%@",admintoken);
    
    if(admintoken == nil)
    {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Permisiobn denied." forKey:NSLocalizedDescriptionKey];
    }
    HttpClient *hc = [[HttpClient alloc] initWithDelegate:self];
    NSString *url = [NSString stringWithFormat: @"https://api.isaacloud.com/v1/admin/users/%d",loggedInUser.uid];
    
    NSLog(@"%@",url);
    
    NSString *method = @"PUT";
    NSString *body = [NSString stringWithFormat: @"{\"firstName\":\"%@\",\"lastName\":\"%@\",\"gender\":\"%@\",\"birthDate\":\"%@\",\"customFields\":{\"facebookPhoto\":\"%@\"}}", firstName, lastName,gender,birthday,customFields];
    
    NSLog(@"%@",body);
    
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:admintoken] set:NO]];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Content-Type" withValue:@"text/json" set:YES]];
    
    [hc sendRequestAsync:url withHeaders:headers withBody:body withHTTPMethod:method];
    

    NSData* data = [hc responseData];
     NSError *err2 = nil;
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err2];
    
    NSLog(@"%@",array);
    
    
}




-(void)loginUserAsync:(NSString *)login password:(NSString *)pass
{
    action = ACTION_LOGIN_USER;
    accessToken = nil;
    userId = nil;
    HttpClient *hc = [[HttpClient  alloc] initWithDelegate:self];
    NSString *url = [NSString stringWithFormat: @"https://oauth.isaacloud.com/signin?aid=%d&gid=%d&origin=isaacloud.com&sdk=ios", aid, gid];
    NSString *method = @"POST";
    NSString *body = [NSString stringWithFormat: @"email=%@&password=%@", login, pass];
    [hc sendRequestAsync:url withHeaders:nil withBody:body withHTTPMethod:method];
}

-(void)logoutUserAsync:(int)uid
{
    action = ACTION_LOGOUT_USER;
    HttpClient *hc = [[HttpClient alloc] initWithDelegate:self];
    NSString *url = [NSString stringWithFormat:@"https://oauth.isaacloud.com/logout?m=%d&g=%d&u=%d", aid, gid, uid];
    NSString *method = @"GET";
    [hc sendRequestAsync:url withHeaders:nil withBody:nil withHTTPMethod:method];
}

-(void)getUserAsync:(NSString*)uid
{
    action = GET_USER;
    if(loggedInUser.accesToken == nil)
    {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"User not logged in." forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"ICError" code:1 userInfo:details];
        id<ICCGetUserDelegate> del = self.getUserDelegate;
        if([del respondsToSelector:@selector(getUser:withError:)])
            [del getUser:nil withError:error];
        return;
    }
    HttpClient *hc = [[HttpClient alloc] initWithDelegate:self];
    NSString *url = [NSString stringWithFormat: @"https://api.isaacloud.com/v1/cache/users/%@", uid];
    NSString *method = @"GET";
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:loggedInUser.accesToken] set:NO]];
    [hc sendRequestAsync:url withHeaders:headers withBody:nil withHTTPMethod:method];
}
/*
-(ICUser*) getUserWithUid:(NSString*)uid error:(NSError**)error
{
    if(loggedInUser.accesToken == nil)
    {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"User not logged in." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"ICError" code:1 userInfo:details];
        return nil;
    }
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = [NSString stringWithFormat: @"https://api.isaacloud.com/v1/cache/users/%@", uid];
    NSString *method = @"GET";
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:loggedInUser.accesToken] set:NO]];
    NSError *err1 = nil;
    if([hc sendRequest:url withHeaders:headers withBody:nil withHTTPMethod:method error:&err1])
    {
        NSError *err2 = nil;
        ICUser *user = (ICUser*)[JSONParser createObjectFromData:hc.responseData withClassName:@"ICUser" error:&err2];
        if(user != nil)
        {
            return user;
        }
        else
        {
            *error = err2;
        }
    }
    else
    {
        *error = err1;
    }
    return nil;
}
 */

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




-(NSArray*) getUsers
{
    
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = [NSString stringWithFormat: @"https://api.isaacloud.com/v1/cache/users?limit=0&custom=true"];
    NSString *method = @"GET";
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:loggedInUser.accesToken] set:NO]];
    NSError *err1 = nil;

    [hc sendRequest:url withHeaders:headers withBody:nil withHTTPMethod:method error:&err1];

        NSError *err2 = nil;
    
    NSData* data = [hc responseData];
    
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err2];
    if(array)
    {
    
    for (int i = 0; [array count] > i; i++) {
        if ([[[array objectAtIndex:i]objectForKey:@"id"] intValue] == loggedInUser.uid) {
           meArray = [array objectAtIndex:i];
            //NSLog(@"%@",meArray);
            break;
        }
    }
    }
    else
    {
        return array;
    }
       return array;

}

-(NSDictionary*)getMyselfData{
    return meArray;
}




-(NSArray*) getUsersIDs
{
    
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = [NSString stringWithFormat: @"https://api.isaacloud.com/v1/cache/users?limit=0&fields=id"];
    NSString *method = @"GET";
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:loggedInUser.accesToken] set:NO]];
    NSError *err1 = nil;
    
    [hc sendRequest:url withHeaders:headers withBody:nil withHTTPMethod:method error:&err1];
    
    NSError *err2 = nil;
    
    NSData* data = [hc responseData];
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err2];
    
    
    
    
    
    
    return array;
    
}



-(NSString*) getMyselfName{
    
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = [NSString stringWithFormat: @"https://api.isaacloud.com/v1/cache/users/%d?fields=firstName%%2ClastName",loggedInUser.uid];
    NSString *method = @"GET";
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:loggedInUser.accesToken] set:NO]];
    NSError *err1 = nil;
    
    [hc sendRequest:url withHeaders:headers withBody:nil withHTTPMethod:method error:&err1];
    
    NSError *err2 = nil;
    
    NSData* data = [hc responseData];
    
    NSDictionary *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err2];
    
    NSString *imie;
    NSString *nazwisko;
    
    NSString * value = [array objectForKey:@"firstName"];
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        
        imie = @"Nemo";
    }
    else{
        imie = value;
    }
    
    NSString * value2 = [array objectForKey:@"lastName"];
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        nazwisko  = @"Nobody";
    }
    else{
        nazwisko = value2;
    }

    NSString *wynik = [NSString stringWithFormat:@"%@ %@",imie,nazwisko];
    
    
    
    return wynik;
    
}

-(NSString*) getMyselfInterior{
    
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = [NSString stringWithFormat: @"https://api.isaacloud.com/v1/cache/users/%d?fields=counterValues",loggedInUser.uid];
    NSString *method = @"GET";
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:loggedInUser.accesToken] set:NO]];
    NSError *err1 = nil;
    
    [hc sendRequest:url withHeaders:headers withBody:nil withHTTPMethod:method error:&err1];
    
    NSError *err2 = nil;
    
    NSData* data = [hc responseData];
    
    NSDictionary *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err2];
    
    
    NSNumber *valueOfCounter = [[NSNumber alloc]init];
    
    NSLog(@"%@",[array objectForKey:@"counterValues"]);
    for (int i = 0; [[array objectForKey:@"counterValues"]count] > i; i++) {
        //  NSLog(@"%@",[[[userData objectForKey:@"counterValues"]objectAtIndex:i]objectForKey:@"counter"]);
        
        if ([[[[array objectForKey:@"counterValues"]objectAtIndex:i]objectForKey:@"counter"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            valueOfCounter = [[[array objectForKey:@"counterValues"]objectAtIndex:i]objectForKey:@"value"];
        }
    }
    
    
    NSString *pomieszczenie = [self getGroupsNameWithID:valueOfCounter];
    
    return pomieszczenie;
    
}

-(NSString*) getUserInteriorwithID:(NSNumber*)uid{
    
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = [NSString stringWithFormat: @"https://api.isaacloud.com/v1/cache/users/%@?fields=counterValues",uid];
    NSString *method = @"GET";
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:loggedInUser.accesToken] set:NO]];
    NSError *err1 = nil;
    
    [hc sendRequest:url withHeaders:headers withBody:nil withHTTPMethod:method error:&err1];
    
    NSError *err2 = nil;
    
    NSData* data = [hc responseData];
    
    NSDictionary *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err2];
    
    
    NSNumber *valueOfCounter = [[NSNumber alloc]init];
    
    NSLog(@"%@",[array objectForKey:@"counterValues"]);
    for (int i = 0; [[array objectForKey:@"counterValues"]count] > i; i++) {
        //  NSLog(@"%@",[[[userData objectForKey:@"counterValues"]objectAtIndex:i]objectForKey:@"counter"]);
        
        if ([[[[array objectForKey:@"counterValues"]objectAtIndex:i]objectForKey:@"counter"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            valueOfCounter = [[[array objectForKey:@"counterValues"]objectAtIndex:i]objectForKey:@"value"];
        }
    }
    
    
    NSString *pomieszczenie = [self getGroupsNameWithID:valueOfCounter];
    
    return pomieszczenie;
    
}

-(NSString*) getUserInfoWithID:(NSNumber*)uid{
    
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = [NSString stringWithFormat: @"https://api.isaacloud.com/v1/cache/users/%@?fields=firstName%%2ClastName",uid];
    NSString *method = @"GET";
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:loggedInUser.accesToken] set:NO]];
    NSError *err1 = nil;
    
    [hc sendRequest:url withHeaders:headers withBody:nil withHTTPMethod:method error:&err1];
    
    NSError *err2 = nil;
    
    NSData* data = [hc responseData];
    
    NSDictionary *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err2];
    
    NSString *imie;
    NSString *nazwisko;
    
    NSString * value = [array objectForKey:@"firstName"];
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        
        imie = @"Nemo";
    }
    else{
        imie = value;
    }
    
    NSString * value2 = [array objectForKey:@"lastName"];
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        nazwisko  = @"Nobody";
    }
    else{
        nazwisko = value2;
    }
    
    NSString *wynik = [NSString stringWithFormat:@"%@ %@",imie,nazwisko];
    
    
    
    return wynik;
    
}








-(NSString*) getUserWithID:(NSNumber*)uid{
    
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = [NSString stringWithFormat: @"https://api.isaacloud.com/v1/cache/users/%@?fields=firstName%%2ClastName",uid];
    NSString *method = @"GET";
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:loggedInUser.accesToken] set:NO]];
    NSError *err1 = nil;
    
    [hc sendRequest:url withHeaders:headers withBody:nil withHTTPMethod:method error:&err1];
    
    NSError *err2 = nil;
    
    NSData* data = [hc responseData];
    
    NSDictionary *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err2];
    
    NSString *imie;
    NSString *nazwisko;
    
    NSString * value = [array objectForKey:@"firstName"];
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        
        imie = @"Nemo";
    }
    else{
        imie = value;
    }
    
    NSString * value2 = [array objectForKey:@"lastName"];
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        nazwisko  = @"Nobody";
    }
    else{
        nazwisko = value2;
    }
    
    NSString *wynik = [NSString stringWithFormat:@"%@ %@",imie,nazwisko];
    
    
    
    return wynik;
    
}



-(UIImage*) getMyselfPhoto{
    
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = [NSString stringWithFormat: @"https://api.isaacloud.com/v1/cache/users/%d?fields=custom&custom=true",loggedInUser.uid];
    NSString *method = @"GET";
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:loggedInUser.accesToken] set:NO]];
    NSError *err1 = nil;
    
    [hc sendRequest:url withHeaders:headers withBody:nil withHTTPMethod:method error:&err1];
    
    NSError *err2 = nil;
    
    NSData* data = [hc responseData];
    
    UIImage *imagetoto = [[UIImage alloc]init];
    NSDictionary *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err2];
    if ([[array objectForKey:@"custom"] count] != 0 ){
        
        //[[userData objectForKey:@"custom"]objectForKey:@"facebookPhoto"];
        imagetoto = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:[[array objectForKey:@"custom"]objectForKey:@"facebookPhoto"]]]];
        
    }else{
        imagetoto = [UIImage imageNamed:@"111-user-icon.png"];
        
    }


    
    return imagetoto;
    
}

-(UIImage*) getUserPhotoWithID:(NSNumber*)uid{
    
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = [NSString stringWithFormat: @"https://api.isaacloud.com/v1/cache/users/%@?fields=custom&custom=true",uid];
    NSString *method = @"GET";
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:loggedInUser.accesToken] set:NO]];
    NSError *err1 = nil;
    
    [hc sendRequest:url withHeaders:headers withBody:nil withHTTPMethod:method error:&err1];
    
    NSError *err2 = nil;
    
    NSData* data = [hc responseData];
    
    UIImage *imagetoto = [[UIImage alloc]init];
    NSDictionary *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err2];
    if ([[array objectForKey:@"custom"] count] != 0 ){
        
        //[[userData objectForKey:@"custom"]objectForKey:@"facebookPhoto"];
        imagetoto = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:[[array objectForKey:@"custom"]objectForKey:@"facebookPhoto"]]]];
        
    }else{
        imagetoto = [UIImage imageNamed:@"111-user-icon.png"];
        
    }
    
    
    
    return imagetoto;
    
}







-(NSArray*) getNumberofUsers:(NSNumber*)uid{
    
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = [NSString stringWithFormat: @"https://api.isaacloud.com/v1/cache/users?limit=0&fields=counterValues"];
    NSString *method = @"GET";
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:loggedInUser.accesToken] set:NO]];
    NSError *err1 = nil;
    
    [hc sendRequest:url withHeaders:headers withBody:nil withHTTPMethod:method error:&err1];
    
    NSError *err2 = nil;
    
    NSData* data = [hc responseData];
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err2];
    
    NSMutableArray *array2 = [[NSMutableArray alloc] init];
    
  //  NSNumber *valueOfCounter;
   // int wynik = 0;
    
    for (int i = 0; [array count]>i; i++) {
        
        
        
        // NSLog(@"%@",[userData objectForKey:@"counterValues"]);
        for (int x = 0; [[[array objectAtIndex:i]objectForKey:@"counterValues"]count] > x; x++) {
            
            if ([[[[[array objectAtIndex:i] objectForKey:@"counterValues"]objectAtIndex:x]objectForKey:@"counter"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                if ([[[[[array objectAtIndex:i] objectForKey:@"counterValues"]objectAtIndex:x]objectForKey:@"value"] isEqualToNumber:uid]) {
                    [array2 addObject:[[array objectAtIndex:i] objectForKey:@"id"]];
                    
                    //NSLog(@"%@",[[array objectAtIndex:i] objectForKey:@"id"]);
                }
            }
        }
        
    }
// valueOfCounter = [NSNumber numberWithInt:wynik];
   // return valueOfCounter;
    return array2;
}





////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(NSDictionary*) getUserWithUID:(NSNumber*)uid
{
    
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = [NSString stringWithFormat: @"https://api.isaacloud.com/v1/cache/users/%@?custom=true",uid];
    NSString *method = @"GET";
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:loggedInUser.accesToken] set:NO]];
    NSError *err1 = nil;
    
    [hc sendRequest:url withHeaders:headers withBody:nil withHTTPMethod:method error:&err1];
    
    NSError *err2 = nil;
    
    NSData* data = [hc responseData];
    
    NSDictionary *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err2];
    
 //  NSLog(@"%@",[array objectForKey:@"email"]);
    
    
  //  NSMutableArray *array2 = [[NSMutableArray alloc]init];
  
    
   // NSLog(@"%@",array2);
    
    
   // NSLog(@"%lu",(unsigned long)[array count]);
    
    
   // NSLog(@"%@",[array objectAtIndexedSubscript:5]);
    
    
  /*
    for(int i=0;i<[array count];i++)
    {
        NSLog(@"%@",[array]);
        
        //NSLog(@"%@",[[array objectAtIndex:i]objectForKey:@"email"]);
        
    }
*/
    
    
    return array;
    
}




-(NSString*) getGroupsNameWithID:(NSNumber*)uid
{
    
    
    // https://api.isaacloud.com/v1/cache/users/10?fields=counterValues
    
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = [NSString stringWithFormat: @"https://api.isaacloud.com/v1/cache/users/groups/%@?fields=label",uid];
    NSString *method = @"GET";
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:loggedInUser.accesToken] set:NO]];
    NSError *err1 = nil;
    
    [hc sendRequest:url withHeaders:headers withBody:nil withHTTPMethod:method error:&err1];
    
    NSError *err2 = nil;
    
    NSData* data = [hc responseData];
    
    NSDictionary *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err2];
    
    
    //NSLog(@"%@",array);
 
      NSString *nazwa = [array objectForKey:@"label"];
    
    
    //SLog(@"%@",nazwa1);
    
    
    //  NSLog(@"%@",[array objectForKey:@"email"]);
    
    
    //  NSMutableArray *array2 = [[NSMutableArray alloc]init];
    
    
    // NSLog(@"%@",array2);
    
    
    // NSLog(@"%lu",(unsigned long)[array count]);
    
    
    // NSLog(@"%@",[array objectAtIndexedSubscript:5]);
    
    
    /*
     for(int i=0;i<[array count];i++)
     {
     NSLog(@"%@",[array]);
     
     //NSLog(@"%@",[[array objectAtIndex:i]objectForKey:@"email"]);
     
     }
     */
    
  
    return nazwa;
    
}


-(NSArray*) getInteriorsALL
{
    
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = [NSString stringWithFormat: @"https://api.isaacloud.com/v1/admin/users/groups/3/customfields"];
    NSString *method = @"GET";
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:loggedInUser.accesToken] set:NO]];
    NSError *err1 = nil;
    
    
    [hc sendRequest:url withHeaders:headers withBody:nil withHTTPMethod:method error:&err1];
    
    
    NSError *err2 = nil;
    
    NSData* data = [hc responseData];
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err2];
    
    
    
    return array;
    
    
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(NSArray*) getInteriors
{
    
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = [NSString stringWithFormat: @"https://api.isaacloud.com/v1/cache/users/groups?fields=label%%2CcounterValues"];
    NSString *method = @"GET";
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:loggedInUser.accesToken] set:NO]];
    NSError *err1 = nil;
    
    
    [hc sendRequest:url withHeaders:headers withBody:nil withHTTPMethod:method error:&err1];
    
    
    NSError *err2 = nil;
    
    NSData* data = [hc responseData];
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err2];
    
        
   
    return array;
    
    
}

-(NSArray*) getAchievements
{
    
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = [NSString stringWithFormat: @"https://api.isaacloud.com/v1/cache/users/%d/achievements",loggedInUser.uid];
    NSString *method = @"GET";
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:loggedInUser.accesToken] set:NO]];
    NSError *err1 = nil;
    
    
    [hc sendRequest:url withHeaders:headers withBody:nil withHTTPMethod:method error:&err1];
    
    
    NSError *err2 = nil;
    
    NSData* data = [hc responseData];
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err2];
    
    
    
    return array;
   // https://api.isaacloud.com/v1/cache/users/groups/4/achievements
    
}


-(NSArray*) getInterirorAchievements:(NSNumber*)uid
{
    
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = [NSString stringWithFormat: @"https://api.isaacloud.com/v1/cache/users/groups/%@/achievements",uid];
    NSString *method = @"GET";
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:loggedInUser.accesToken] set:NO]];
    NSError *err1 = nil;
    
    
    [hc sendRequest:url withHeaders:headers withBody:nil withHTTPMethod:method error:&err1];
    
    
    NSError *err2 = nil;
    
    NSData* data = [hc responseData];
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err2];
    
    
    
    return array;
    
}




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/*
-(NSArray*) getUserWithICUserForm
{
    if(adminToken == nil)
    {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Permisiobn denied." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"ICError" code:1 userInfo:details];
        return nil;
    }
    
    
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = [NSString stringWithFormat: @"https://api.isaacloud.com/v1/cache/users/1"];
    NSString *method = @"GET";
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:loggedInUser.accesToken] set:NO]];
    NSError *err1 = nil;
    
    
    if([hc sendRequest:url withHeaders:headers withBody:nil withHTTPMethod:method error:&err1])
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSError *err2 = nil;
        NSArray *json = [NSJSONSerialization JSONObjectWithData:[hc responseData] options:kNilOptions error:&err2];
        if(err2 == nil)
        {
            for(NSDictionary* d in json)
            {
                ICCondition *cond = (ICCondition*)[JSONParser createObjectFromJSON:d withClassName:@"ICCondition"];
                [array addObject:cond];
            }
            return array;
        }
        else
        {
            *error = err2;
        }
    }
    else
    {
        *error = err1;
    }
    return nil;
    
    
}

*/

-(NSArray*)getUserWithName
{
        HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = [NSString stringWithFormat:@"https://api.isaacloud.com/v1/cache/users/1"];
    NSString *method = @"GET";
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:loggedInUser.accesToken] set:NO]];
    NSError *err;
    if([hc sendRequest:url withHeaders:headers withBody:nil withHTTPMethod:method error:&err])
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSError *err2 = nil;
        NSArray *json = [NSJSONSerialization JSONObjectWithData:[hc responseData] options:kNilOptions error:&err2];
        if(err2 == nil)
        {
            for(NSDictionary* d in json)
            {
                NSArray *user = (NSArray*)[JSONParser createObjectFromJSON:d withClassName:@"NSArray"];
                [array addObject:user];
            }
            return array;
        }
        else
        {
            
        }
    }
    else
    {
        
    }
    return nil;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(NSMutableArray*) Notyficationsfrommy:(NSNumber*)userID{
    
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = [NSString stringWithFormat: @"https://api.isaacloud.com/v1/queues/notifications?limit=10&fields=data%%2CsubjectId"];
    
    NSString *method = @"GET";
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:loggedInUser.accesToken] set:NO]];
    NSError *err1 = nil;
    
    
    [hc sendRequest:url withHeaders:headers withBody:nil withHTTPMethod:method error:&err1];
    
    
    NSError *err2 = nil;
    
    NSData* data = [hc responseData];
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err2];
    NSMutableArray *array2 = [[NSMutableArray alloc]init];
    
    NSLog(@"%@",array);
    
    
    NSNumber *userid = userID;
    for(int i=0;i<[array count];i++)
    {
       // NSLog(@"%d",[[[array objectAtIndex:i]objectForKey:@"subjectId"]isEqualToNumber:userid]);
        if ([[[array objectAtIndex:i]objectForKey:@"subjectId"]isEqualToNumber:userid]) {
            // NSLog(@"%@",[[array objectAtIndex:i]objectForKey:@"subjectId"]);
             [array2 addObject:[[[[array objectAtIndex:i]objectForKey:@"data"]objectForKey:@"body"] objectForKey:@"message"]];
            [self setNotificationStatusDone:[[array objectAtIndex:i]objectForKey:@"id"]];
        }
     //  NSLog(@"%@",[[array objectAtIndex:i]objectForKey:@"subjectId"]);
       // [array2 addObject:[[[[array objectAtIndex:i]objectForKey:@"data"]objectForKey:@"body"] objectForKey:@"message"]];
        
    }
    
    
    return array2;
    
    
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(NSArray*)getNotifications
{
    //NSLog(@"getNotifications");
    NSMutableArray *notifications = [[NSMutableArray alloc] init];
    
    if(loggedInUser.accesToken == nil)
    {
        NSLog(@"token = nil!");
        return nil;
    }
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = [NSString stringWithFormat: @"https://api.isaacloud.com/v1/queues/notifications?limit=50&order=id%%3ADESC"];
    NSString *method = @"GET";
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:loggedInUser.accesToken] set:NO]];
    NSError *err1 = nil;
    if([hc sendRequest:url withHeaders:headers withBody:nil withHTTPMethod:method error:&err1])
    {
        NSError *err2 = nil;
        NSArray *data = [NSJSONSerialization JSONObjectWithData:hc.responseData options:kNilOptions error:&err2];
      //  NSLog(@"data: %@", data);
        
        
        for(NSDictionary* n in data)
        {
            //  NSLog(@"data : %@", data);
            
            if([[n valueForKey:@"typeId"] intValue] == 1)
            {
                
                NSLog(@"%@",[n valueForKey:@"typeId"]);
                notyficationsArray = data;
                
            }
        }
        
     
        if(err2 == nil)
        {
          //  NSLog(@"err2 == nil");
            for(NSDictionary* n in data)
            {
              //  NSLog(@"data : %@", data);
           
                if(([[n valueForKey:@"subjectId"] intValue] == loggedInUser.uid) && ([[n valueForKey:@"status"] intValue] == 0 ) && ([[n valueForKey:@"typeId"] intValue] == mobileID ))
                {
                    ICNotification *notification = (ICNotification*)[JSONParser createObjectFromJSON:n withClassName:@"ICNotification"];
                    [notifications addObject:notification];
                    [self setNotificationStatusDone:[n valueForKey:@"id"]];
                    NSLog(@"notification : %@", [n valueForKey:@"data"]);
                  //  NSLog(@"notification : %@ %@ %@ ", notification.id, notification.game, notification.data);
                }
            }
            //NSLog(@"Notifications %d",[notifications count]);
            return notifications;
        }
    }
    return nil;
}


-(NSArray*)getNotificationsArray{
    return notyficationsArray;
}

-(void)setNotificationStatusDone:(NSString*)notificationId
{
    if(loggedInUser.accesToken == nil)
    {
        return;
    }
    HttpClient *hc = [[HttpClient alloc] init];
    NSString *url = [NSString stringWithFormat: @"https://api.isaacloud.com/v1/queues/notifications/%@", notificationId];
    NSString *method = @"PUT";
    NSString *body = [NSString stringWithFormat: @"{\"status\":\"STATUS_DONE\"}"];
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Authorization" withValue:[@"Bearer " stringByAppendingString:loggedInUser.accesToken] set:NO]];
    [headers addObject:[[HeaderParam alloc] initWithField:@"Content-Type" withValue:@"text/json" set:YES]];
    NSError *err1 = nil;
    [hc sendRequest:url withHeaders:headers withBody:body withHTTPMethod:method error:&err1];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


-(void) responseReceived: (BOOL)success withResponse:(NSURLResponse *)response withData:(NSMutableData *)data withError:(NSError*)error{
    if(success)
    {
        switch(action){
            case SEND_EVENT:
            {
                id<ICCSendEventDelegate> del = self.sendEventDelegate;
                if([del respondsToSelector:@selector(sendEvent:withError:)])
                    [del sendEvent:YES withError:nil];
            }
            break;
            case GET_USER:
            {
                NSError *err = nil;
                ICUser *user = (ICUser*)[JSONParser createObjectFromData:data withClassName:@"ICUser" error:&err];
                if(user != nil)
                {
                    id<ICCGetUserDelegate> del = self.getUserDelegate;
                    if([del respondsToSelector:@selector(getUser:withError:)])
                        [del getUser:user withError:nil];
                }
                else
                {
                    id<ICCGetUserDelegate> del = self.getUserDelegate;
                    if([del respondsToSelector:@selector(getUser:withError:)])
                        [del getUser:nil withError:err];
                }
            }
            break;
            case GET_ADMIN_TOKEN:
            {
                NSError *err = nil;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
                if(err == nil)
                {
                    NSString *at = [json objectForKey:@"access_token"];
                    if(at != nil)
                    {
                        id<ICCAdminTokenDelegate> del = self.adminTokenDelegate;
                        if([del respondsToSelector:@selector(adminToken:withError:)])
                            [del adminToken:at withError:nil];
                    }
                    else
                    {
                        NSMutableDictionary* details = [NSMutableDictionary dictionary];
                        [details setValue:@"Permission denied." forKey:NSLocalizedDescriptionKey];
                        NSError *err2 = [NSError errorWithDomain:@"ICError" code:1 userInfo:details];
                        id<ICCAdminTokenDelegate> del = self.adminTokenDelegate;
                        if([del respondsToSelector:@selector(adminToken:withError:)])
                            [del adminToken:nil withError:err2];
                    }
                }
                else
                {
                    id<ICCAdminTokenDelegate> del = self.adminTokenDelegate;
                    if([del respondsToSelector:@selector(adminToken:withError:)])
                        [del adminToken:nil withError:err];
                }
            }
            break;
            case ACTION_LOGIN_USER:
            {
                int uid = -1;
                NSError* err = nil;
                if(accessToken != nil && userId != nil){
                    [loggedInUser setAccesToken:accessToken];
                    accessToken = nil;
                    uid = [userId intValue];
                    [loggedInUser setUid:uid];
                    userId = nil;
                }
                else
                {
                    NSMutableDictionary* details = [NSMutableDictionary dictionary];
                    [details setValue:@"Wrong login or password." forKey:NSLocalizedDescriptionKey];
                    error = [NSError errorWithDomain:@"ICError" code:1 userInfo:details];
                }
                id<ICCLoginDelegate> del = self.loginDelegate;
                if([del respondsToSelector:@selector(userLoggedInWithUid:withError:)])
                    [del userLoggedInWithUid:uid withError:err];
            }
            break;
            case ACTION_LOGOUT_USER:
            {
                [loggedInUser logOut];
                id<ICCLogoutDelegate> del = self.logoutDelegate;
                if([del respondsToSelector:@selector(userLoggedOut:withError:)])
                    [del userLoggedOut:YES withError:nil];
            }
            break;
            case ACTION_REGISTER_USER:
            {
                NSError *err = nil;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
                if(err == nil)
                {
                    NSObject *uid = [json objectForKey:@"id"];
                    if(uid != nil)
                    {
                        id<ICCRegistrationDelegate> del = self.registrationDelegate;
                        if([del respondsToSelector:@selector(userRegisteredWithUid:withError:)])
                            [del userRegisteredWithUid:[(NSNumber*)uid intValue] withError:nil];
                    }
                    else
                    {
                        NSMutableDictionary* details = [NSMutableDictionary dictionary];
                        [details setValue:@"Cannot register user." forKey:NSLocalizedDescriptionKey];
                        error = [NSError errorWithDomain:@"ICError" code:1 userInfo:details];
                        id<ICCRegistrationDelegate> del = self.registrationDelegate;
                        if([del respondsToSelector:@selector(userRegisteredWithUid:withError:)])
                            [del userRegisteredWithUid:-1 withError:error];
                    }
                }
                else
                {
                    id<ICCRegistrationDelegate> del = self.registrationDelegate;
                    if([del respondsToSelector:@selector(userRegisteredWithUid:withError:)])
                        [del userRegisteredWithUid:-1 withError:err];
                }

            }
            break;
                
        }
    }
    else
    {
        switch(action){
            case SEND_EVENT:
            {
                id<ICCSendEventDelegate> del = self.sendEventDelegate;
                if([del respondsToSelector:@selector(sendEvent:withError:)])
                    [del sendEvent:NO withError:error];
            }
            break;
            case GET_USER:
            {
                id<ICCGetUserDelegate> del = self.getUserDelegate;
                if([del respondsToSelector:@selector(getUser:withError:)])
                    [del getUser:nil withError:error];
            }
            break;
            case GET_ADMIN_TOKEN:
            {
                id<ICCAdminTokenDelegate> del = self.adminTokenDelegate;
                if([del respondsToSelector:@selector(adminToken:withError:)])
                    [del adminToken:nil withError:error];
            }
            break;
            case ACTION_LOGIN_USER:
            {
                id<ICCLoginDelegate> del = self.loginDelegate;
                if([del respondsToSelector:@selector(userLoggedInWithUid:withError:)])
                    [del userLoggedInWithUid:-1 withError:error];
            }
            break;
            case ACTION_LOGOUT_USER:
            {
                id<ICCLogoutDelegate> del = self.logoutDelegate;
                if([del respondsToSelector:@selector(userLoggedOut:withError:)])
                    [del userLoggedOut:NO withError:error];
            }
            break;
            case ACTION_REGISTER_USER:
            {
                id<ICCRegistrationDelegate> del = self.registrationDelegate;
                if([del respondsToSelector:@selector(userRegisteredWithUid:withError:)])
                    [del userRegisteredWithUid:-1 withError:error];
            }
            break;
        }
    }
}

-(void) rediredtedToURL:(NSURL*)url
{
    switch(action){
        case ACTION_LOGIN_USER:
        {
            NSString *fragment = [url fragment];
            if(fragment != nil)
            {
                NSArray *params = [fragment componentsSeparatedByString:@"&"];
                for(NSString *p in params){
                    NSRange r = [p rangeOfString:@"access_token=" options:NSCaseInsensitiveSearch];
                    if(r.location != NSNotFound){
                        accessToken = [p substringFromIndex:r.length];
                    }
                    r = [p rangeOfString:@"uid=" options:NSCaseInsensitiveSearch];
                    if(r.location != NSNotFound){
                        userId = [p substringFromIndex:r.length];
                    }
                }
            }
        }
        break;
    }
}

@end
