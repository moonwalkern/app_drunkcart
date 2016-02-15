//
//  CategoryTableViewController.h
//  Drunkcart
//
//  Created by Sreeji Gopal on 13/02/16.
//  Copyright © 2016 Sreeji Gopal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface CategoryTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;
@property (nonatomic, retain) NSArray *category;
@property (nonatomic, retain) SWRevealViewController *myrevealViewController;
@end
