//
//  ResultsViewController.m
//  Accreditz
//
//  Created by Amanda Doyle on 12/5/14.
//  Copyright (c) 2014 Sharkbait. All rights reserved.
//

#import "ResultsViewController.h"
#import "ResultsCell.h"

@interface ResultsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *resultsTitle;
@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;

@end

@implementation ResultsViewController
@synthesize resultsTitle;
@synthesize outcome;
@synthesize resultsTableView;
NSMutableArray *resultsRows;

-(void) viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:10.0/255.0 green:78.0/255.0 blue:129.0/255.0 alpha:1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    resultsTitle.text = outcome;
    resultsTableView.delegate = self;
    resultsTableView.dataSource = self;
    NSMutableArray *resultsRows = [[NSMutableArray alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *simpleTableIdentifier = @"ResultsCell";
        
        ResultsCell *cell = (ResultsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ResultsCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        
        
        return cell;
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
