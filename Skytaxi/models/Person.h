//
//  Person.h
//  Person
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *weight;

- (id)initWithDictionary:(NSDictionary *)dicParams;

@end
