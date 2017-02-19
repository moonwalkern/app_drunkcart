//
//  Constants.h
//  DkLogin
//
//  Created by Sreeji Gopal on 24/01/16.
//  Copyright © 2016 Sreeji Gopal. All rights reserved.
//

#ifndef Constants_h
#define Constants_h
#define DEBUGGING YES    //or YES
#define NSLog if(DEBUGGING)NSLog

#endif /* Constants_h */


static NSString *sProjectName = @"Drunkcart";
static NSString *endPointHost = @"http://mydrunkcart/";
//static NSString *endPointHost = @"http://ec2-54-187-203-30.us-west-2.compute.amazonaws.com:8080/MyDrunkCart/";
static NSString *categoryURI = @"index.php?route=module/apps/loadcategory/";
static NSString *subcategoryURI = @"index.php?route=module/apps/getsubcategory&category_id=%@";
static NSString *addCustomerURI = @"index.php?route=module/apps/addcustomer/";
static NSString *authCustomerOtpURI = @"index.php?route=module/apps/authenticateotp/";
static NSString *custAddCustomerURI = @"index.php?route=module/apps/customeradd/";
static NSString *custValidateURI = @"index.php?route=module/apps/validate/";