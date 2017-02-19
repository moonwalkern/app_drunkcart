//
//  CCell.h
//  Drunkcart
//
//  Created by Sreeji Gopal on 29/02/16.
//  Copyright © 2016 Sreeji Gopal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *decButton;
@property (strong, nonatomic) IBOutlet UIButton *incButton;
@property (strong, nonatomic) IBOutlet UILabel *idLabel;
@property (strong, nonatomic) IBOutlet UIButton *buyButton;
@property (strong, nonatomic) IBOutlet UILabel *hiddenLabel;
@property (strong, nonatomic) IBOutlet UILabel *idLabelTemp;
@property (strong, nonatomic) IBOutlet UIImageView *categoryImage;

@end
