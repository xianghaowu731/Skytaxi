//
//  InvoiceVC.h
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/5.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"
#import <MessageUI/MessageUI.h>

@interface InvoiceVC : UIViewController<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UILabel *mDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *mPayTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mCurrencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *mRefLabel;

@property (nonatomic) NSMutableArray* data;
@property (nonatomic) BookModel* invoicedata;

- (IBAction)onBackClick:(id)sender;
- (IBAction)onAddItemClick:(id)sender;
- (IBAction)onSendInvoice:(id)sender;

@end
