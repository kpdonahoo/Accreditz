//
//  SearchPage.m
//  Accreditz
//
//  Created by Amanda Doyle on 11/24/14.
//  Copyright (c) 2014 Sharkbait. All rights reserved.
//

#import "SearchPage.h"
#import "SearchCategory.h"
#import "ClassCellTableViewCell.h"
#import "ProfessorCell.h"

@interface SearchPage ()
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (strong, nonatomic) IBOutlet UIView *SearchView;
@end

@implementation SearchPage
@synthesize categoryTableView;
@synthesize categoryLabel;
@synthesize searchText;
@synthesize SearchView;
int table_choice = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    categoryTableView.dataSource = self;
    categoryTableView.delegate = self;
    categoryTableView.tag = 0;
    categoryTableView.layer.borderWidth = .5;
    categoryTableView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:10.0/255.0 green:78.0/255.0 blue:129.0/255.0 alpha:1];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 0) {
        
        return 44;
        
    } else {
        
        return 201;
        
    }
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
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
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
            cell.category.text = @"Search by Class Name";
        } else if (indexPath.row == 1) {
            cell.category.text = @"Search by Class Number";
        } else if (indexPath.row == 2) {
            cell.category.text = @"Search by Professor Name";
        } else {
            cell.category.text = @"Shouldn't exist";
        }
        
        return cell;
       
    } else if (tableView.tag == 1) {
       
        if (table_choice == 0) {
            
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
            
        } else if (table_choice == 1) {
            
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

        } else if (table_choice == 2) {
            
            static NSString *simpleTableIdentifier = @"ProfessorCell";
            
            ProfessorCell *cell = (ProfessorCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProfessorCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.professorName.text = @"Mark Fontenot";
            
            return cell;

        }
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 0) {
        if (indexPath.row == 0) {
            categoryLabel.text = @"Search by Class Name";
            searchText.placeholder = @"CLASS NAME";
            table_choice = 0;
            UITableView *searchResultsTableView=[[UITableView alloc]init];
            searchResultsTableView.frame = CGRectMake(0,248,1024,520);
            searchResultsTableView.dataSource=self;
            searchResultsTableView.delegate=self;
            searchResultsTableView.tag = 1;
            //[searchResultsTableView reloadData];
            [SearchView addSubview:searchResultsTableView];
            [SearchView bringSubviewToFront:categoryTableView];
        } else if (indexPath.row == 1) {
            categoryLabel.text = @"Search by Class Number";
            searchText.placeholder = @"CLASS NUMBER";
            table_choice = 1;
            UITableView *searchResultsTableView=[[UITableView alloc]init];
            searchResultsTableView.frame = CGRectMake(0,248,1024,520);
            searchResultsTableView.dataSource=self;
            searchResultsTableView.delegate=self;
            searchResultsTableView.tag = 1;
            //[searchResultsTableView reloadData];
            [SearchView addSubview:searchResultsTableView];
            [SearchView bringSubviewToFront:categoryTableView];
        } else {
            categoryLabel.text = @"Search by Professor Name";
            searchText.placeholder = @"PROFESSOR NAME";
            table_choice = 2;
            UITableView *searchResultsTableView=[[UITableView alloc]init];
            searchResultsTableView.frame = CGRectMake(0,248,1024,520);
            searchResultsTableView.dataSource=self;
            searchResultsTableView.delegate=self;
            searchResultsTableView.tag = 1;
            //[searchResultsTableView reloadData];
            [SearchView addSubview:searchResultsTableView];
            [SearchView bringSubviewToFront:categoryTableView];
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
