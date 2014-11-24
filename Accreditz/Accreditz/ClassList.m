//
//  ClassList.m
//  Accreditz
//
//  Created by Amanda Doyle on 11/21/14.
//  Copyright (c) 2014 Sharkbait. All rights reserved.
//

#import "ClassList.h"
#import "ClassCellTableViewCell.h"
#import "ClassPage.h"

@interface ClassList () 
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation ClassList
@synthesize tableView;
@synthesize ID;
@synthesize title;
ClassPage *vc;
NSString *classNumber;
NSString *className;
NSString *section;
NSString *percent;

- (void)viewDidLoad {
    [super viewDidLoad];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(-60, 0, -60, 0);
    self.navigationController.navigationBar.hidden = NO;
    title.text = [NSString stringWithFormat:@"%@%@", ID, @"'s Classes"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ClassCell";
    
    ClassCellTableViewCell *cell = (ClassCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClassCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.className.text = @"Programming Languages";
    cell.classNumber.text = @"CSE 3342";
    cell.percent.text = @"100% Completed";
    cell.section.text = @"Section 001";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ClassCellTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    classNumber = cell.classNumber.text;
    className = cell.className.text;
    section = cell.section.text;
    percent = cell.percent.text;
    
    [self performSegueWithIdentifier: @"classpage" sender: self];

}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"classpage"])
    {
        if ([[segue identifier] isEqualToString:@"classpage"])
        {
            vc = (ClassPage *)[segue destinationViewController];
            vc.className = className;
            vc.classNumber = classNumber;
            vc.section = section;
            vc.percent = percent;
    }
}
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
