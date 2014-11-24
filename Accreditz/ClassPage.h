//
//  ClassPage.h
//  Accreditz
//
//  Created by Amanda Doyle on 11/22/14.
//  Copyright (c) 2014 Sharkbait. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassPage : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *classNumber;
@property (nonatomic, strong) NSString *section;
@property (nonatomic, strong) NSString *percent;
@end
