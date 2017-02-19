//
//  MainTableViewController.m
//  Drunkcart
//
//  Created by Sreeji Gopal on 08/02/16.
//  Copyright © 2016 Sreeji Gopal. All rights reserved.
//


#define NSLog
#define SPINNER_SIZE 25


#import "MainTableViewController.h"
#import "Constants.h"
#import "SWRevealViewController.h"
#import "GlobalData.h"
#import "CoreDataManager.h"
#import "Config.h"
#import "CategoryTableViewController.h"
#import "CCell.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"



@interface MainTableViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) NSArray *category;
@end

NSString *wsEndpoint;
NSArray *categoryDataArray;


@implementation MainTableViewController

@synthesize categoryID;


- (void)viewDidLoad {
    [super viewDidLoad];
    wsEndpoint = [[NSString alloc]init];
    categoryID = [[NSString alloc]init];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    refreshControl.tintColor = [UIColor redColor];
    [refreshControl addTarget:self action:@selector(changeSorting) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    self.refreshControl = refreshControl;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController) {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.navigationController.navigationBar addGestureRecognizer:revealViewController.panGestureRecognizer];

    }
    //wsEndpoint = [[GlobalData sharedGlobalData]webServiceHostName];
    //NSLog(@"WS Endpoint %@", wsEndpoint);
    //[[CoreDataManager sharedManager]init];;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView addSubview:activityInd];
    [self.tableView bringSubviewToFront:activityInd];
    [activityInd startAnimating];
    [self.tableView bringSubviewToFront:activityInd];
    //timer = [NSTimer scheduledTimerWithTimeInterval: (1.0/2.0)
    //                                        target: self
    //                                       selector:@selector(loading)
    //                                       userInfo: nil repeats:YES];
    //[SVProgressHUD show];
    //[activityIndicatorView startAnimating];
    
    
    categoryDataArray = [self fetchCategoryData];
    //[SVProgressHUD dismiss];
    //[activityIndicatorView stopAnimating];
    
}


- (void)loading {
    if (categoryDataArray){
        [activityInd startAnimating];
        NSLog(@"Loading -: %@",categoryDataArray);

    }
    else{
        [activityInd startAnimating];
    }
}

