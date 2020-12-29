//
//  HttpApi.m
//  Foods
//
//  Created by Jin_Q on 3/17/16.
//  Copyright © 2016 Jin_Q. All rights reserved.
//
#import "HttpApi.h"
#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "Config.h"
#import "Common.h"

@implementation HttpApi

HttpApi *sharedObj = nil;
AFHTTPRequestOperationManager *manager;

+(id) sharedInstance{
    
    if(!sharedObj)
    {
        static dispatch_once_t oncePredicate;
        dispatch_once(&oncePredicate, ^{
            sharedObj = [[self alloc] init] ;
            manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", @"text/html", nil];
        });
    }
    
    return sharedObj;
}

- (void)loginWithEmail:(NSString *)email
                 Password:(NSString *)password
                    Token:(NSString *)token
                Completed:(void (^)(NSDictionary *))completed
                   Failed:(void (^)(NSString *))failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_LOGIN];
    NSDictionary *parameters = @{
                                 @"email":email,
                                 @"password":password,
                                 @"token":token
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse valueForKey:@"status"];
        if([status isEqualToString:@"success"]) {
            NSDictionary *userdata = [dicResponse objectForKey:@"data"];
            completed(userdata);
        } else {
            NSString *strErrorMsg = [dicResponse objectForKey:@"error"];//@"Login failed!";
            NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[strErrorMsg dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            failed(attrStr.string);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
    
}

- (void)forgotPassword:(NSString *)email
             Completed:(void (^)(NSString *))completed
                Failed:(void (^)(NSString *))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_FORGOTPASS];
    NSDictionary *parameters = @{
                                 @"email":email,
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse valueForKey:@"status"];
        if([status isEqualToString:@"success"]) {
            NSString *str = @"New password was sent via email. Please check your email.";
            completed(str);
        } else {
            NSString *strErrorMsg = @"Password reset failed!";
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)signupWithEmail:(NSString *)email
               Password:(NSString *)password
               Username:(NSString *)username
                  Phone:(NSString *)phone
                  Token:(NSString *)token
              Completed:(void (^)(NSDictionary *))completed
                 Failed:(void (^)(NSString *))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_SIGN_UP];
    NSDictionary *parameters = @{
                                 @"email":email,
                                 @"password":password,
                                 @"username":username,
                                 @"phone":phone,
                                 @"token":token
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse valueForKey:@"status"];
        if([status isEqualToString:@"success"]) {
            NSDictionary *userdata = [dicResponse objectForKey:@"data"];
            completed(userdata);
        } else {
            NSString *strErrorMsg = @"Signup failed!";
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)loginWithSocial:(NSString *)email
               Username:(NSString *)username
               Lastname:(NSString *)lastname
               SocialID:(NSString *)socialID
                   Type:(NSString *)type
                  Photo:(NSString *)photo
                  Token:(NSString *)token
              Completed:(void (^)(NSDictionary *))completed
                 Failed:(void (^)(NSString *))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_LOGIN_SOCIAL];
    NSDictionary *parameters = @{
                                 @"email":email,
                                 @"username":username,
                                 @"lastname":lastname,
                                 @"socialid":socialID,
                                 @"type":type,
                                 @"photo":photo,
                                 @"token":token,
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse valueForKey:@"status"];
        if([status isEqualToString:@"success"]) {
            NSDictionary *userdata = [dicResponse objectForKey:@"data"];
            completed(userdata);
        } else {
            NSString *strErrorMsg = @"Social login failed!";
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)updateHomeAddr:(NSString *)uid
               Address:(NSString *)address
              Location:(NSString *)location
             Completed:(void (^)(NSString *))completed
                Failed:(void (^)(NSString *))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_UPDATE_HOME];
    NSDictionary *parameters = @{
                                 @"uid":uid,
                                 @"address":address,
                                 @"location":location,
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse valueForKey:@"status"];
        if([status isEqualToString:@"success"]) {
            NSString *userdata = @"Address was updated successfully.";
            completed(userdata);
        } else {
            NSString *strErrorMsg = @"Address updating failed!";
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)updateWorkAddr:(NSString *)uid
               Address:(NSString *)address
              Location:(NSString *)location
             Completed:(void (^)(NSString *))completed
                Failed:(void (^)(NSString *))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_UPDATE_WORK];
    NSDictionary *parameters = @{
                                 @"uid":uid,
                                 @"address":address,
                                 @"location":location,
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse valueForKey:@"status"];
        if([status isEqualToString:@"success"]) {
            NSString *userdata = @"Address was updated successfully.";
            completed(userdata);
        } else {
            NSString *strErrorMsg = @"Address updating failed!";
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)uploadPhotoPost:(NSData *)photo
                 UserID:(NSString *)uid
              Completed:(void (^)(NSString *))completed
                 Failed:(void (^)(NSString *))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_UPLOAD_USERPHOTO];
    NSDictionary *dicParams = @{ @"uid":uid};
    
    [manager POST:urlStr parameters:dicParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileData:[NSData dataWithData:photo]
                                name:@"photo"
                            fileName:@"image.jpg"
                            mimeType:@"image/jpg"];
}      success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %@", responseObject);
              NSDictionary *dicResponse = (NSDictionary *)responseObject;
              NSString* status = [dicResponse objectForKey:@"status"];
              if([status isEqualToString:@"success"])
              {
                  NSString *data = [dicResponse objectForKey:@"photo"];
                  completed(data);
              }
              else
              {
                  NSString *strErrorMsg = @"Photo upload failed";//[dicResponse objectForKey:@"message"];
                  failed(strErrorMsg);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failed(@"Network error!!!");
          }];
}
    
