//
//  RosterCell.h
//  Accreditz
//
//  Created by Amanda Doyle on 11/23/14.
//  Copyright (c) 2014 Sharkbait. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RosterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *studentName;
@property (weak, nonatomic) IBOutlet UIImageView *classification;

@end