-(void)changeSorting
{
    NSLog(@"Refreshing");
    [self.refreshControl endRefreshing];
    [SVProgressHUD show];
    [self.tableView reloadData];
    [SVProgressHUD dismiss];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    //NSLog(@"%ld",[categoryDataArray count]);
    return [categoryDataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld", indexPath.row];
    
    //NSString *identifier = [NSString stringWithFormat:@"Cell"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSLog(@"Identified %@",identifier);

    
    
    if(cell == nil){
       
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        
        cell.contentView.backgroundColor = [UIColor clearColor];
        UIView *whiteRoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(2,10,367,95)];
        whiteRoundedCornerView.backgroundColor = [UIColor whiteColor];
        whiteRoundedCornerView.layer.masksToBounds = NO;
        whiteRoundedCornerView.layer.cornerRadius = 3.0;
        whiteRoundedCornerView.layer.shadowOffset = CGSizeMake(-1, 1);
        whiteRoundedCornerView.layer.shadowOpacity = 0.5;
        [cell.contentView addSubview:whiteRoundedCornerView];
        [cell.contentView sendSubviewToBack:whiteRoundedCornerView];
    
        
        NSMutableArray *categoryData = categoryDataArray[indexPath.row];
        NSString *imageUrl = [NSString alloc];
        NSString *categoryName = [categoryData valueForKey:@"name"];
        NSString *imageName = [NSString stringWithFormat:@"%@_cell.png",categoryName];
        imageUrl = [NSString stringWithFormat:@"%@",[[GlobalData sharedGlobalData]buildHost:imageName]];
        NSLog(@"Image url %@",imageUrl);

        

        UIImageView *sImage =[[UIImageView alloc] initWithFrame:CGRectMake(12,10,367,95)];
        [sImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        sImage.frame = CGRectMake(2,10,367,95);
        
        
        
        
        [sImage setMultipleTouchEnabled:YES];
        [sImage setUserInteractionEnabled:YES];
        
        [cell.contentView addSubview:sImage];
        //[activityIndicator stopAnimating];
        //[activityIndicatorView stopAnimating];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    return cell;
    
    
}

-(void)singleTapGestureCaptured{
    NSLog(@"single Tap on imageview");
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSIndexPath *selectedIndexPath = [tableView indexPathForSelectedRow];
    ////NSLog(@"Row Selected %ld", selectedIndexPath.row);
    
    //NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    NSInteger rowNo = indexPath.row;
    NSMutableArray *categoryData = categoryDataArray[rowNo];
    NSLog(@"Category Clicked %@ Name %@", [categoryData valueForKey:@"category_id"],[categoryData valueForKey:@"name"]);
    categoryID = [categoryData valueForKey:@"category_id"];
    NSLog(@"Cate = %@",categoryID);
    self.category = categoryData;
    [self performSegueWithIdentifier:@"CategorySegu" sender:self.category];
    
    //CategoryTableViewController *categoryView = [[CategoryTableViewController alloc]init];
    //categoryView.category = categoryData;
    //[self.navigationController pushViewController:categoryView animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [SVProgressHUD show];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *rowNo = [self.tableView indexPathForSelectedRow];
    NSMutableArray *categoryData = categoryDataArray[rowNo.row];
    NSLog(@"Category Data %@", categoryData);
    NSLog(@"Segu ID %@", segue.identifier);
    UINavigationController *navigationController = [segue destinationViewController];
    
    CategoryTableViewController *categoryViewController = [navigationController childViewControllers].firstObject;
    //CategoryTableViewController *categoryViewController = [[CategoryTableViewController alloc]init];
    
    NSLog(@"Cate at segue = %@",sender);
    categoryViewController.category = categoryData;
    //categoryViewController.myrevealViewController = [self revealViewController];
    NSLog(@"Last");
    [SVProgressHUD dismiss];
}


-(NSArray*)fetchCategoryData{
    
    
    NSArray *fetchCategoryData  = [self readCategoryData:@"category"];
    NSLog(@"categoryURI %@",categoryURI);
    NSString *urlRest = [[GlobalData sharedGlobalData]buildHost:categoryURI];
    NSString *postData=[NSString stringWithFormat:@"device=iOS"];
    NSLog(@"urlRest %@",urlRest);
    
    if([fetchCategoryData count] > 0){
        NSLog(@"Fetched data from core, now attaching to json object");
        Config *config = fetchCategoryData[0];
        fetchCategoryData = [fetchCategoryData[0] valueForKey:@"data"];
        
        //NSLog(@"[userDetails.userdata description] %@",[config.data description]);
        NSError *jsonError = nil;
        NSArray *arr =
        [NSJSONSerialization JSONObjectWithData:[[config.data description] dataUsingEncoding:NSUTF8StringEncoding]
                                        options:NSJSONReadingMutableContainers
                                          error:&jsonError];
        fetchCategoryData = arr;
    }else{
        NSLog(@"NonExisting category in the coredata  URL @", urlRest);
        fetchCategoryData = [[GlobalData sharedGlobalData] requestSynchronousData:urlRest :postData :@"POST"];
//        //NSLog(@"User Data: %@", fetchCategoryData);
        fetchCategoryData = [fetchCategoryData valueForKey:@"data"];
//        //NSLog(@"sssss%@", fetchCategoryData);
        [self addData:@"category":fetchCategoryData];
        
    }
    //[self animateActivityStop:self.view];
    return fetchCategoryData;
}

//Adding custom methods to fetch category data
-(NSArray*)readCategoryData :(NSString *) name{
    
    NSArray *fetchedConfig = [[CoreDataManager sharedManager]fetchPredicateEntityWithClassName:@"Config" :@"data_name" :name];
    // display all objects
    for (Config *config in fetchedConfig) {
        //NSLog(@"Config %@  -- Date %@ ", [config.data description], [config.datetime description]);
        
    }
    return fetchedConfig;
}

-(void)addData :(NSString*)configname :(NSData*)data{
    NSMutableDictionary* categDictionary = [[NSMutableDictionary alloc]init];
    
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&err];
    NSString *myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    categDictionary[@"data_name"] = configname;
    categDictionary[@"data"] = myString;
    categDictionary[@"datetime"] = [NSDate date];
    @try {
        [[CoreDataManager sharedManager]createEntityWithClassName:@"Config" attributesDictionary:categDictionary];
    }
    @catch (NSException *exception) {
        //NSLog(@"Exception caught while adding entity %@",exception);
    }
    @finally {
        
    }
    [[CoreDataManager sharedManager]saveDataInManagedContextUsingBlock:^(BOOL saved, NSError *error){
        if(error != nil){
            //NSLog(@"Saved");
        }else{
            //NSLog(@"Save error %@",error);
        }
        
    }];

    

}


-(UIImageView*)animateActivityStart{
    
    //Create the first status image and the indicator view
    UIImage *statusImage = [UIImage imageNamed:@"activity_indicator_image_v.png"];
    UIImageView *activityImageView = [[UIImageView alloc]
                                      initWithImage:statusImage];
    
    
    //Add more images which will be used for the animation
    activityImageView.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"activity_indicator_image_b.png"],
                                         [UIImage imageNamed:@"activity_indicator_image_w.png"],
                                         [UIImage imageNamed:@"activity_indicator_image_r.png"],
                                         nil];
    
    
    //Set the duration of the animation (play with it
    //until it looks nice for you)
    activityImageView.animationDuration = 2.8;
    
    
    //Position the activity image view somewhere in
    //the middle of your current view
    activityImageView.frame = CGRectMake(
                                         self.view.frame.size.width/2
                                         -statusImage.size.width/2,
                                         self.view.frame.size.height/2
                                         -statusImage.size.height/2,
                                         statusImage.size.width,
                                         statusImage.size.height);
    
    //Start the animation
    [activityImageView startAnimating];
    
    
    //Add your custom activity indicator to your current view
    [self.view addSubview:activityImageView];
    return activityImageView;
}
-(void)animateActivityStop :(UIImageView*)activityImageView{
    [activityImageView removeFromSuperview];
    [activityImageView stopAnimating];
}


@end
