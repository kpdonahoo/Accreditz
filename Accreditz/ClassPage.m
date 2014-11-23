//
//  ClassPage.m
//  Accreditz
//
//  Created by Amanda Doyle on 11/22/14.
//  Copyright (c) 2014 Sharkbait. All rights reserved.
//

#import "ClassPage.h"

@interface ClassPage ()
@property (weak, nonatomic) IBOutlet UILabel *classNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;

@end

@implementation ClassPage
@synthesize className;
@synthesize classNumber;
@synthesize percent;
@synthesize section;
@synthesize classNameLabel;
@synthesize classNumberLabel;
@synthesize sectionLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    classNumberLabel.text = classNumber;
    classNameLabel.text = className;
    sectionLabel.text = section;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
