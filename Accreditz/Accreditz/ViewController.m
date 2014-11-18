//
//  ViewController.m
//  Accreditz
//
//  Created by Kevin Donahoo on 11/17/14.
//  Copyright (c) 2014 Sharkbait. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <NSURLSessionTaskDelegate>
@property (strong, nonatomic) IBOutlet UIView *connectButton;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) NSURLSession *session;

@end

//Demonstration
@implementation ViewController
@synthesize resultLabel;
@synthesize button;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)connectToDatabase:(id)sender {
    
    NSURLSessionConfiguration *sessionConfig= [NSURLSessionConfiguration ephemeralSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 5.0;
    sessionConfig.timeoutIntervalForResource = 8.0;
    sessionConfig.HTTPMaximumConnectionsPerHost = 1;
    
    self.session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                 delegate:self
                                            delegateQueue:nil];
    
    NSURL *postUrl = [NSURL URLWithString:@"http://ec2-54-68-112-35.us-west-2.compute.amazonaws.com:8000/ConnectTest"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postUrl];
    
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionDataTask *postTask = [self.session dataTaskWithRequest:request
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                         NSLog(@"%@",response);
                                                     }];
    [postTask resume];
    
    resultLabel.text = @"GOT A RESPONSE!";
    
}

@end
