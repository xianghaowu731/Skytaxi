//
//  PRequestsVC.m
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/6.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "PRequestsVC.h"
#import "PRequestDetailVC.h"
#import "BookModel.h"
#import "AppDelegate.h"
#import "AirportModel.h"
#import "Config.h"
#import "HttpApi.h"
#import <SVProgressHUD.h>

@interface PRequestsVC ()<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *tabledata;
    NSArray* weekdayNameArray;
}

@end

@implementation PRequestsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBookWait:) name:NOTIFICATION_BOOK_WAIT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBookWait:) name:NOTIFICATION_BOOK_ACCEPT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBookWait:) name:NOTIFICATION_BOOK_CANCEL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeoutProcess:) name:NOTIFICATION_TIME_OUT object:nil];
    tabledata = [[NSMutableArray alloc] init];
    weekdayNameArray = @[@"Sunday",@"Monday", @"Tuesday", @"Wednesday", @"Thursday",@"Friday",@"Saturday"];
    
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [SVProgressHUD show];
    [[HttpApi sharedInstance] getNewRequest:^(NSArray* result){
        [SVProgressHUD dismiss];
        self.data = [[NSMutableArray alloc] initWithArray:result];
        [self reloadData];
    } Failed:^(NSString *errstr){
        [SVProgressHUD dismiss];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)changeBookWait:(NSNotification*)msg{
    [SVProgressHUD show];
    [[HttpApi sharedInstance] getNewRequest:^(NSArray* result){
        [SVProgressHUD dismiss];
        self.data = [[NSMutableArray alloc] initWithArray:result];
        [self reloadData];
    } Failed:^(NSString *errstr){
        [SVProgressHUD dismiss];
    }];
}

- (void)timeoutProcess:(NSNotification*)msg{
    [SVProgressHUD show];
    [[HttpApi sharedInstance] getNewRequest:^(NSArray* result){
        [SVProgressHUD dismiss];
        self.data = [[NSMutableArray alloc] initWithArray:result];
        [self reloadData];
    } Failed:^(NSString *errstr){
        [SVProgressHUD dismiss];
    }];
}

- (void)reloadData{
    tabledata = [[NSMutableArray alloc] init];
    for(int i = 0; i < self.data.count; i++){
        BookModel *one = [[BookModel alloc]initWithDictionary:self.data[i]];
        [tabledata addObject:one];
    }
    [self.mTableView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return tabledata.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookModel *one = tabledata[indexPath.row];
    UITableViewCell* cell;
    cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_RequestItem" forIndexPath:indexPath];
    UILabel* userLabel = [cell viewWithTag:1];
    userLabel.text = one.userInfo.userName;
    
    UILabel* dateLabel = [cell viewWithTag:2];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MMM-dd"];
    NSDate *tripDate = [outputFormatter dateFromString:one.tripDate];
    [outputFormatter setDateFormat:@"dd MMMM yyyy"];
    NSString* toStr = [outputFormatter stringFromDate:tripDate];
    dateLabel.text = toStr;
    
    UILabel* airportLabel = [cell viewWithTag:5];
    AirportModel* airone = g_airportArray[[one.airportId integerValue]];
    airportLabel.text = airone.dest;
    
    UILabel* retLabel = [cell viewWithTag:3];
    if([one.tripType isEqualToString:@"1"]){
        retLabel.text = @"One Way";
    } else if([one.tripType isEqualToString:@"2"]){
        retLabel.text = @"Same Day Return";
    } else if([one.tripType isEqualToString:@"3"]){
        retLabel.text = @"Different Day Return";
    } else{
        retLabel.text = @"";
    }
    
    [outputFormatter setDateFormat:@"yyyy-MMM-dd h:mm a"];
    UILabel* gaptimeLabel = [cell viewWithTag:7];
    NSDate* bookDate = [outputFormatter dateFromString:one.bookTime];
    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:bookDate];
    int numberOfMins = secondsBetween / 60;
    gaptimeLabel.text = [NSString stringWithFormat:@"%d", numberOfMins];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BookModel *one = tabledata[indexPath.row];
    PRequestDetailVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_PRequestDetailVC"];
    mVC.data = one;
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
