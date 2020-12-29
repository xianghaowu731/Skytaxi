//
//  HttpApi.h
//  Foods
//
//  Created by Jin_Q on 3/17/16.
//  Copyright © 2016 Jin_Q. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpApi : NSObject

+ (id)sharedInstance;

- (void)loginWithEmail:(NSString *)email
                 Password:(NSString *)password
                    Token:(NSString *)token
                Completed:(void (^)(NSDictionary *))completed
                   Failed:(void (^)(NSString *))failed;

- (void)forgotPassword:(NSString *)email
             Completed:(void (^)(NSString *))completed
                Failed:(void (^)(NSString *))failed;

- (void)signupWithEmail:(NSString *)email
              Password:(NSString *)password
               Username:(NSString *)username
                  Phone:(NSString *)phone
                 Token:(NSString *)token
             Completed:(void (^)(NSDictionary *))completed
                Failed:(void (^)(NSString *))failed;

- (void)loginWithSocial:(NSString *)email
              Username:(NSString *)username
               Lastname:(NSString *)lastname
               SocialID:(NSString *)socialID
                   Type:(NSString *)type
                  Photo:(NSString *)photo
                 Token:(NSString *)token
             Completed:(void (^)(NSDictionary *))completed
                Failed:(void (^)(NSString *))failed;

- (void)updateHomeAddr:(NSString *)uid
               Address:(NSString *)address
              Location:(NSString *)location
             Completed:(void (^)(NSString *))completed
                Failed:(void (^)(NSString *))failed;

- (void)updateWorkAddr:(NSString *)uid
               Address:(NSString *)address
              Location:(NSString *)location
             Completed:(void (^)(NSString *))completed
                Failed:(void (^)(NSString *))failed;

- (void)uploadPhotoPost:(NSData *)photo
                 UserID:(NSString *)uid
            Completed:(void (^)(NSString *))completed
               Failed:(void (^)(NSString *))failed;
    
- (void)getUserById:(NSString *)email
               UserID:(NSString *)userid
                  Token:(NSString *)token
              Completed:(void (^)(NSDictionary *))completed
                 Failed:(void (^)(NSString *))failed;
    
- (void)logout:(NSString *)uid
              Completed:(void (^)(NSString *))completed
                 Failed:(void (^)(NSString *))failed;
    
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
             Failed:(void (^)(NSString *))failed;

- (void)deleteRequestBook:(NSString *)bookid
                Completed:(void (^)(NSString *))completed
                   Failed:(void (^)(NSString *))failed;

- (void)getNewRequest:(void (^)(NSArray *))completed
               Failed:(void (^)(NSString *))failed;

- (void)doAccept:(NSString *)bookId
         PilotId:(NSString *)pilotId
       Completed:(void (^)(NSString *))completed
          Failed:(void (^)(NSString *))failed;

- (void)doDecline:(NSString *)bookId
         PilotId:(NSString *)pilotId
       Completed:(void (^)(NSString *))completed
          Failed:(void (^)(NSString *))failed;

- (void)getConfirmedBooks:(NSString *)uId
                     Type:(NSString *)type
                Completed:(void (^)(NSMutableArray *))completed
                   Failed:(void (^)(NSString *))failed;

- (void)getPilotByBookId:(NSString *)bookId
               Completed:(void (^)(NSDictionary *))completed
                  Failed:(void (^)(NSString *))failed;

- (void)requestCancel:(NSString *)bookId
               Reason:(NSString *)reason
                 Type:(NSString *)type
            Completed:(void (^)(NSString *))completed
               Failed:(void (^)(NSString *))failed;

- (void)uploadPayInfo:(NSString *)bookId
              PayTime:(NSString *)paytime
                 Type:(NSString *)type
        TransactionID:(NSString *)trans_id
             ChargeID:(NSString *)charge_id
               Amount:(NSString *)amount
               Status:(NSString *)status
            Completed:(void (^)(NSString *))completed
               Failed:(void (^)(NSString *))failed;

- (void)getProfileInfo:(NSString *)uId
                  Type:(NSString *)type
             Completed:(void (^)(NSMutableDictionary *))completed
                Failed:(void (^)(NSString *))failed;

- (void)getBookByStatus:(NSString *)uId
               StatusID:(NSString *)statusId
              Completed:(void (^)(NSMutableDictionary *))completed
                 Failed:(void (^)(NSString *))failed;

- (void)updateSetting:(NSString *)uId
             Username:(NSString *)username
                Email:(NSString *)uemail
                Phone:(NSString *)uphone
            Completed:(void (^)(NSString *))completed
               Failed:(void (^)(NSString *))failed;

- (void)sendMail:(NSString *)tomail
             Msg:(NSString *)msg
        FromMail:(NSString *)frommail
       Completed:(void (^)(NSString *))completed
          Failed:(void (^)(NSString *))failed;

//==============payment========================
- (void)getStripeCardToken:(NSString *)cardnumber
                  ExpMonth:(NSString *)expmonth
                   ExpYear:(NSString *)expyear
                       Cvc:(NSString *)cvc
                 Completed:(void (^)(NSString *))completed
                    Failed:(void (^)(NSString *))failed;

- (void)chargeStripeCard:(NSString *)amount
                Currency:(NSString *)currency
                Strip_Id:(NSString *)token
                    Desc:(NSString *)desc
                 Completed:(void (^)(NSDictionary *))completed
                    Failed:(void (^)(NSString *))failed;

- (void)doCompleted:(NSString *)bookId
       Completed:(void (^)(NSString *))completed
          Failed:(void (^)(NSString *))failed;

@end
