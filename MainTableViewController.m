//
//  MainTableViewController.m
//  Drunkcart
//
//  Created by Sreeji Gopal on 08/02/16.
//  Copyright © 2016 Sreeji Gopal. All rights reserved.
//

#import "MainTableViewController.h"
#import "Constants.h"
#import "SWRevealViewController.h"
#import "GlobalData.h"
#import "CoreDataManager.h"
#import "Config.h"
#import "CategoryTableViewController.h"

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
    wsEndpoint = [[GlobalData sharedGlobalData]webServiceHostName];
    //NSLog(@"WS Endpoint %@", wsEndpoint);
    //[[CoreDataManager sharedManager]init];
    //UIActivityIndicatorView *activityInd = [[UIActivityIndicatorView alloc]init];
    UIImageView *animate = [self animateActivityStart];
    //[activityInd startAnimating];
    //[activityInd startAnimating];
    categoryDataArray = [self fetchCategoryData];
    //NSLog(@"Count  = %ld",[categoryDataArray count]);
    //[activityInd stopAnimating];
    [self animateActivityStop:animate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    //NSLog(@"%ld",[categoryDataArray count]);
    return [categoryDataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    NSString *imageUrl = [NSString alloc];
    
    UIImage *image;
    
    //imageUrl = [NSString stringWithFormat:@"%@",[[GlobalData sharedGlobalData]buildHost:@"cell_bg.png" ] ];
    
    //image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
    
//    //cell.contentView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0];
//    UIView  *whiteRoundedView = [[UIView alloc]initWithFrame:CGRectMake(5, 2, self.view.frame.size.width-10, cell.contentView.frame.size.height)];
//    CGFloat colors[]={1.0,1.0,1.0,1.0};//cell color white
//    whiteRoundedView.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), colors);
//    whiteRoundedView.layer.masksToBounds = false;
//    whiteRoundedView.layer.cornerRadius = 1.0;
//    whiteRoundedView.layer.shadowOffset = CGSizeMake(-1, 1);
//    whiteRoundedView.layer.shadowOpacity = 0.2;
//    [cell.contentView addSubview:whiteRoundedView];
//    [cell.contentView sendSubviewToBack:whiteRoundedView];

//    
//    if (indexPath.row != 0)
//    {
        cell.contentView.backgroundColor = [UIColor clearColor];
        UIView *whiteRoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(2,10,367,95)];
        whiteRoundedCornerView.backgroundColor = [UIColor whiteColor];
        whiteRoundedCornerView.layer.masksToBounds = NO;
        whiteRoundedCornerView.layer.cornerRadius = 3.0;
        whiteRoundedCornerView.layer.shadowOffset = CGSizeMake(-1, 1);
        whiteRoundedCornerView.layer.shadowOpacity = 0.5;
        [cell.contentView addSubview:whiteRoundedCornerView];
        [cell.contentView sendSubviewToBack:whiteRoundedCornerView];
        
//    }
    // Configure the cell...
    
    //Getting all the required data for showing the table view.
    ////NSLog(@"Category %@ index %ld", categoryDataArray[indexPath.row], indexPath.row);  //Show all the data for a given array index
    NSMutableArray *categoryData = categoryDataArray[indexPath.row];
    
    NSString *categoryName = [categoryData valueForKey:@"name"];
    NSString *categoryID = [categoryData valueForKey:@"category_id"];
    NSString *imageName = [NSString stringWithFormat:@"%@_cell.png",categoryName];
    
    
    NSLog(@"category id %@ Name %@",categoryID,categoryName);
    //NSLog(@"category name %@",[categoryData valueForKey:@"category_id"]);
    //NSLog(@"image name %@",imageName);
    //
    
    
    UILabel *categoryNameLabel = (UILabel *)[cell viewWithTag:1];
    categoryNameLabel.text = categoryName;
    
   
    imageUrl = [NSString stringWithFormat:@"%@",[[GlobalData sharedGlobalData]buildHost:imageName]];
    //NSLog(@"Image url %@",imageUrl);
    
    if ([[GlobalData sharedImageCache] DoesExist:imageUrl] == true) {
        image = [[GlobalData sharedImageCache] GetImage:imageUrl];
        //NSLog(@"Loading image from cache");
    }else{
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        if(imageData == nil){
            //NSLog(@"bad image");
            imageUrl = [NSString stringWithFormat:@"%@",[[GlobalData sharedGlobalData]buildHost:@"Beer_cell.png"]];
            imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        }
        image = [[UIImage alloc] initWithData:imageData];
        [[GlobalData sharedImageCache]AddImage:imageUrl :image];
        //NSLog(@"No image in cache loading url");
    }
    
    UIImageView *categoryImage = (UIImageView *)[cell viewWithTag:2];
    //image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
    categoryImage.contentMode = UIViewContentModeScaleAspectFill;
    categoryImage.image = image;
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    //cell.contentView.backgroundColor = [UIColor colorWithRed: 233/255 green: 39/255  blue: 59/255 alpha: 1.0];
    //cell.contentView.backgroundColor = [UIColor colorWithRed:233 green:39 blue:59 alpha:1];;
    //cell.contentView.backgroundColor = UIColor.blueColor;
    
    
    
    //cell.backgroundView = [[UIImageView alloc] initWithImage:[image stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    
    return cell;
}


/*
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
    //[self performSegueWithIdentifier:@"CategorySegu" sender:self.category];
    
    CategoryTableViewController *categoryView = [[CategoryTableViewController alloc]init];
    categoryView.category = categoryData;
    //[self.navigationController pushViewController:categoryView animated:YES];
}
*/
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
}


-(NSArray*)fetchCategoryData{
    NSArray *fetchCategoryData  = [self readCategoryData:@"category"];
    
    NSString *urlRest = [[GlobalData sharedGlobalData]buildHost:categoryURI];
    NSString *postData=[NSString stringWithFormat:@"device=iOS"];

    
    if([fetchCategoryData count] > 0){
        //NSLog(@"Fetched data from core, now attaching to json object");
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
        //NSLog(@"NonExisting category in the coredata");
        fetchCategoryData = [[GlobalData sharedGlobalData] requestSynchronousData:urlRest :postData :@"POST"];
//        //NSLog(@"User Data: %@", fetchCategoryData);
        fetchCategoryData = [fetchCategoryData valueForKey:@"data"];
//        //NSLog(@"sssss%@", fetchCategoryData);
        [self addData:@"category":fetchCategoryData];
        
    }
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
