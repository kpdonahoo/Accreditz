//
//  ResultsViewController.h
//  Accreditz
//
//  Created by Amanda Doyle on 12/5/14.
//  Copyright (c) 2014 Sharkbait. All rights reserved.
//

#import "ViewController.h"

@interface ResultsViewController : ViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSString *outcome;
@property (nonatomic, strong) NSString *course;
@property (nonatomic, strong) NSString *section;
@end
