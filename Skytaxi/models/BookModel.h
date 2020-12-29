//
//  BookModel.h
//  BookModel
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface BookModel : NSObject

@property (nonatomic, strong) NSString *bookId;
@property (nonatomic, strong) NSString *airportId;
@property (nonatomic, strong) NSString *airportName;
@property (nonatomic, strong) NSString *tripDate;
@property (nonatomic, strong) NSString *tripTime;
@property (nonatomic, strong) NSString *nPax; //person count
@property (nonatomic, strong) NSString *persons;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *tripType;//1. no return, 2, same day return, 3, difference day return
@property (nonatomic, strong) NSString *flightTime;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *bookTime;
@property (nonatomic, strong) NSString *statusId;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *payType;//paypal, credit card
@property (nonatomic, strong) NSString *pay_trans;
@property (nonatomic, strong) NSString *pay_charge;
@property (nonatomic, strong) NSString *pay_status;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *pilotId;
@property (nonatomic, strong) UserModel *userInfo;
@property (nonatomic, strong) NSString *returnDate;

- (id)initWithDictionary:(NSDictionary *)dicParams;

@end
