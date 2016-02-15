//
//  MainViewController.m
//  Drunkcart
//
//  Created by Sreeji Gopal on 08/02/16.
//  Copyright © 2016 Sreeji Gopal. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"


@interface MainViewController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

@implementation MainViewController

@synthesize sidebarButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController) {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
