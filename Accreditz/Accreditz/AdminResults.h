//
//  AdminResults.h
//  Accreditz
//
//  Created by Amanda Doyle on 12/5/14.
//  Copyright (c) 2014 Sharkbait. All rights reserved.
//

#import "ViewController.h"

@interface AdminResults : ViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSString *classNumber;
@property (nonatomic, strong) NSString *section;
@end
