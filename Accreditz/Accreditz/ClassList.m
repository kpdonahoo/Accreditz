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
#import "ClassObject.h"

@interface ClassList () 
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) NSURLSession *session;

@end

@implementation ClassList
@synthesize tableView;
@synthesize ID;
@synthesize title;
NSMutableDictionary *jsonUpload;
ClassPage *vc;
NSString *classNumber;
NSString *className;
NSString *section;
NSString *percent;
NSString *name;
NSString *classes_string;
NSMutableArray *classes;
NSMutableArray *classObjects;

- (void)viewDidLoad {
    [super viewDidLoad];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(-60, 0, -60, 0);
    self.navigationController.navigationBar.hidden = NO;
    [self getProfessorInfo];
    [self getClasses];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:10.0/255.0 green:78.0/255.0 blue:129.0/255.0 alpha:1];
    classObjects = [[NSMutableArray alloc] init];
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
    
    ClassCellTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    classNumber = cell.classNumber.text;
    className = cell.className.text;
    section = cell.section.text;
    
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
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             title.text = [NSString stringWithFormat:@"%@%@", name, @"'s Classes"];
                                                         });
                                                     }];

[postTask resume];
    
}

-(void) getClasses {
    
    NSURL *postUrl = [NSURL URLWithString:@"http://ec2-54-68-112-35.us-west-2.compute.amazonaws.com:8000/GetClasses"];
    
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
                                                         //NSDictionary *classes_data = [JSON objectForKey:@"classes"];

                                                         classes_string =[JSON valueForKey:@"classes"];
                                                         
                                                         NSLog(@"%@",classes_string);
                                                         
                                                         classes = [NSMutableArray arrayWithArray:[classes_string componentsSeparatedByString: @","]];
                                                         
                                                         
                                                         for (int i = 0; i < [classes count]-1; i++) {
                                                             
                                                             ClassObject *temp = [[ClassObject alloc] init];
                                                             temp.semester = [classes objectAtIndex:i];
                                                             i++;
                                                             temp.name =[classes objectAtIndex:i];
                                                             i++;
                                                             temp.number = [classes objectAtIndex:i];
                                                             i++;
                                                             temp.section = [classes objectAtIndex:i];
                                                             
                                                             [classObjects addObject:temp];
                                                             
                                                         }
                                                         
                                                         [tableView reloadData];
                                                         
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             [tableView reloadData];
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
