//
//  ResultsViewController.m
//  Accreditz
//
//  Created by Amanda Doyle on 12/5/14.
//  Copyright (c) 2014 Sharkbait. All rights reserved.
//

#import "ResultsViewController.h"
#import "ResultsCell.h"
#import "ResultsRow.h"

@interface ResultsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *resultsTitle;
@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;
@property (strong, nonatomic) NSURLSession *session;
@property (weak, nonatomic) IBOutlet UILabel *label2;


@end

@implementation ResultsViewController
@synthesize resultsTitle;
@synthesize outcome;
@synthesize resultsTableView;
NSMutableArray *resultsRows;
NSMutableArray *results;
NSMutableDictionary *jsonUpload;
@synthesize course;
@synthesize section;
@synthesize label2;


-(void) viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:10.0/255.0 green:78.0/255.0 blue:129.0/255.0 alpha:1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    resultsTitle.text = outcome;
    resultsTableView.delegate = self;
    resultsTableView.dataSource = self;
    resultsRows = [[NSMutableArray alloc] init];
    [self getResults];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [resultsRows count];
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
    
    ResultsRow *temp = [resultsRows objectAtIndex:indexPath.row];
    cell.box0.text = temp.one;
    cell.box1.text = [NSString stringWithFormat:@"%@%@",temp.two,@"%"];
    cell.box2.text = [NSString stringWithFormat:@"%@%@",temp.three,@"%"];
    cell.box3.text = [NSString stringWithFormat:@"%@%@",temp.four,@"%"];
    cell.box4.text = [NSString stringWithFormat:@"%@%@",temp.five,@"%"];
    cell.box5.text = [NSString stringWithFormat:@"%@%@",temp.six,@"%"];
        
        return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getResults {
    
    NSURLSessionConfiguration *sessionConfig= [NSURLSessionConfiguration ephemeralSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 5.0;
    sessionConfig.timeoutIntervalForResource = 8.0;
    sessionConfig.HTTPMaximumConnectionsPerHost = 1;
    
    self.session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                 delegate:self
                                            delegateQueue:nil];
    
    NSURL *postUrl = [NSURL URLWithString:@"http://ec2-54-68-112-35.us-west-2.compute.amazonaws.com:8000/GetResults"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postUrl];
    
    jsonUpload = [[NSMutableDictionary alloc] init];
    
    NSString *title = resultsTitle.text;
    NSString *first = [title substringToIndex:3];
    NSString *second = [title substringFromIndex: [title length] - 1];
    NSString *send = [NSString stringWithFormat:@"%@%@",[first lowercaseString],[second lowercaseString]];
    [jsonUpload setObject:send forKey:@"outcome"];
    [jsonUpload setObject:course forKey:@"course"];
    [jsonUpload setObject:section forKey:@"section"];
    
    NSLog(@"%@",jsonUpload);
    
    NSError *error = nil;
    NSData *requestBody=[NSJSONSerialization dataWithJSONObject:jsonUpload options:NSJSONWritingPrettyPrinted error:&error];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestBody];
    
    NSURLSessionDataTask *postTask = [self.session dataTaskWithRequest:request
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                         NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: data
                                                                                                              options: NSJSONReadingMutableContainers error: &error];
                                                         
                                                         NSString *results_string =[JSON valueForKey:@"meow"];
                                                         
                                                         NSLog(@"%@",results_string);
                                                         
                                                         results = [NSMutableArray arrayWithArray:[results_string componentsSeparatedByString: @";"]];
                                                         
                                                         int count = 0;
                                                         for (int i = 1; i < [results count]-1; i++) {
                                                             if ([[results objectAtIndex:i] length] > 6) {
                                                                 count++;
                                                             }
                                                         }
                                                         
                                                         
                                                         for (int j = 1; j < count+1; j++) {
                                                             ResultsRow *temp = [[ResultsRow alloc] init];
                                                             temp.one = [results objectAtIndex:j];
                                                             [resultsRows addObject:temp];
                                                         }
                                                         
                                                         
                                                         int x = 0;
                                                         for (int j = count+1; j < [results count]-1; j=j+5,x++) {
                                                                 ResultsRow *temp = [resultsRows objectAtIndex:x];
                                                                 temp.two = [results objectAtIndex:j];
                                                                 temp.three = [results objectAtIndex:j+1];
                                                                 temp.four = [results objectAtIndex:j+2];
                                                                 temp.five = [results objectAtIndex:j+3];
                                                                 temp.six = [results objectAtIndex:j+4];
                                                         }
                                                         
                                                         ResultsRow *temp = [resultsRows objectAtIndex:0];
                                                         
                                                         [resultsTableView reloadData];
                                                         
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             label2.text = results[0];
                                                             [resultsTableView reloadData];
                                                         });
                                                         
                                                         
                                                     }];
    
    [postTask resume];
    
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
