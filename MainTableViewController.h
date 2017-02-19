//
//  MainTableViewController.h
//  Drunkcart
//
//  Created by Sreeji Gopal on 08/02/16.
//  Copyright © 2016 Sreeji Gopal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewController : UITableViewController{
    IBOutlet UIActivityIndicatorView *activityInd;
    UILabel *activityLabel;
    NSTimer *timer;
    UIView *container;
    CGRect frame;
}
@property (nonatomic,retain) NSString *categoryID;

-(id)initWithFrame:(CGRect) theFrame;

@end
