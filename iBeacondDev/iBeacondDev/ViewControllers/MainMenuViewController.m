//
//  MainMenuViewController.m
//  iGetResults
//
//  Created by mac on 06.08.2014.
//  Copyright (c) 2014 SoInteractive S.A. All rights reserved.
//

#import "MainMenuViewController.h"


@interface MainMenuViewController ()

@end

@implementation MainMenuViewController{
    
  //  SRWebSocket *webSocket;
    
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
      
    
    
    
//[self connectWebSocket];
   
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated   {       self.navigationController.navigationBar.hidden = YES;   }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*

- (void)connectWebSocket {
    
    
    webSocket.delegate = nil;
    webSocket = nil;
    
    NSString *urlString = @"http://178.62.191.47:443/";
    SRWebSocket *newWebSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    newWebSocket.delegate = self;
    
    
    
    [newWebSocket open];
    
   // [newWebSocket send: @"{ \"token\" : \"6336efc7ec459d693173fd6aaa46ee5\", \"url\" : \"/queues/notifications\"}"];
    
  //  NSLog(@"Utworozno poleczenie");
    
}

- (void)webSocketDidOpen:(SRWebSocket *)newWebSocket {
    webSocket = newWebSocket;
    [webSocket send: @"{ \"token\" : \"6336efc7ec459d693173fd6aaa46ee5\", \"url\" : \"/queues/notifications\"}"];
    [webSocket send:[NSString stringWithFormat:@"Hello from %@", [UIDevice currentDevice].name]];
    NSLog(@"Wyslano");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    [self connectWebSocket];
    NSLog(@"Error %@",error);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    [self connectWebSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"%@",message);
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
