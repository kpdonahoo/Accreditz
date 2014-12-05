//
//  ClassCellTableViewCell.h
//  Accreditz
//
//  Created by Amanda Doyle on 11/22/14.
//  Copyright (c) 2014 Sharkbait. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassCellTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *classNumber;
@property (nonatomic, weak) IBOutlet UILabel *className;
@property (nonatomic, weak) IBOutlet UILabel *section;

@end
