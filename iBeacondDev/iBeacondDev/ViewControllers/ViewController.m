//
//  ViewController.m
//  QRCodeReader
//
//  Created by Gabriel Theodoropoulos on 27/11/13.
//  Copyright (c) 2013 Gabriel Theodoropoulos. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic) BOOL isReading;

-(BOOL)startReading;
-(void)stopReading;
-(void)loadBeepSound;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Initially make the captureSession object nil.
    _captureSession = nil;
    
    // Set the initial value of the flag to NO.
   // _isReading = NO;
    
  
    
    //To insert the data into the plist
 //   int value = 5;
 //   [data setObject:[NSNumber numberWithInt:value] forKey:@"value"];
  //  [data writeToFile: path atomically:YES];
    
    
 //   NSLog(@"%@",data);
    
    //To reterive the data from the plist
 //   NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
 //   int value1;
//    value1 = [[savedStock objectForKey:@"value"] intValue];
  //  NSLog(@"%i",value1);
    zmienna = TRUE;
    
    // Begin loading the sound effect so to have it ready for playback when it's needed.
    [self loadBeepSound];
    
    [self startReading];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction method implementation

- (IBAction)startStopReading:(id)sender {
    if (!_isReading) {
        // This is the case where the app should read a QR code when the start button is tapped.
        if ([self startReading]) {
            // If the startReading methods returns YES and the capture session is successfully
            // running, then change the start button title and the status message.
            [_bbitemStart setTitle:@"Stop"];
            [_lblStatus setText:@"Scanning for QR Code..."];
        }
    }
    else{
        // In this case the app is currently reading a QR code and it should stop doing so.
        [self stopReading];
        // The bar button item's title should change again.
        [_bbitemStart setTitle:@"Start!"];
    }
    
    // Set to the flag the exact opposite value of the one that currently has.
    _isReading = !_isReading;
}


#pragma mark - Private method implementation

- (BOOL)startReading {
    NSError *error;
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];

    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    // Initialize the captureSession object.
    _captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [_captureSession addInput:input];
    
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    
    // Start video capture.
    [_captureSession startRunning];
    
    return YES;
}


-(void)stopReading{
    // Stop video capture and make the capture session object nil.
    [_captureSession stopRunning];
    _captureSession = nil;
    
    // Remove the video preview layer from the viewPreview view's layer.
    [_videoPreviewLayer removeFromSuperlayer];
    
   
    
}


-(void)loadBeepSound{
    // Get the path to the beep.mp3 file and convert it to a NSURL object.
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];

    NSError *error;
    
    // Initialize the audio player object using the NSURL object previously set.
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        // If the audio player cannot be initialized then log a message.
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        // If the audio player was successfully initialized then load it in memory.
        [_audioPlayer prepareToPlay];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self performSegueWithIdentifier:@"home" sender:self];
    
    
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate method implementation

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        // Get the metadata object.
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            // If the found metadata is equal to the QR code metadata then update the status label's text,
            // stop reading and change the bar button item's title and the flag's value.
            // Everything is done on the main thread.
          //  [_lblStatus performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            
            
            
            NSError *serializeError = nil;
            NSLog(@"%@",[metadataObj stringValue]);
            
            if (zmienna) {
                
                NSString *pelnurl = [NSString stringWithFormat:@"%@config.json",[metadataObj stringValue]];
                
                if([pelnurl rangeOfString:@".getresults.isaacloud.com"].location == NSNotFound)
                {
                    NSLog(@"not found");
                    
                   // UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alarm"
                                             //                           message:@"BAD QR CODE" delegate:nil
                                              //                cancelButtonTitle:@"OK"
                                              //                otherButtonTitles:nil];
                 //   [alertView show];
                    
                    [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
                    // [_bbitemStart performSelectorOnMainThread:@selector(setTitle:) withObject:@"Start!" waitUntilDone:NO];
                    
                    _isReading = NO;
                    
                     zmienna = FALSE;
                    
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^
                     {
                         NSLog(@"show alert!");
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BAD QR CODE" message:@"Zeskanowales zly qr code." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         [alert show];
                     }];

                    
                }
                else
                {
                    NSLog(@"found");
                
                
                
                NSURL *url =[NSURL URLWithString:pelnurl];
                NSData *json = [NSData dataWithContentsOfURL:url];
                NSDictionary *jsonData = [NSJSONSerialization
                                          JSONObjectWithData:json
                                          options:NSJSONReadingMutableContainers
                                          error:&serializeError];
                NSLog(@"%@",jsonData);

                
                
                
                
                
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
                    // If the file doesn’t exist, create an empty dictionary
                    data = [[NSMutableDictionary alloc] init];
                }
                
            NSString *nazwa = [[metadataObj stringValue] stringByReplacingOccurrencesOfString:@".getresults.isaacloud.com/" withString:@""];
            NSString *nazwa2 = [nazwa stringByReplacingOccurrencesOfString:@"http://" withString:@""];
         
            NSString *pfile = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
            NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:pfile];
                NSString *base64 = [jsonData objectForKey:@"iosbase64"];
                [settings setObject:base64 forKey:@"IC Token"];
            NSNumber *clientId = (NSNumber*)[jsonData objectForKey:@"clientid"];
            [settings setObject:clientId forKey:@"IC GID"];
            
            NSNumber *appId = (NSNumber*)[jsonData objectForKey:@"iosid"];
            [settings setObject:appId forKey:@"IC AID"];
                
                NSString *uuid = [NSString stringWithFormat:@"%@",[jsonData objectForKey:@"uuid"]];
                 [settings setObject:uuid forKey:@"UUID"];
                
                NSNumber *notiID = (NSNumber*)[jsonData objectForKey:@"mobileNotification"];
                [settings setObject:notiID forKey:@"mobileNotification"];
            
            [settings writeToFile:pfile atomically:YES];
                
                [settings writeToFile: path atomically:YES];
                
           NSLog(@"%@",settings);
          //      NSLog(@"%@",nazwa2);
           
                [[NSOperationQueue mainQueue] addOperationWithBlock:^
                 {
                     NSLog(@"show alert!");
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Zapisano ustawienia" message:nazwa2 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [alert show];
                 }];

                zmienna = FALSE;
                
                
                
            }
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
           // [_bbitemStart performSelectorOnMainThread:@selector(setTitle:) withObject:@"Start!" waitUntilDone:NO];

            _isReading = NO;
            
            // If the audio player is not nil, then play the sound effect.
            if (_audioPlayer) {
                [_audioPlayer play];
            }
                
                
            }
        }
    }
    
    
}

@end
