//
//  BookModel.m
//  BookModel
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "BookModel.h"
#import "Person.h"

@implementation BookModel
- (id)initWithDictionary:(NSDictionary *)dicParams
{
    BookModel *item = [[BookModel alloc] init];
    
    item.bookId = [self checkNil:[dicParams objectForKey:@"id"]];
    item.airportId = [self checkNil:[dicParams objectForKey:@"airport_id"]];
    item.airportName = [self checkNil:[dicParams objectForKey:@"airport_name"]];
    item.tripDate = [self checkNil:[dicParams objectForKey:@"trip_date"]];
    item.tripTime = [self checkNil:[dicParams objectForKey:@"trip_time"]];
    item.nPax = [self checkNil:[dicParams objectForKey:@"npax"]];
    item.persons = [self checkNil:[dicParams objectForKey:@"persons"]];
    item.weight = [self checkNil:[dicParams objectForKey:@"weight"]];
    item.tripType = [self checkNil:[dicParams objectForKey:@"trip_type"]];
    item.flightTime = [self checkNil:[dicParams objectForKey:@"flight_time"]];
    item.price = [self checkNil:[dicParams objectForKey:@"price"]];
    item.bookTime = [self checkNil:[dicParams objectForKey:@"book_time"]];
    item.statusId = [self checkNil:[dicParams objectForKey:@"status_id"]];
    item.status = [self checkNil:[dicParams objectForKey:@"status"]];
    item.userId = [self checkNil:[dicParams objectForKey:@"user_id"]];
    item.pilotId = [self checkNil:[dicParams objectForKey:@"pilot_id"]];
    item.reason = [self checkNil:[dicParams objectForKey:@"reason"]];
    item.payType = [self checkNil:[dicParams objectForKey:@"pay_type"]];
    item.pay_trans = [self checkNil:[dicParams objectForKey:@"pay_trans"]];
    item.pay_charge = [self checkNil:[dicParams objectForKey:@"pay_charge"]];
    item.pay_status = [self checkNil:[dicParams objectForKey:@"pay_status"]];
    item.returnDate = [self checkNil:[dicParams objectForKey:@"ret_date"]];
    item.userInfo = [[UserModel alloc] initWithDictionary: [dicParams objectForKey:@"user"]];
    return item;
}

- (NSString*) checkNil:(NSString*)p{
    NSString* result = p;
    if([p isEqual:nil] || [p isEqual:[NSNull null]])
        result = @"";
    return result;
}
@end
