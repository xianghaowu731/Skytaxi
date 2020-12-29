//
//  PAcceptedFlightVC.m
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/6.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "PAcceptedFlightVC.h"
#import "InvoiceVC.h"
#import "PConfirmedRequestVC.h"
//#import "CPaymentConfirmVC.h"
#import "BookingAcceptanceVC.h"
#import "UserModel.h"
#import "HttpApi.h"
#import <SVProgressHUD.h>
#import "Config.h"
#import "BookModel.h"
#import "CTripItemCell.h"
#import "Common.h"
#import "PBookingDetailVC.h"

extern UserModel *pilot;
@interface PAcceptedFlightVC ()<UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate>{
    NSMutableArray* tabledata;
}

@end

@implementation PAcceptedFlightVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBookWait:) name:NOTIFICATION_BOOK_WAIT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBookStatus:) name:NOTIFICATION_BOOK_ACCEPT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBookStatus:) name:NOTIFICATION_BOOK_PAID object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBookStatus:) name:NOTIFICATION_BOOK_DECLINE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBookStatus:) name:NOTIFICATION_BOOK_CANCEL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBookStatus:) name:NOTIFICATION_BOOK_STATUS object:nil];
    tabledata = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)changeBookWait:(NSNotification*)msg{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)changeBookStatus:(NSNotification*)msg{
    [self loadData];
}

-(void) viewWillAppear:(BOOL)animated{
    [self loadData];
}

- (void)loadData{
    [SVProgressHUD show];
    [[HttpApi sharedInstance] getConfirmedBooks:pilot.userId Type:@"2" Completed:^(NSMutableArray* result){
        [SVProgressHUD dismiss];
        tabledata = [[NSMutableArray alloc] init];
        for(int i = 0; i < result.count; i++){
            BookModel* one = [[BookModel alloc] initWithDictionary:result[i]];
            [tabledata addObject:one];
        }
        [self.mTableView reloadData];
    } Failed:^(NSString *errstr){
        [SVProgressHUD showErrorWithStatus:errstr];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *cellIndexPath = [self.mTableView indexPathForCell:cell];
    switch (index) {
        case 0:
            [self infoClick:cellIndexPath.row];
            break;
        case 1:
            [self cancelClick:cellIndexPath.row];
            break;
        default:
            break;
    }
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0]
                                                 icon:[Common imageWithImage:[UIImage imageNamed:@"ic_info.png"] scaledToSize:CGSizeMake(32.0, 32.0)]];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0]
                                                 icon:[Common imageWithImage:[UIImage imageNamed:@"ic_cancel.png"] scaledToSize:CGSizeMake(32.0, 32.0)]];
    
    return rightUtilityButtons;
}

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
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BookModel* one = tabledata[indexPath.row];
    CTripItemCell *cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_TripsCell" forIndexPath:indexPath];
    
    cell.mTripNameLabel.text = [NSString stringWithFormat:@"%@", one.userInfo.userName]; // username
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MMM-dd"];
    NSDate *tripDate = [outputFormatter dateFromString:one.tripDate];
    [outputFormatter setDateFormat:@"dd MMMM yyyy"];
    NSString* toStr = [outputFormatter stringFromDate:tripDate];
    cell.mBookDateLabel.text = toStr;
    
    if([one.tripType isEqualToString:@"1"]){
        cell.mBookIdLabel.text = @"One Way";//no return
    } else if([one.tripType isEqualToString:@"2"]){
        cell.mBookIdLabel.text = @"Same Day Return";//return way
    } else if([one.tripType isEqualToString:@"3"]){
        cell.mBookIdLabel.text = @"Different Day Return";//return way
    }
    
    cell.mArrivalLabel.text = [NSString stringWithFormat:@"%@", one.airportName];
    
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self.mTableView reloadData];
}

- (void)infoClick:(NSInteger)sender {
    BookModel* one = tabledata[sender];
    PBookingDetailVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_PBookingDetailVC"];
    mVC.data = one;
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)payClick:(id)sender {
    UIButton *btn = (UIButton*)sender;
    NSInteger itag = btn.tag;
    BookModel* one = tabledata[itag];
    InvoiceVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_InvoiceVC"];
    mVC.invoicedata = one;
    [self.navigationController pushViewController:mVC animated:YES];
}

- (void)cancelClick:(NSInteger)sender {
    BookModel* one = tabledata[sender];
    PConfirmedRequestVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_PConfirmedRequestVC"];
    mVC.data = one;
    [self.navigationController pushViewController:mVC animated:YES];
}


- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSettingClick:(id)sender {
}
@end
