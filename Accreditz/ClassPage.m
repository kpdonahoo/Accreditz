//
//  ClassPage.m
//  Accreditz
//
//  Created by Amanda Doyle on 11/22/14.
//  Copyright (c) 2014 Sharkbait. All rights reserved.
//

#import "ClassPage.h"
#import "RosterCell.h"
#import "OutcomeCell.h"
#import "PerformanceIndicators.h"

@interface ClassPage ()
@property (weak, nonatomic) IBOutlet UILabel *classNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
@property (weak, nonatomic) IBOutlet UITableView *rosterTableView;
@property (weak, nonatomic) IBOutlet UITableView *outcomesTableView;
@property (weak, nonatomic) IBOutlet UIView *outcomeView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UITableView *selectOneTableView;

@end

@implementation ClassPage
@synthesize className;
@synthesize classNumber;
@synthesize percent;
@synthesize section;
@synthesize classNameLabel;
@synthesize classNumberLabel;
@synthesize sectionLabel;
@synthesize rosterTableView;
@synthesize outcomesTableView;
@synthesize outcomeView;
@synthesize selectButton;
@synthesize selectOneTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    classNumberLabel.text = classNumber;
    classNameLabel.text = className;
    sectionLabel.text = section;
    rosterTableView.delegate = self;
    rosterTableView.dataSource = self;
    outcomesTableView.delegate = self;
    outcomesTableView.dataSource = self;
    rosterTableView.tag = 0;
    outcomesTableView.tag = 1;
    selectOneTableView.tag = 2;
    selectOneTableView.delegate = self;
    selectOneTableView.dataSource = self;
    selectOneTableView.layer.borderWidth = .5;
    selectOneTableView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:10.0/255.0 green:78.0/255.0 blue:129.0/255.0 alpha:1];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 0 || tableView.tag == 1) {
    
        return 20;
    } else {
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"RosterCell";
    UITableView *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (tableView.tag == 0) {
    
    static NSString *simpleTableIdentifier = @"RosterCell";
    
    RosterCell *cell = (RosterCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RosterCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.studentName.text = @"Student One";
    
        return cell;

    } else if (tableView.tag == 1){
            
        static NSString *simpleTableIdentifier = @"OutcomeCell";
            
        OutcomeCell *cell = (OutcomeCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
        if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OutcomeCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
        return cell;
        
    } else if (tableView.tag == 2) {
        static NSString *simpleTableIdentifier = @"PerformanceIndicators";
        
        PerformanceIndicators *cell = (PerformanceIndicators *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PerformanceIndicators" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.label.text = @"Performance Indicator";
        
        return cell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 1) {
    
    outcomesTableView.hidden = TRUE;
    outcomeView.hidden = FALSE;
    
    } else if (tableView.tag == 2) {
        NSLog(@"select table view selected");
        selectOneTableView.hidden = YES;
    }
}

- (IBAction)selectOneCalled:(id)sender {
    selectOneTableView.hidden = FALSE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