- (void)getUserById:(NSString *)email
             UserID:(NSString *)userid
              Token:(NSString *)token
          Completed:(void (^)(NSDictionary *))completed
             Failed:(void (^)(NSString *))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GETUSER_BY_ID];
    NSDictionary *parameters = @{
                                 @"email":email,
                                 @"userID":userid,
                                 @"token":token,
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse valueForKey:@"status"];
        if([status isEqualToString:@"success"]) {
            NSDictionary *userdata = [dicResponse objectForKey:@"data"];
            completed(userdata);
        } else {
            NSString *strErrorMsg = [dicResponse objectForKey:@"error"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}
    
- (void)logout:(NSString *)uid
     Completed:(void (^)(NSString *))completed
        Failed:(void (^)(NSString *))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_LOGOUT];
    NSDictionary *parameters = @{
                                 @"userID":uid,
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse valueForKey:@"status"];
        if([status isEqualToString:@"success"]) {
            NSString *userdata = @"";
            completed(userdata);
        } else {
            NSString *strErrorMsg = @"";
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}
    
- (void)requestBook:(NSString *)uid
          AirportId:(NSString *)airportId
        AirportName:(NSString *)airportName
           TripDate:(NSString *)tripDate
           TripTime:(NSString *)tripTime
               NPax:(NSString *)npax
            Persons:(NSString *)persons
             Weight:(NSString *)weight
           TripType:(NSString *)tripType
         FlightTime:(NSString *)flightTime
            RetTime:(NSString *)retTime
              Price:(NSString *)price
           BookTime:(NSString *)bookTime
          Completed:(void (^)(NSString *))completed
             Failed:(void (^)(NSString *))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_REQUEST_BOOK];
    NSDictionary *parameters = @{
                                 @"user_id":uid,
                                 @"airport_id":airportId,
                                 @"airport_name":airportName,
                                 @"trip_date":tripDate,
                                 @"trip_time":tripTime,
                                 @"npax":npax,
                                 @"persons":persons,
                                 @"weight":weight,
                                 @"trip_type":tripType,
                                 @"flight_time":flightTime,
                                 @"ret_time":retTime,
                                 @"price":price,
                                 @"book_time":bookTime,
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse valueForKey:@"status"];
        if([status isEqualToString:@"success"]) {
            NSString *data = [dicResponse objectForKey:@"data"];//bookid
            completed(data);
        } else {
            NSString *strErrorMsg = @"";
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)deleteRequestBook:(NSString *)bookid
                Completed:(void (^)(NSString *))completed
                   Failed:(void (^)(NSString *))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_DELETE_REQUEST_BOOK];
    NSDictionary *parameters = @{
                                 @"book_id":bookid,
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse valueForKey:@"status"];
        if([status isEqualToString:@"success"]) {
            NSString *userdata = [dicResponse valueForKey:@"data"];
            completed(userdata);
        } else {
            NSString *strErrorMsg = @"";
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)getNewRequest:(void (^)(NSArray *))completed
               Failed:(void (^)(NSString *))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_NEW_REQUEST];
    NSDictionary *parameters = @{};
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse valueForKey:@"status"];
        if([status isEqualToString:@"success"]) {
            NSArray *userdata = [dicResponse valueForKey:@"data"];
            completed(userdata);
        } else {
            NSString *strErrorMsg = @"";
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)doAccept:(NSString *)bookId
         PilotId:(NSString *)pilotId
       Completed:(void (^)(NSString *))completed
          Failed:(void (^)(NSString *))failed{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MMM-dd h:mm a"];
    NSString* time_str = [outputFormatter stringFromDate:[NSDate date]];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_DO_ACCEPT];
    NSDictionary *parameters = @{
                                 @"book_id":bookId,
                                 @"uid":pilotId,
                                 @"publishtime":time_str,
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse valueForKey:@"status"];
        if([status isEqualToString:@"success"]) {
            NSString *userdata = [dicResponse valueForKey:@"data"];
            completed(userdata);
        } else {
            NSString *strErrorMsg = [dicResponse valueForKey:@"error"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)doDecline:(NSString *)bookId
          PilotId:(NSString *)pilotId
        Completed:(void (^)(NSString *))completed
           Failed:(void (^)(NSString *))failed{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MMM-dd h:mm a"];
    NSString* ptime_str = [outputFormatter stringFromDate:[NSDate date]];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_DO_DECLINE];
    NSDictionary *parameters = @{
                                 @"book_id":bookId,
                                 @"uid":pilotId,
                                 @"publishtime":ptime_str,
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse valueForKey:@"status"];
        if([status isEqualToString:@"success"]) {
            NSString *userdata = [dicResponse valueForKey:@"data"];
            completed(userdata);
        } else {
            NSString *strErrorMsg = [dicResponse valueForKey:@"error"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)getConfirmedBooks:(NSString *)uId
                     Type:(NSString *)type
                Completed:(void (^)(NSMutableArray *))completed
                   Failed:(void (^)(NSString *))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_CONFIRMED_BOOKS];
    NSDictionary *parameters = @{
                                 @"uid":uId,
                                 @"type":type,
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse valueForKey:@"status"];
        if([status isEqualToString:@"success"]) {
            NSMutableArray *userdata = [dicResponse valueForKey:@"data"];
            completed(userdata);
        } else {
            NSString *strErrorMsg = [dicResponse valueForKey:@"error"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)getPilotByBookId:(NSString *)bookId
               Completed:(void (^)(NSDictionary *))completed
                  Failed:(void (^)(NSString *))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_PILOT_BY_BOOKID];
    NSDictionary *parameters = @{
                                 @"book_id":bookId,
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse valueForKey:@"status"];
        if([status isEqualToString:@"success"]) {
            NSDictionary *userdata = [dicResponse valueForKey:@"data"];
            completed(userdata);
        } else {
            NSString *strErrorMsg = @"";
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}
- (void)requestCancel:(NSString *)bookId
               Reason:(NSString *)reason
                 Type:(NSString *)type
            Completed:(void (^)(NSString *))completed
               Failed:(void (^)(NSString *))failed{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MMM-dd h:mm a"];
    NSString* ptime_str = [outputFormatter stringFromDate:[NSDate date]];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_REQUEST_CANCEL_BOOK];
    NSDictionary *parameters = @{
                                 @"book_id":bookId,
                                 @"reason":reason,
                                 @"type":type,
                                 @"publishtime":ptime_str,
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse valueForKey:@"status"];
        if([status isEqualToString:@"success"]) {
            NSString *userdata = @"";
            completed(userdata);
        } else {
            NSString *strErrorMsg = [dicResponse valueForKey:@"error"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)updateSetting:(NSString *)uId
             Username:(NSString *)username
                Email:(NSString *)uemail
                Phone:(NSString *)uphone
            Completed:(void (^)(NSString *))completed
               Failed:(void (^)(NSString *))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_UPDATE_USERINFO];
    NSDictionary *parameters = @{
                                 @"uid":uId,
                                 @"username":username,
                                 @"email":uemail,
                                 @"phone":uphone,
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse valueForKey:@"status"];
        if([status isEqualToString:@"success"]) {
            NSString *userdata = @"";
            completed(userdata);
        } else {
            NSString *strErrorMsg = [dicResponse valueForKey:@"error"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)sendMail:(NSString *)tomail
             Msg:(NSString *)msg
        FromMail:(NSString *)frommail
       Completed:(void (^)(NSString *))completed
          Failed:(void (^)(NSString *))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_SEND_MAIL];
    NSDictionary *parameters = @{
                                 @"tomail":tomail,
                                 @"content":msg,
                                 @"from":frommail,
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse valueForKey:@"status"];
        if([status isEqualToString:@"success"]) {
            NSString *userdata = @"";
            completed(userdata);
        } else {
            NSString *strErrorMsg = @"error";
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)uploadPayInfo:(NSString *)bookId
              PayTime:(NSString *)paytime
                 Type:(NSString *)type
        TransactionID:(NSString *)trans_id
             ChargeID:(NSString *)charge_id
               Amount:(NSString *)amount
               Status:(NSString *)status
            Completed:(void (^)(NSString *))completed
               Failed:(void (^)(NSString *))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_UPLOAD_PAYINFO];
    NSDictionary *parameters = @{
                                 @"book_id":bookId,
                                 @"time":paytime,
                                 @"type":type,
                                 @"trans_id":trans_id,
                                 @"charge_id":charge_id,
                                 @"amount":amount,
                                 @"status":status,
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* ret = [dicResponse valueForKey:@"status"];
        if([ret isEqualToString:@"success"]) {
            NSString *userdata = [dicResponse valueForKey:@"data"];
            completed(userdata);
        } else {
            NSString *strErrorMsg = [dicResponse valueForKey:@"error"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)getProfileInfo:(NSString *)uId
                  Type:(NSString *)type
             Completed:(void (^)(NSMutableDictionary *))completed
                Failed:(void (^)(NSString *))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_PROFILE];
    NSDictionary *parameters = @{
                                 @"uid":uId,
                                 @"type":type,
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse valueForKey:@"status"];
        if([status isEqualToString:@"success"]) {
            NSMutableDictionary *userdata = [dicResponse valueForKey:@"data"];
            completed(userdata);
        } else {
            NSString *strErrorMsg = [dicResponse valueForKey:@"error"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)getBookByStatus:(NSString *)uId
               StatusID:(NSString *)statusId
              Completed:(void (^)(NSMutableDictionary *))completed
                 Failed:(void (^)(NSString *))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_GET_BOOK_BY_STATUS];
    NSDictionary *parameters = @{
                                 @"uid":uId,
                                 @"status_id":statusId,
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse valueForKey:@"status"];
        if([status isEqualToString:@"success"]) {
            NSMutableDictionary *userdata = [dicResponse valueForKey:@"data"];
            completed(userdata);
        } else {
            NSString *strErrorMsg = @"";
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)doCompleted:(NSString *)bookId
          Completed:(void (^)(NSString *))completed
             Failed:(void (^)(NSString *))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, POST_COMPLETED_BOOK];
    NSDictionary *parameters = @{
                                 @"book_id":bookId,
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString* status = [dicResponse valueForKey:@"status"];
        if([status isEqualToString:@"success"]) {
            NSString *userdata = @"";
            completed(userdata);
        } else {
            NSString *strErrorMsg = [dicResponse valueForKey:@"error"];
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failed(@"Network error!");
    }];
}

