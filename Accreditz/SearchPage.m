//
//  SearchPage.m
//  Accreditz
//
//  Created by Amanda Doyle on 11/24/14.
//  Copyright (c) 2014 Sharkbait. All rights reserved.
//

#import "SearchPage.h"
#import "SearchCategory.h"

@interface SearchPage ()
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UITextField *searchText;

@end

@implementation SearchPage
@synthesize categoryTableView;
@synthesize categoryLabel;
@synthesize searchText;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    categoryTableView.dataSource = self;
    categoryTableView.delegate = self;
    categoryTableView.tag = 0;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:10.0/255.0 green:78.0/255.0 blue:129.0/255.0 alpha:1];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 0) {
        
        return 3;
        
    } else {
        
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SearchCategory";
    UITableView *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (tableView.tag == 0) {
        
        static NSString *simpleTableIdentifier = @"SearchCategory";
        
        SearchCategory *cell = (SearchCategory *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchCategory" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        
        if (indexPath.row == 0) {
            cell.category.text = @"Class Name";
        } else if (indexPath.row == 1) {
            cell.category.text = @"Class Number";
        } else if (indexPath.row == 2) {
            cell.category.text = @"Professor Name";
        } else {
            cell.category.text = @"Shouldn't exist";
        }
        
        return cell;
        
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 0) {
        if (indexPath.row == 0) {
            categoryLabel.text = @"Search by Class Name";
            searchText.placeholder = @"CLASS NAME";
        } else if (indexPath.row == 1) {
            categoryLabel.text = @"Search by Class Number";
            searchText.placeholder = @"CLASS NUMBER";
        } else {
            categoryLabel.text = @"Search by Professor Name";
            searchText.placeholder = @"PROFESSOR NAME";
        }
    }
    
    categoryTableView.hidden = YES;
}




- (IBAction)categoryClicked:(id)sender {
    categoryTableView.hidden = FALSE;
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
