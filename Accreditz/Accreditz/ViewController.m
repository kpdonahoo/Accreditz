//
//  ViewController.m
//  Accreditz
//
//  Created by Kevin Donahoo on 11/17/14.
//  Copyright (c) 2014 Sharkbait. All rights reserved.
//

#import "ViewController.h"
#import "ClassList.h"
#import "SearchPage.h"

@interface ViewController () <NSURLSessionTaskDelegate>
@property (strong, nonatomic) IBOutlet UIView *connectButton;
@property (strong, nonatomic) NSURLSession *session;
#define SERVER_URL "http://ec2-54-68-112-35.us-west-2.compute.amazonaws.com:8000"
@property (weak, nonatomic) IBOutlet UITextField *ID;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIImageView *IDasterisk;
@property (weak, nonatomic) IBOutlet UIImageView *passwordasterisk;
@property (weak, nonatomic) IBOutlet UIImageView *errorAsterisk;

@property (weak, nonatomic) IBOutlet UILabel *errorMessage;

@end

//Demonstration
@implementation ViewController
@synthesize ID;
@synthesize password;
@synthesize IDasterisk;
@synthesize passwordasterisk;
@synthesize errorAsterisk;
@synthesize errorMessage;
NSMutableDictionary *jsonUpload;
NSString *result;
ClassList *vc;
SearchPage *vc2;

- (void)viewDidLoad {
    [super viewDidLoad];    
}


- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)connectToDatabase:(id)sender {
    
    [self.view endEditing:YES];
    
    IDasterisk.hidden = YES;
    passwordasterisk.hidden = YES;
    errorAsterisk.hidden = YES;
    errorMessage.text = @"";
    
    if ([ID.text  isEqual: @""]) {
        NSLog(@"text empty");
        IDasterisk.hidden = NO;
    }
    
    if ([password.text  isEqual: @""]) {
        NSLog(@"text empty");
        passwordasterisk.hidden = NO;
    }
    
    if (![password.text  isEqual: @""] && ![password.text  isEqual: @""]) {
    
    NSURLSessionConfiguration *sessionConfig= [NSURLSessionConfiguration ephemeralSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 5.0;
    sessionConfig.timeoutIntervalForResource = 8.0;
    sessionConfig.HTTPMaximumConnectionsPerHost = 1;
    
    self.session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                 delegate:self
                                            delegateQueue:nil];
    
    NSURL *postUrl = [NSURL URLWithString:@"http://ec2-54-68-112-35.us-west-2.compute.amazonaws.com:8000/Login"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postUrl];
    
    jsonUpload = [[NSMutableDictionary alloc] init];
    [jsonUpload setObject:ID.text forKey:@"username"];
    [jsonUpload setObject:password.text forKey:@"password"];
    
    NSLog(@"%@",jsonUpload);
    
    NSError *error = nil;
    NSData *requestBody=[NSJSONSerialization dataWithJSONObject:jsonUpload options:NSJSONWritingPrettyPrinted error:&error];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestBody];
    
    NSURLSessionDataTask *postTask = [self.session dataTaskWithRequest:request
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                         NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: data
                                                                                                              options: NSJSONReadingMutableContainers error: &error];
                                                         
                                                         NSLog(@"LoginResult:%@",[JSON valueForKey:@"LoginResult"]);
                                                        result = [JSON valueForKey:@"LoginResult"];
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             [self checkResult]; });
                                                     }];
    
     [postTask resume];
        
    }
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        if ([[segue identifier] isEqualToString:@"login"])
        {
            vc = (ClassList *)[segue destinationViewController];
            vc.ID = ID.text;
            ID.text = @"";
            password.text = @"";
            errorMessage.text = @"";
            errorAsterisk.hidden = YES;
        } else if ([[segue identifier] isEqualToString:@"admin"]) {
            vc2 = (SearchPage *)[segue destinationViewController];
            vc2.ID = ID.text;
            ID.text = @"";
            password.text = @"";
            errorMessage.text = @"";
            errorAsterisk.hidden = YES;
        }
}

-(void) checkResult {
    if (result == NULL) {
        errorAsterisk.hidden = NO;
        errorMessage.text = @"Invalid username or password";
    } else if ([result isEqualToString:@"Failed"]) {
        errorAsterisk.hidden = NO;
        errorMessage.text = @"Invalid username or password";
    } else if ([result isEqualToString:@"Success"]){
        if ([ID.text isEqualToString:@"coyle"]) {
            [self performSegueWithIdentifier:@"admin" sender:self];
        } else {
            [self performSegueWithIdentifier:@"login" sender:self];
        }
    }
}

@end
