//
//  CartTableViewController.h
//  Drunkcart
//
//  Created by Sreeji Gopal on 08/03/16.
//  Copyright © 2016 Sreeji Gopal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CartTableViewController : UITableViewController <CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
}
@property(nonatomic, retain) NSMutableDictionary *cartArray;
@end
