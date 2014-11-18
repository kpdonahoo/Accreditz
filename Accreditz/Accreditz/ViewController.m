//
//  ViewController.m
//  Accreditz
//
//  Created by Kevin Donahoo on 11/17/14.
//  Copyright (c) 2014 Sharkbait. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView *connectButton;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

//Demonstration
@implementation ViewController
@synthesize resultLabel;
@synthesize button;

- (void)viewDidLoad {
    [super viewDidLoad];
    button.font = [UIFont fontWithName:@"ElephantsinCherryTrees" size:20];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)connectToDatabase:(id)sender {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ec2-54-68-112-35.us-west-2.compute.amazonaws.com/SE_test.py"]
                                                          cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                      timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    NSLog(@"%@",[[NSString alloc] initWithData:response1 encoding:NSUTF8StringEncoding]);
    
    resultLabel.text = @"hello";
    
}

@end
