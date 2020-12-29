//
//  AirportModel.m
//  AirportModel
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "AirportModel.h"

@implementation AirportModel
- (id)initWithDictionary:(NSDictionary *)dicParams
{
    AirportModel *item = [[AirportModel alloc] init];
    
    item.pickup = [dicParams objectForKey:@"pickup"];
    item.pcode = [dicParams objectForKey:@"pickcode"];
    item.paddr = [dicParams objectForKey:@"paddr"];
    item.dest = [dicParams objectForKey:@"destination"];
    item.dcode = [dicParams objectForKey:@"destcode"];
    item.daddr = [dicParams objectForKey:@"daddr"];
    item.pax1 = [[CostModel alloc] initWithDictionary:[dicParams objectForKey:@"1"]];
    item.paxs = [[CostModel alloc] initWithDictionary:[dicParams objectForKey:@"2to3"]];
    item.pax4 = [[CostModel alloc] initWithDictionary:[dicParams objectForKey:@"4"]];
    
    return item;
}

@end
