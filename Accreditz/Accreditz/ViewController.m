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

@end

//meep

@implementation ViewController
@synthesize resultLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)connectToDatabase:(id)sender {
    
    resultLabel.text = @"hello";
    
}

@end
