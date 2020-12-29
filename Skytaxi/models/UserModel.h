//
//  UserModel.h
//  Food
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *homeAddr;
@property (nonatomic, strong) NSString *homeLoc;
@property (nonatomic, strong) NSString *workAddr;
@property (nonatomic, strong) NSString *workLoc;

- (id)initWithDictionary:(NSDictionary *)dicParams;
@end
