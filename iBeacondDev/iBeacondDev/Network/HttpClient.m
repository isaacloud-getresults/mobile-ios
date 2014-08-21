//
//  HttpClient.m
//  IsaaCloudExampleApp
//
//  Created by akl on 4/24/14.
//  Copyright (c) 2014 SoInteractive. All rights reserved.
//

#import "HttpClient.h"
#import "HeaderParam.h"

@implementation HttpClient

-(id)initWithDelegate:(id)del
{
    [self setDelegate:del];
    return self;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)resp
{
    self.response = resp;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"A_RESPONSE_DATA[%@]=%@",self.response.URL,[[NSString alloc]initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    id<HttpClientDelegate> del = self.delegate;
    NSError *tmpE = nil;
    ICError *error = (ICError*)[JSONParser createObjectFromData:self.responseData withClassName:@"ICError" error:&tmpE];
    if(error == nil || (error.code == nil && error.message == nil && error.data == nil))
    {
        if([del respondsToSelector:@selector(responseReceived:withResponse:withData:withError:)])
            [del responseReceived:YES withResponse:self.response withData:self.responseData withError:nil];
    }
    else
    {
        NSString* errMsg = (error.message != nil) ? error.message : @"Unknown error.";
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:errMsg forKey:NSLocalizedDescriptionKey];
        NSError *err = [NSError errorWithDomain:@"ICError" code:1 userInfo:details];
        if([del respondsToSelector:@selector(responseReceived:withResponse:withData:withError:)])
            [del responseReceived:NO withResponse:nil withData:nil withError:err];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    id<HttpClientDelegate> del = self.delegate;
    if([del respondsToSelector:@selector(responseReceived:withResponse:withData:withError:)])
        [del responseReceived:NO withResponse:nil withData:nil withError:error];
}

-(NSURLRequest*)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    id<HttpClientDelegate> del = self.delegate;
    if([del respondsToSelector:@selector(rediredtedToURL:)])
        [del rediredtedToURL:request.URL];
    return request;
}

-(NSMutableURLRequest *)createRequestWithUrl:(NSString *)url withHeaders:(NSMutableArray *)headers withBody:(NSString *) body withHTTPMethod:(NSString *)method
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    if(method == nil)
        method = @"GET";
    [request setHTTPMethod:method];
    [request setTimeoutInterval:30];
    if(headers != nil)
    {
        for(HeaderParam *hp in headers)
        {
            if(hp.set)
            {
                [request setValue:hp.value forHTTPHeaderField:hp.field];
            }
            else
            {
                [request addValue:hp.value forHTTPHeaderField:hp.field];
            }
        }
    }
    if(body != nil)
        [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

-(void)sendRequestAsync:(NSString *)url withHeaders:(NSMutableArray *)headers withBody:(NSString *) body withHTTPMethod:(NSString *)method
{
    self.responseData = [[NSMutableData alloc] init];
    self.response = nil;
    NSMutableURLRequest *request = [self createRequestWithUrl:url withHeaders:headers withBody:body withHTTPMethod:method];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(BOOL)sendRequest:(NSString *)url withHeaders:(NSMutableArray *)headers withBody:(NSString *) body withHTTPMethod:(NSString *)method error:(NSError**)error
{
    self.responseData = [[NSMutableData alloc] init];
    self.response = nil;
    NSMutableURLRequest *request = [self createRequestWithUrl:url withHeaders:headers withBody:body withHTTPMethod:method];
    NSError *err = nil;
    NSURLResponse *resp = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&err];
    if(err == nil)
    {
        //NSLog(@"S_RESPONSE_DATA[%@]=%@",url,[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        NSError *tmpE = nil;
        ICError *icerr = (ICError*)[JSONParser createObjectFromData:self.responseData withClassName:@"ICError" error:&tmpE];
        if(icerr == nil)
        {
            [self.responseData appendData:data];
            self.response = resp;
            return YES;
        }
        else
        {
            NSString* errMsg = (icerr.message != nil) ? icerr.message : @"Unknown error.";
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:errMsg forKey:NSLocalizedDescriptionKey];
             err = [NSError errorWithDomain:@"ICError" code:1 userInfo:details];
             *error = err;
            return NO;
        }
    }
    else
    {
        *error = err;
        return NO;
    }
}

@end
