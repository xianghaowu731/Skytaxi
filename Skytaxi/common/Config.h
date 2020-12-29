//
//  Config.h
//  Foods
//
//  Created by Jin_Q on 3/17/16.
//  Copyright © 2016 Jin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>


#define GOOGLE_API_KEY @"AIzaSyCa1NeX8PGx6jZ6heSK_KStAxZVPPnrvzM"
#define GOOGLE_YOUR_CLIENT_ID @"935364815056-o9525s0fr2k0hajqciiindeup18h6jaj.apps.googleusercontent.com"
#define ONESIGNAL_APP_ID @"07e8483d-6f4d-467e-ae01-7f5a8ccb1335"
#define STRIPE_SECRET_KEY @"sk_test_yg10cyZ6fz3PGhHgiwqu4icg"
#define PAYPAL_ID_FOR_PRODUCTION @"AYs4isZuSVNhuocpw1MdCl4XtahsVXCpyUGyq5EZSR_sPn0hjqSmXdBvxX2WHi60H-oRgA3ESs3oWiGY"
#define PAYPAL_ID_FOR_SANDBOX @"AdhJUdp_gdmRJ2Q0PNcBjnDLx1Oat_Bh2uaOPFZ8IRZvhkixxHgy0GbjRxWlnmuWojAMdrKskApRNUq2"

//=================color ======================================
#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 120.0) blue:((b) / 50.0) alpha:1.0]
#define PRIMARY_COLOR  [UIColor colorWithRed:(41.0/255.0) green:(136.0/255.0) blue:(194.0/255.0) alpha:1.0]
#define WHITE_COLOR  [UIColor colorWithRed:(1.0) green:(1.0) blue:(1.0) alpha:1.0]
#define GRAY_EDGE_COLOR  [UIColor colorWithRed:(128.0/255.0) green:(128.0/255.0) blue:(128.0/255.0) alpha:1.0]
#define CONTROLL_EDGE_COLOR  [UIColor colorWithRed:(0.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:1.0]
#define GREEN_COLOR  [UIColor colorWithRed:(10.0/255.0) green:(166.0/255.0) blue:(82.0/255.0) alpha:1.0]
#define YELLOW_COLOR  [UIColor colorWithRed:(254.0/255.0) green:(159.0/255.0) blue:(0.0/255.0) alpha:1.0]


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


//===========================================
#define NOTIFICATION_BOOK_WAIT @"ChangeBookWait"
#define NOTIFICATION_BOOK_ACCEPT @"ChangeBookAccept"
#define NOTIFICATION_BOOK_DECLINE @"ChangeBookDecline"
#define NOTIFICATION_BOOK_PAID @"ChangeBookPaid"
#define NOTIFICATION_BOOK_CANCEL @"ChangeBookCancel"
#define NOTIFICATION_BOOK_STATUS @"ChangeBookStatus"
#define NOTIFICATION_ENTER_BACKGROUND @"EnterBackground"
#define NOTIFICATION_ENTER_FOREGROUND @"EnterForeground"
#define NOTIFICATION_TERMINATED_APP @"terminatedApp"
#define NOTIFICATION_TIME_OUT @"TimeOut"
//================constant===================
#define USER_TYPE_CUSTOMER @"1"
#define USER_TYPE_PILOT @"2"

#define LOGIN_TYPE_GENERAL 1
#define LOGIN_TYPE_SOCIAL 2

#define TRIP_TYPE_ROUND 0
#define TRIP_TYPE_ONEWAY 1

#define TIMER_INTERVAL 10.0
#define TIMER_MAX_COUNT 60

#define PAYMENT_CREDIT  1
#define PAYMENT_PAYPAL   2

#define PILOT_PAYMENT_DEBIT  4
#define PILOT_PAYMENT_PAYPAL 5
#define PILOT_PAYMENT_BANK   6

//=======book status constant===========
#define BOOK_WAITING @"1"
#define BOOK_ACCEPTED @"2"
#define BOOK_DECLINE @"3"
#define BOOK_PAID @"4"
#define BOOK_CANCELLED @"5"
#define BOOK_COMPLETED @"6"
#define BOOK_DELETE @"7"

/*  Server API Url Part*/
#define SERVER_URL @"http://skytaxiapp.com/skytaxiapp/"

#define USER_PHOTO_BASE_URL @"assets/uploads/profiles/"

//=========users api==========
#define POST_LOGIN @"api/users/login"
#define POST_LOGIN_SOCIAL @"api/users/login_social"
#define POST_FORGOTPASS @"api/users/forgotpassword"
#define POST_SIGN_UP @"api/users/sign_up"
#define POST_UPDATE_HOME @"api/users/updateHomeAddr"
#define POST_UPDATE_WORK @"api/users/updateWorkAddr"
#define POST_UPLOAD_USERPHOTO @"api/users/uploadPhoto"
#define POST_GETUSER_BY_ID @"api/users/getUserById"
#define POST_LOGOUT @"api/users/logout"
#define POST_GET_PROFILE @"api/book/getProfileInfo"
#define POST_UPDATE_USERINFO @"api/users/updateUserInfo"
#define POST_SEND_MAIL @"api/users/sendmail"

#define POST_REQUEST_BOOK @"api/book/requestBook"
#define POST_DELETE_REQUEST_BOOK @"api/book/deleteBook"
#define POST_GET_NEW_REQUEST @"api/book/getNewRequest"
#define POST_DO_ACCEPT @"api/book/doAccept"
#define POST_DO_DECLINE @"api/book/doDecline"
#define POST_GET_CONFIRMED_BOOKS @"api/book/getConfirmedBooks"
#define POST_GET_PILOT_BY_BOOKID @"api/book/getPilotByBookId"
#define POST_REQUEST_CANCEL_BOOK @"api/book/requestCancelBook"
#define POST_UPLOAD_PAYINFO @"api/book/uploadPayInfo"
#define POST_GET_BOOK_BY_STATUS @"api/book/getBookByStatus"
#define POST_COMPLETED_BOOK @"api/book/completedBook"

