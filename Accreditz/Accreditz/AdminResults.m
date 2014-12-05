//
//  AdminResults.m
//  Accreditz
//
//  Created by Amanda Doyle on 12/5/14.
//  Copyright (c) 2014 Sharkbait. All rights reserved.
//

#import "AdminResults.h"
#import "OutcomeCell.h"
#import "ResultsViewController.h"

@interface AdminResults ()
@property (weak, nonatomic) IBOutlet UITableView *outcomesTableView;
@property (weak, nonatomic) IBOutlet UILabel *resultsTitle;
@property (strong, nonatomic) NSURLSession *session;

@end

@implementation AdminResults
@synthesize outcomesTableView;
@synthesize resultsTitle;
@synthesize classNumber;
@synthesize session;
NSMutableArray *outcomes_array;
NSMutableArray *outcomes;
NSMutableDictionary *jsonUpload;
NSString *clicked_outcome;
ResultsViewController *vc;


-(void) viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:10.0/255.0 green:78.0/255.0 blue:129.0/255.0 alpha:1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    outcomesTableView.dataSource = self;
    outcomesTableView.delegate = self;
    outcomesTableView.tag = 0;
    outcomes = [[NSMutableArray alloc] init];
    
    resultsTitle.text = [NSString stringWithFormat:@"CSE %@",[classNumber substringFromIndex: [classNumber length] - 4]];

    
    [self getOutcomesOfCourse];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 0) {
        return [outcomes count];
    } else {
        return 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"OutcomeCell";
    UITableView *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (tableView.tag == 0) {
        static NSString *simpleTableIdentifier = @"OutcomeCell";
        
        OutcomeCell *cell = (OutcomeCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OutcomeCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.outcome.text = [outcomes objectAtIndex:indexPath.row];
        
        return cell;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    clicked_outcome = [outcomes objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"results" sender:self];
    
}

-(void) getOutcomesOfCourse {
    
    NSURLSessionConfiguration *sessionConfig= [NSURLSessionConfiguration ephemeralSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 5.0;
    sessionConfig.timeoutIntervalForResource = 8.0;
    sessionConfig.HTTPMaximumConnectionsPerHost = 1;
    
    self.session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                 delegate:self
                                            delegateQueue:nil];
    
    NSURL *postUrl = [NSURL URLWithString:@"http://ec2-54-68-112-35.us-west-2.compute.amazonaws.com:8000/GetOutcomesOfCourse"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postUrl];
    
    jsonUpload = [[NSMutableDictionary alloc] init];
    [jsonUpload setObject:classNumber forKey:@"course"];
    
    NSLog(@"%@",jsonUpload);
    
    NSError *error = nil;
    NSData *requestBody=[NSJSONSerialization dataWithJSONObject:jsonUpload options:NSJSONWritingPrettyPrinted error:&error];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestBody];
    
    NSURLSessionDataTask *postTask = [self.session dataTaskWithRequest:request
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                         NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: data
                                                                                                              options: NSJSONReadingMutableContainers error: &error];
                                                         
                                                         NSString *results =[JSON valueForKey:@"meow"];
                                                         
                                                         NSLog(@"%@",results);
                                                         
                                                         outcomes_array = [NSMutableArray arrayWithArray:[results componentsSeparatedByString: @","]];
                                                         
                                                         int type = 0;
                                                         
                                                         for (int i = 0; i < [outcomes_array count]; i++) {
                                                             
                                                             if ([[outcomes_array objectAtIndex:i] containsString:@"EACOutcomes"]) {
                                                                 type = 1;
                                                             }
                                                             
                                                             if (type == 0 && [[outcomes_array objectAtIndex:i] rangeOfString:@"CACOutcomes"].location == NSNotFound) {
                                                                 
                                                                 [outcomes addObject:[NSString stringWithFormat:@"CAC Outcome %@",[outcomes_array objectAtIndex:i]]];
                                                                 
                                                             } else if (type == 1 && [[outcomes_array objectAtIndex:i] rangeOfString:@"EACOutcomes"].location == NSNotFound) {
                                                                 
                                                                 [outcomes addObject:[NSString stringWithFormat:@"EAC Outcome %@",[outcomes_array objectAtIndex:i]]];
                                                                 
                                                             }
                                                             
                                                             
                                                         }
                                                         
                                                         [outcomesTableView reloadData];
                                                         
                                                     }];
    
    [postTask resume];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"results"])
    {
        vc = (ResultsViewController *)[segue destinationViewController];
        vc.outcome = clicked_outcome;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
