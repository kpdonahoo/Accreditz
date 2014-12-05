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
#import "ClassObject.h"
#import "AdminResults.h"

@interface SearchPage ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *searchTitle;
@property (strong, nonatomic) NSURLSession *session;
@end

@implementation SearchPage
@synthesize searchTitle;
@synthesize ID;
@synthesize tableView;
NSString *name;
int table_choice = 0;
NSMutableDictionary *jsonUpload;
NSMutableArray *courses;
NSMutableArray *classObjects;
AdminResults *vc;
NSString *classNumberString;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:10.0/255.0 green:78.0/255.0 blue:129.0/255.0 alpha:1];
    [self getProfessorInfo];
    tableView.delegate = self;
    tableView.dataSource = self;
    classObjects = [[NSMutableArray alloc] init];
    [self getAllClasses];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 201;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [classObjects count];
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
    
    ClassObject *temp = [classObjects objectAtIndex:indexPath.row];
    
    cell.className.text = temp.name;
    cell.classNumber.text = [NSString stringWithFormat:@"CSE %@",[temp.number substringFromIndex: [temp.number length] - 4]];
    cell.section.text = [NSString stringWithFormat:@"Section %@",temp.section];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ClassObject *temp = [classObjects objectAtIndex:indexPath.row];
    classNumberString = temp.number;
    [self performSegueWithIdentifier:@"outcomes" sender:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getProfessorInfo {
    
    NSURLSessionConfiguration *sessionConfig= [NSURLSessionConfiguration ephemeralSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 5.0;
    sessionConfig.timeoutIntervalForResource = 8.0;
    sessionConfig.HTTPMaximumConnectionsPerHost = 1;
    
    self.session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                 delegate:self
                                            delegateQueue:nil];
    
    NSURL *postUrl = [NSURL URLWithString:@"http://ec2-54-68-112-35.us-west-2.compute.amazonaws.com:8000/GetProfessorInfo"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postUrl];
    
    jsonUpload = [[NSMutableDictionary alloc] init];
    [jsonUpload setObject:ID forKey:@"username"];
    
    NSLog(@"%@",jsonUpload);
    
    NSError *error = nil;
    NSData *requestBody=[NSJSONSerialization dataWithJSONObject:jsonUpload options:NSJSONWritingPrettyPrinted error:&error];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestBody];
    
    NSURLSessionDataTask *postTask = [self.session dataTaskWithRequest:request
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                         NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: data
                                                                                                              options: NSJSONReadingMutableContainers error: &error];
                                                         
                                                         name = [JSON valueForKey:@"name"];
                                                         NSLog(@"%@",name);
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             searchTitle.text = [NSString stringWithFormat:@"Welcome %@", name];
                                                         });
                                                     }];
    
    [postTask resume];
    
}

-(void) getAllClasses {
    
    NSURL *postUrl = [NSURL URLWithString:@"http://ec2-54-68-112-35.us-west-2.compute.amazonaws.com:8000/GetAllClasses"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postUrl];
    
    NSError *error = nil;
    NSData *requestBody=[NSJSONSerialization dataWithJSONObject:jsonUpload options:NSJSONWritingPrettyPrinted error:&error];
    
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionDataTask *postTask = [self.session dataTaskWithRequest:request
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                         NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: data
                                                                                                              options: NSJSONReadingMutableContainers error: &error];
                                                         
                                                         NSString *result =[JSON valueForKey:@"meow"];
                                                         
                                                         NSLog(@"%@",result);
                                                         
                                                         courses = [NSMutableArray arrayWithArray:[result componentsSeparatedByString: @","]];
                                                         
                                                         
                                                         for (int i = 0; i < [courses count]-1; i++) {
                                                             
                                                             ClassObject *temp = [[ClassObject alloc] init];
                                                             temp.semester = [courses objectAtIndex:i];
                                                             i++;
                                                             temp.name =[courses objectAtIndex:i];
                                                             i++;
                                                             temp.number = [courses objectAtIndex:i];
                                                             i++;
                                                             temp.section = [courses objectAtIndex:i];
                                                             
                                                             [classObjects addObject:temp];
                                                             
                                                         }
                                                         
                                                         [tableView reloadData];
                                                         
                                                     }];
    
    [postTask resume];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"outcomes"])
    {
        vc = (AdminResults *)[segue destinationViewController];
        vc.classNumber = classNumberString;
    }
}



@end
