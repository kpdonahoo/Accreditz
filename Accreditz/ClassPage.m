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
@property (weak, nonatomic) IBOutlet UILabel *performanceDescription;
@property (weak, nonatomic) IBOutlet UILabel *boxOne;
@property (weak, nonatomic) IBOutlet UILabel *boxTwo;
@property (weak, nonatomic) IBOutlet UILabel *boxThree;
@property (weak, nonatomic) IBOutlet UILabel *boxFour;
@property (weak, nonatomic) IBOutlet UIImageView *diagram;

@property (weak, nonatomic) IBOutlet UILabel *Ulabel;
@property (weak, nonatomic) IBOutlet UILabel *Dlabel;
@property (weak, nonatomic) IBOutlet UILabel *Slabel;
@property (weak, nonatomic) IBOutlet UILabel *Elabel;
@property (weak, nonatomic) IBOutlet UILabel *indicatorLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;



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
@synthesize performanceDescription;
@synthesize boxOne;
@synthesize boxTwo;
@synthesize boxThree;
@synthesize boxFour;
@synthesize diagram;
@synthesize Ulabel;
@synthesize Slabel;
@synthesize Dlabel;
@synthesize Elabel;
@synthesize indicatorLabel;
@synthesize submitButton;
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
NSMutableArray *indicator_descriptions;
NSMutableArray *box_descriptions;
int Ucount;
int Dcount;
int Scount;
int Ecount;
int CACcount;
int EACcount;
int selected;

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
    indicator_descriptions = [[NSMutableArray alloc] init];
    box_descriptions = [[NSMutableArray alloc] init];
    EAC = [UIImage imageNamed:@"EAC.png"];
    CAC = [UIImage imageNamed:@"CAC.png"];
    [self getRoster];
    [self getOutcomesOfCourse];
    
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
            
        static NSString *simpleTableIdentifier = @"OutcomeCell2";
            
        OutcomeCell *cell = (OutcomeCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
        if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OutcomeCell2" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
        
        cell.outcome2.text = [outcomes objectAtIndex:indexPath.row];
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
    [self getPerformanceIndicatorInfo];
    outcomeView.hidden = FALSE;
        Dcount = 0;
        Scount = 0;
        Ecount = 0;
        Ucount = 0;
    
    } else if (tableView.tag == 2) {
        selectOneTableView.hidden = YES;
        submitButton.hidden = FALSE;
        performanceDescription.text = [indicator_descriptions objectAtIndex:indexPath.row];
        performanceDescription.hidden = FALSE;
        
        int index = indexPath.row;
        
        boxOne.text = [box_descriptions objectAtIndex:index*4];
        boxTwo.text = [box_descriptions objectAtIndex:(index*4)+1];
        boxThree.text = [box_descriptions objectAtIndex:(index*4)+2];
        boxFour.text = [box_descriptions objectAtIndex:(index*4)+3];
        
        diagram.hidden = FALSE;
        Dlabel.text = @"0";
        Ulabel.text = @"0";
        Slabel.text = @"0";
        Elabel.text = @"0";
        
        indicatorLabel.text = [NSString stringWithFormat:@"Performance Indicator %i",indexPath.row+1];
        
        selected = indexPath.row+1;
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
    
    CACcount = 0;
    EACcount = 0;
    
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
    NSString *class = [classNumber substringFromIndex: [classNumber length] - 4];
    NSString *class_send = [NSString stringWithFormat:@"cse%@",class];
    [jsonUpload setObject:class_send forKey:@"course"];
    NSString *section_send = [section substringFromIndex: [section length] - 3];
    [jsonUpload setObject:section_send forKey:@"section"];
    
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
                                                                   CACcount++;
                                                                 
                                                             } else if (type == 1 && [[students_array objectAtIndex:i] rangeOfString:@"studentsEAC"].location == NSNotFound) {
                                                                   [students addObject:[students_array objectAtIndex:i]];
                                                                   [symbols addObject:@"EAC"];
                                                                   EACcount++;
                                                             }
                                                             
                                                             
                                                         }
                                                         
                                                         [rosterTableView reloadData];
                                                         
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             [rosterTableView reloadData];
                                                         });
                                                         
                                                         
                                                         
                                                     }];
    
    [postTask resume];
    
}

