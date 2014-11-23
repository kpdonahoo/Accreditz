//
//  ClassCellTableViewCell.m
//  Accreditz
//
//  Created by Amanda Doyle on 11/22/14.
//  Copyright (c) 2014 Sharkbait. All rights reserved.
//

#import "ClassCellTableViewCell.h"

@implementation ClassCellTableViewCell
@synthesize className;
@synthesize classNumber;
@synthesize section;
@synthesize percent;


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
