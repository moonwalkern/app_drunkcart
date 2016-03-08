//
//  CustomHeader.h
//  Drunkcart
//
//  Created by Sreeji Gopal on 28/02/16.
//  Copyright © 2016 Sreeji Gopal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomHeader : UIView

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIColor * lightColor;
@property (nonatomic, strong) UIColor * darkColor;

@end

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);
CGRect rectFor1PxStroke(CGRect rect);
void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color);
void drawGlossAndGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);