-(void) getOutcomesOfCourse {
    
    NSURL *postUrl = [NSURL URLWithString:@"http://ec2-54-68-112-35.us-west-2.compute.amazonaws.com:8000/GetOutcomesOfCourse"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postUrl];
    
    jsonUpload = [[NSMutableDictionary alloc] init];
    NSString *class = [classNumber substringFromIndex: [classNumber length] - 4];
    NSString *class_send = [NSString stringWithFormat:@"cse%@",class];
    [jsonUpload setObject:class_send forKey:@"course"];
    
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
                                                         
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             [outcomesTableView reloadData];
                                                         });

                                                         
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
    [jsonUpload setObject:send forKey:@"outcome"];
    
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
                                                         
                                                         int number_of_indicators = (([info_array count]-1)/5);
                                                         
                                                         for (int j = 1; j <= number_of_indicators; j++) {
                                                             
                                                             [performance_indicators addObject:[NSString stringWithFormat:@"Performance Indicator %d",j]];
                                                         }
                                                         
                                                         for (int j = 1; j < [info_array count]; j=j+5) {
                                                             
                                                             [indicator_descriptions addObject:[info_array objectAtIndex:j]];
                                                         }
                                                         
                                                         for (int j = 2; j < [info_array count]; j=j+2) {
                                                             
                                                             [box_descriptions addObject:[info_array objectAtIndex:j]];
                                                             j++;
                                                             [box_descriptions addObject:[info_array objectAtIndex:j]];
                                                             j++;
                                                             [box_descriptions addObject:[info_array objectAtIndex:j]];
                                                             j++;
                                                             [box_descriptions addObject:[info_array objectAtIndex:j]];
                                                         }
                                                         
                                                         for (int i = 0; i < [box_descriptions count]; i++) {
                                                             //NSLog([box_descriptions objectAtIndex:i]);
                                                         }
                                                         
                                                         
                                                         [selectOneTableView reloadData];
                                                         
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                         outcomeDescription.text = [info_array objectAtIndex:0];
                                                         [selectOneTableView reloadData];
                                                             });

                                                         
                                                         
                                                     }];
    
    [postTask resume];
    
}

- (IBAction)Uminus:(id)sender {
    if (Ucount!=0) {
    Ucount--;
    Ulabel.text = [NSString stringWithFormat:@"%i",Ucount];
    }
}

- (IBAction)Uplus:(id)sender {
    if ([[outcomeTitle.text substringToIndex:1] isEqualToString:@"C"]) {
        if (Ucount < CACcount && (Ucount+Dcount+Scount+Ecount < CACcount)) {
            Ucount++;
            Ulabel.text = [NSString stringWithFormat:@"%i",Ucount];
        }
    } else if ([[outcomeTitle.text substringToIndex:1] isEqualToString:@"E"]) {
        if (Ucount < EACcount && (Ucount+Dcount+Scount+Ecount < EACcount)) {
            Ucount++;
            Ulabel.text = [NSString stringWithFormat:@"%i",Ucount];
        }
    }
}

- (IBAction)Dminus:(id)sender {
    if (Dcount!=0) {
    Dcount--;
    Dlabel.text = [NSString stringWithFormat:@"%i",Dcount];
    }
}

- (IBAction)Dplus:(id)sender {
    if ([[outcomeTitle.text substringToIndex:1] isEqualToString:@"C"]) {
        if (Dcount < CACcount && (Ucount+Dcount+Scount+Ecount < CACcount)) {
            Dcount++;
            Dlabel.text = [NSString stringWithFormat:@"%i",Dcount];
        }
    } else if ([[outcomeTitle.text substringToIndex:1] isEqualToString:@"E"]) {
        if (Dcount < EACcount && (Ucount+Dcount+Scount+Ecount < EACcount)) {
            Dcount++;
            Dlabel.text = [NSString stringWithFormat:@"%i",Dcount];
        }
    }
}

- (IBAction)Sminus:(id)sender {
    if (Scount!=0) {
    Scount--;
    Slabel.text = [NSString stringWithFormat:@"%i",Scount];
    }
}

- (IBAction)Splus:(id)sender {
    if ([[outcomeTitle.text substringToIndex:1] isEqualToString:@"C"]) {
        if (Scount < CACcount && (Ucount+Dcount+Scount+Ecount < CACcount)) {
            Scount++;
            Slabel.text = [NSString stringWithFormat:@"%i",Scount];
        }
    } else if ([[outcomeTitle.text substringToIndex:1] isEqualToString:@"E"]) {
        if (Scount < EACcount && (Ucount+Dcount+Scount+Ecount < EACcount)) {
            Scount++;
            Slabel.text = [NSString stringWithFormat:@"%i",Scount];
        }
    }
}

