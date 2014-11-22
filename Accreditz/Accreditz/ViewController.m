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
@property (strong, nonatomic) NSURLSession *session;
#define SERVER_URL "http://ec2-54-68-112-35.us-west-2.compute.amazonaws.com:8000"

@end

//Demonstration
@implementation ViewController
@synthesize resultLabel;

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
    
    /*
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ec2-54-68-112-35.us-west-2.compute.amazonaws.com:8000/ConnectTest"]];
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"POST";
    
    // This is how we set header fields
    [request setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // Convert your data and set your request's HTTPBody property
    NSString *stringData = @"some data";
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
*/
    
    NSString *url = @"http://ec2-54-68-112-35.us-west-2.compute.amazonaws.com:8000/Accreditz/tornado/ConnectTest";
    
    NSData *jsonDataString = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error: nil] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",jsonDataString);
    
}

@end