- (void)getStripeCardToken:(NSString *)cardnumber
                  ExpMonth:(NSString *)expmonth
                   ExpYear:(NSString *)expyear
                       Cvc:(NSString *)cvc
                 Completed:(void (^)(NSString *))completed
                    Failed:(void (^)(NSString *))failed{
    NSString *urlStr = @"https://api.stripe.com/v1/tokens";
    NSString *authorize_str = [NSString stringWithFormat:@"Bearer %@", STRIPE_SECRET_KEY];
    [manager.requestSerializer setValue:authorize_str forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setHTTPShouldHandleCookies:NO];
    NSDictionary *parameters = @{
                                 @"card[number]":cardnumber,
                                 @"card[exp_month]":expmonth,
                                 @"card[exp_year]":expyear,
                                 @"card[cvc]":cvc,
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        
        if([[dicResponse allKeys] containsObject:@"id"]) {
            NSString *userdata = [dicResponse valueForKey:@"id"];
            completed(userdata);
        } else {
            NSString *strErrorMsg = @"";
            if([[dicResponse allKeys] containsObject:@"error"]){
                NSDictionary *error_dic = [dicResponse valueForKey:@"error"];
                strErrorMsg = [error_dic valueForKey:@"message"];
            }
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSDictionary *result = (NSDictionary*)operation.responseObject;
        NSDictionary *errDic = [result valueForKey:@"error"];
        failed([errDic valueForKey:@"message"]);
    }];
}

