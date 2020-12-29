//
//  InvoiceVC.m
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/5.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "InvoiceVC.h"
#import "Config.h"

@interface InvoiceVC ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation InvoiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString* str = @"Sydney To Hunter Valley - One Way";
    self.data = [[NSMutableArray alloc] init];
    [self.data addObject:str];
    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setLayout{
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MMM-dd h:mm a"];
    NSDate *bookdate = [outputFormatter dateFromString:self.invoicedata.bookTime];
    [outputFormatter setDateFormat:@"yyyy-MMM-DD"];
    NSString* bookdate_str = [outputFormatter stringFromDate:bookdate];
    if([self.invoicedata.statusId isEqualToString:BOOK_ACCEPTED]){
        self.mDateLabel.text = [NSString stringWithFormat:@"Accepted \n %@", bookdate_str];
        self.mPayTypeLabel.text = @"No Paid";
        
    } else if([self.invoicedata.statusId isEqualToString:BOOK_PAID]){
        self.mDateLabel.text = [NSString stringWithFormat:@"Completed \n %@", bookdate_str];
        self.mPayTypeLabel.text = [NSString stringWithFormat:@"Paid To \n%@ Accont", self.invoicedata.payType];
        
    }
    self.mRefLabel.text = [NSString stringWithFormat:@"%ld", [self.invoicedata.bookId integerValue]];
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
    return self.data.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == self.data.count)
        return 62;
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell;
    if(indexPath.row == self.data.count){
        cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_EmailInvoice" forIndexPath:indexPath];
    } else{
        cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_InvoiceContent" forIndexPath:indexPath];
        UILabel* nameLabel = [cell viewWithTag:1];
        NSString *tripType = @"One Way";
        if(![self.invoicedata.tripType isEqualToString:@"1"]){
            tripType = @"Round Way";
        }
        nameLabel.text = [NSString stringWithFormat:@"Sydney To %@ - %@", self.invoicedata.airportName, tripType];
        UILabel* nPaxLabel = [cell viewWithTag:2];
        nPaxLabel.text = [NSString stringWithFormat:@"%@ Passengers", self.invoicedata.nPax];
        UILabel* priceLabel = [cell viewWithTag:3];
        priceLabel.text = [NSString stringWithFormat:@"AUD Total : %@", self.invoicedata.price];
    }
    
    return cell;
}

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onAddItemClick:(id)sender {
    NSString* str = @"Bathurst";
    [self.data addObject:str];
    [self.mTableView reloadData];
}

- (IBAction)onSendInvoice:(id)sender {
    NSString *tripType = @"One Way";
    if(![self.invoicedata.tripType isEqualToString:@"1"]){
        tripType = @"Round Way";
    }
    NSString *name_str = [NSString stringWithFormat:@"Sydney To %@ - %@", self.invoicedata.airportName, tripType];
    NSString *nPaxStr = [NSString stringWithFormat:@"%@ Passengers", self.invoicedata.nPax];
    NSString *priceStr = [NSString stringWithFormat:@"AUD Total : %@", self.invoicedata.price];
    NSString *emailTitle = @"Invoice Email";
    // Email Content
    NSString *messageBody = [NSString stringWithFormat:@"<h3>Skytaxi Pty Ltd</h3> <br><br> <h4>%@ > %@</h4> <br> <h5>Refence : %@</h5>        <h5>Project Currency : AUD </h5> <br> <br> <h4>%@</h4><br> <h4>%@</h4><br><br><h4>%@</h4><br>" , self.mDateLabel.text, self.mPayTypeLabel.text, self.mRefLabel.text, name_str, nPaxStr, priceStr]; // Change the message body to HTML
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:self.invoicedata.userInfo.email];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:YES];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    //[self.navigationController pushViewController:mc animated:YES];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