- (IBAction)Eminus:(id)sender {
    if (Ecount!=0) {
    Ecount--;
    Elabel.text = [NSString stringWithFormat:@"%i",Ecount];
    }
}

- (IBAction)Eplus:(id)sender {
    if ([[outcomeTitle.text substringToIndex:1] isEqualToString:@"C"]) {
        if (Ecount < CACcount && (Ucount+Dcount+Scount+Ecount < CACcount)) {
            Ecount++;
            Elabel.text = [NSString stringWithFormat:@"%i",Ecount];
        }
    } else if ([[outcomeTitle.text substringToIndex:1] isEqualToString:@"E"]) {
        if (Ecount < EACcount && (Ucount+Dcount+Scount+Ecount < EACcount)) {
            Ecount++;
            Elabel.text = [NSString stringWithFormat:@"%i",Ecount];
        }
    }
}

- (IBAction)saveResultsForCourse:(id)sender {

    NSURL *postUrl = [NSURL URLWithString:@"http://ec2-54-68-112-35.us-west-2.compute.amazonaws.com:8000/SaveResultsForCourse"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postUrl];
    
    jsonUpload = [[NSMutableDictionary alloc] init];
    NSString *class = [classNumber substringFromIndex: [classNumber length] - 4];
    NSString *class_send = [NSString stringWithFormat:@"cse%@",class];
    [jsonUpload setObject:class_send forKey:@"course"];
    NSString *section_send = [section substringFromIndex: [section length] - 3];
    [jsonUpload setObject:section_send forKey:@"section"];
    NSString *title = outcomeTitle.text;
    NSString *first = [title substringToIndex:3];
    NSString *second = [title substringFromIndex: [title length] - 1];
    NSString *send = [NSString stringWithFormat:@"%@%@",[first lowercaseString],[second lowercaseString]];
    [jsonUpload setObject:send forKey:@"outcome"];
    [jsonUpload setObject:[NSString stringWithFormat:@"%i",Ucount] forKey:@"1"];
    [jsonUpload setObject:[NSString stringWithFormat:@"%i",Dcount] forKey:@"2"];
    [jsonUpload setObject:[NSString stringWithFormat:@"%i",Scount] forKey:@"3"];
    [jsonUpload setObject:[NSString stringWithFormat:@"%i",Ecount] forKey:@"4"];
    [jsonUpload setObject:[NSString stringWithFormat:@"%i",selected] forKey:@"pi"];
    
    NSLog(@"%@",jsonUpload);
    
    NSError *error = nil;
    NSData *requestBody=[NSJSONSerialization dataWithJSONObject:jsonUpload options:NSJSONWritingPrettyPrinted error:&error];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestBody];
    
    NSURLSessionDataTask *postTask = [self.session dataTaskWithRequest:request
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                         NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: data
                                                                                                              options: NSJSONReadingMutableContainers error: &error];
                                                         
                                                         NSString *result =[JSON valueForKey:@"meow"];
                                                         
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                         outcomeView.hidden = TRUE;
                                                         outcomesTableView.hidden = FALSE;
                                                         Ulabel.text = @"";
                                                         Dlabel.text = @"";
                                                         Slabel.text = @"";
                                                         Elabel.text = @"";
                                                             
                                                         [performance_indicators removeAllObjects];
                                                         
                                                         indicatorLabel.text = @"Select Performance Indicator";
                                                             
                                                             boxOne.text = @"";
                                                             boxTwo.text = @"";
                                                             boxThree.text = @"";
                                                             boxFour.text = @"";
                                                         });
                                                         
                                                     }];
    
    [postTask resume];


}

- (IBAction)goBackFromOutcome:(id)sender {
    outcomeView.hidden = TRUE;
    outcomesTableView.hidden = FALSE;
    Ulabel.text = @"";
    Dlabel.text = @"";
    Slabel.text = @"";
    Elabel.text = @"";
    [performance_indicators removeAllObjects];
    indicatorLabel.text = @"Select Performance Indicator";
    boxOne.text = @"";
    boxTwo.text = @"";
    boxThree.text = @"";
    boxFour.text = @"";
}

@end
