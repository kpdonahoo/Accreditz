//
//  RosterCell.m
//  Accreditz
//
//  Created by Amanda Doyle on 11/23/14.
//  Copyright (c) 2014 Sharkbait. All rights reserved.
//

#import "RosterCell.h"

@implementation RosterCell
@synthesize classification;
@synthesize studentName;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
