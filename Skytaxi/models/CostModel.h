//
//  CostModel.h
//  CostModel
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CostModel : NSObject

@property (nonatomic, strong) NSString *nr;
@property (nonatomic, strong) NSString *sr;
@property (nonatomic, strong) NSString *dr;
@property (nonatomic, strong) NSString *hr;

- (id)initWithDictionary:(NSDictionary *)dicParams;

@end