- (void)chargeStripeCard:(NSString *)amount
                Currency:(NSString *)currency
                Strip_Id:(NSString *)token
                    Desc:(NSString *)desc
               Completed:(void (^)(NSDictionary *))completed
                  Failed:(void (^)(NSString *))failed{
    NSString *urlStr = @"https://api.stripe.com/v1/charges";
    NSString *authorize_str = [NSString stringWithFormat:@"Bearer %@", STRIPE_SECRET_KEY];
    [manager.requestSerializer setValue:authorize_str forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setHTTPShouldHandleCookies:NO];
    NSDictionary *parameters = @{
                                 @"amount":amount,
                                 @"currency":currency,
                                 @"source":token,
                                 @"description":desc,
                                 };
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    [manager POST:URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        
        if([[dicResponse allKeys] containsObject:@"id"]) {
            NSString *charge_id = [dicResponse valueForKey:@"id"];
            NSString *status = [dicResponse valueForKey:@"status"];
            NSDictionary *userdata = @{@"ch_id":charge_id, @"status":status};
            completed(userdata);
        } else {
            NSString *strErrorMsg = @"";
            if([[dicResponse allKeys] containsObject:@"error"]){
                NSDictionary *error_dic = [dicResponse valueForKey:@"error"];
                strErrorMsg = [error_dic valueForKey:@"message"];
            }
            failed(strErrorMsg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSDictionary *result = (NSDictionary*)operation.responseObject;
        NSDictionary *errDic = [result valueForKey:@"error"];
        failed([errDic valueForKey:@"message"]);
    }];
}
@end
