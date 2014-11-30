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
@property (strong, nonatomic) NSURLSession *session;
@property (weak, nonatomic) IBOutlet UILabel *outcomeTitle;
@property (weak, nonatomic) IBOutlet UILabel *outcomeDescription;

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
@synthesize session;
@synthesize outcomeTitle;
NSMutableDictionary *jsonUpload;
NSString *students_string;
NSString *outcomes_string;
NSString *performance_string;
NSMutableArray *students_array;
NSMutableArray *outcomes_array;
NSMutableArray *outcomes;
NSMutableArray *students;
NSMutableArray *symbols;
NSMutableArray *info_array;
NSMutableArray *info;
NSMutableArray *performance_indicators;

UIImage *EAC;
UIImage *CAC;
@synthesize outcomeDescription;

- (void)viewDidLoad {
    [super viewDidLoad];
    classNumberLabel.text = [NSString stringWithFormat:@"CSE %@",[classNumber substringFromIndex: [classNumber length] - 4]];
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
    students = [[NSMutableArray alloc] init];
    symbols = [[NSMutableArray alloc] init];
    outcomes = [[NSMutableArray alloc] init];
    info = [[NSMutableArray alloc] init];
    performance_indicators = [[NSMutableArray alloc] init];
    EAC = [UIImage imageNamed:@"EAC.png"];
    CAC = [UIImage imageNamed:@"CAC.png"];
    [self getRoster];
    [self getOutcomesOfCourse];
    [self getPerformanceIndicatorInfo];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 0) {
        return [students count];
    } else if (tableView.tag == 1) {
        return [outcomes count];
    } else if (tableView.tag == 2){
        return [performance_indicators count];
    } else {
        return 10;
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
    
        if ([[symbols objectAtIndex:indexPath.row] isEqualToString:@"CAC"]) {
        
        cell.classification.image = CAC;
            
        } else {
            
        cell.classification.image = EAC;
            
        }
        
    cell.studentName.text = [students objectAtIndex:indexPath.row];
    
        return cell;

    } else if (tableView.tag == 1){
            
        static NSString *simpleTableIdentifier = @"OutcomeCell";
            
        OutcomeCell *cell = (OutcomeCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
        if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OutcomeCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
        
        cell.outcome.text = [outcomes objectAtIndex:indexPath.row];
        return cell;
        
    } else if (tableView.tag == 2) {
        static NSString *simpleTableIdentifier = @"PerformanceIndicators";
        
        PerformanceIndicators *cell = (PerformanceIndicators *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PerformanceIndicators" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.label.text = [performance_indicators objectAtIndex:indexPath.row];
        
        return cell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 1) {
    
    outcomesTableView.hidden = TRUE;
    outcomeTitle.text = [outcomes objectAtIndex:indexPath.row];
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

-(void) getRoster {
    
    NSURLSessionConfiguration *sessionConfig= [NSURLSessionConfiguration ephemeralSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 5.0;
    sessionConfig.timeoutIntervalForResource = 8.0;
    sessionConfig.HTTPMaximumConnectionsPerHost = 1;
    
    self.session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                 delegate:self
                                            delegateQueue:nil];
    
    NSURL *postUrl = [NSURL URLWithString:@"http://ec2-54-68-112-35.us-west-2.compute.amazonaws.com:8000/GetRoster"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postUrl];
    
    jsonUpload = [[NSMutableDictionary alloc] init];
    [jsonUpload setObject:classNumber forKey:@"course"];
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

                                                         students_string =[JSON valueForKey:@"meow"];
                                                         
                                                         students_array = [NSMutableArray arrayWithArray:[students_string componentsSeparatedByString: @","]];
                                                         
                                                         int type = 0;
                                                         
                                                         for (int i = 0; i < [students_array count]; i++) {
                                                         
                                                             //NSLog(@"%@", [students_array objectAtIndex:i]);
                                                             
                                                             if ([[students_array objectAtIndex:i] containsString:@"studentsEAC"]) {
                                                                 type = 1;
                                                             }
                                                             
                                                             if (type == 0 && [[students_array objectAtIndex:i] rangeOfString:@"studentsCAC"].location == NSNotFound) {
                                                                 
                                                                   [students addObject:[students_array objectAtIndex:i]];
                                                                   [symbols addObject:@"CAC"];
                                                                 
                                                             } else if (type == 1 && [[students_array objectAtIndex:i] rangeOfString:@"studentsEAC"].location == NSNotFound) {
                                                                   [students addObject:[students_array objectAtIndex:i]];
                                                                   [symbols addObject:@"EAC"];
                                                             }
                                                             
                                                             
                                                         }
                                                         
                                                         [rosterTableView reloadData];
                                                         
                                                     }];
    
    [postTask resume];
    
}

-(void) getOutcomesOfCourse {
    
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
                                                         
                                                         outcomes_string =[JSON valueForKey:@"meow"];

                                                         
                                                         outcomes_array = [NSMutableArray arrayWithArray:[outcomes_string componentsSeparatedByString: @","]];
                                                         
                                                         int type = 0;
                                                         
                                                         for (int i = 0; i < [outcomes_array count]; i++) {
                                                             
                                                             //NSLog(@"%@", [students_array objectAtIndex:i]);
                                                             
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

-(void) getPerformanceIndicatorInfo {
    
    NSURL *postUrl = [NSURL URLWithString:@"http://ec2-54-68-112-35.us-west-2.compute.amazonaws.com:8000/GetPerformanceIndicatorInfo"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postUrl];
    
    jsonUpload = [[NSMutableDictionary alloc] init];
    NSString *title = outcomeTitle.text;
    NSString *first = [title substringToIndex:3];
    NSString *second = [title substringFromIndex: [title length] - 1];
    NSString *send = [NSString stringWithFormat:@"%@%@",[first lowercaseString],[second lowercaseString]];
    [jsonUpload setObject:classNumber forKey:@"outcome"];
    
    NSLog(@"%@",jsonUpload);
    
    NSError *error = nil;
    NSData *requestBody=[NSJSONSerialization dataWithJSONObject:jsonUpload options:NSJSONWritingPrettyPrinted error:&error];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestBody];
    
    NSURLSessionDataTask *postTask = [self.session dataTaskWithRequest:request
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                         NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: data
                                                                                                              options: NSJSONReadingMutableContainers error: &error];
                                                         
                                                         performance_string =[JSON valueForKey:@"meow"];
                                                         
                                                         NSLog(@"%@",performance_string);
                                                         
                                                         info_array = [NSMutableArray arrayWithArray:[performance_string componentsSeparatedByString: @";"]];
                                                         
                                                         for (int i = 1; i <= (([info_array count]-1)/5); i++) {
                                                             
                                                             [performance_indicators addObject:[NSString stringWithFormat:@"Performance Indicator %d",i]];
                                                         }
                                                         
                                                         
                                                         NSLog(@"%@",performance_indicators);
                                                         
                                                         
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                         outcomeDescription.text = [info_array objectAtIndex:0];
                                                             });
                                                         
                                                     }];
    
    [postTask resume];
    
}

@end
