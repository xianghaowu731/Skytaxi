//
//  AirportModel.h
//  AirportModel
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CostModel.h"

@interface AirportModel : NSObject

@property (nonatomic, strong) NSString *pickup;
@property (nonatomic, strong) NSString *pcode;
@property (nonatomic, strong) NSString *paddr;
@property (nonatomic, strong) NSString *dest;
@property (nonatomic, strong) NSString *dcode;
@property (nonatomic, strong) NSString *daddr;
@property (nonatomic, strong) CostModel *pax1;
@property (nonatomic, strong) CostModel *paxs;
@property (nonatomic, strong) CostModel *pax4;

- (id)initWithDictionary:(NSDictionary *)dicParams;

@end
