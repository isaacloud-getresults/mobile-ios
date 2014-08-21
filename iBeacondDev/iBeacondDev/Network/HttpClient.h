//
//  HttpClient.h
//  IsaaCloudExampleApp
//
//  Created by akl on 4/24/14.
//  Copyright (c) 2014 SoInteractive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICError.h"
#import "JSONParser.h"

@protocol HttpClientDelegate <NSObject>
@required

-(void) responseReceived: (BOOL)success withResponse:(NSURLResponse *)response withData:(NSMutableData *)data withError:(NSError*)error;
-(void) rediredtedToURL:(NSURL*)url;

@end

@interface HttpClient : NSObject<NSURLConnectionDelegate>

@property NSMutableData *responseData;
@property NSURLResponse *response;

@property (nonatomic, weak) id<HttpClientDelegate> delegate;

-(id)initWithDelegate:(id)del;

-(void)sendRequestAsync:(NSString *)url withHeaders:(NSMutableArray *)headers withBody:(NSString *) body withHTTPMethod:(NSString *)method;

-(BOOL)sendRequest:(NSString *)url withHeaders:(NSMutableArray *)headers withBody:(NSString *) body withHTTPMethod:(NSString *)method error:(NSError**)error;

@end
