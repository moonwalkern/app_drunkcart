//
//  CategoryTableViewController.m
//  Drunkcart
//
//  Created by Sreeji Gopal on 13/02/16.
//  Copyright © 2016 Sreeji Gopal. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "MainTableViewController.h"
#import "Constants.h"
#import "GlobalData.h"
#import "SWRevealViewController.h"
#import "CoreDataManager.h"
#import "Config.h"


@interface CategoryTableViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

@implementation CategoryTableViewController
@synthesize category;
@synthesize myrevealViewController;

NSArray *subcategoryDataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    UIImage* image = [UIImage imageNamed:@"Back.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton* backbtn = [[UIButton alloc] initWithFrame:frame];
    [backbtn setBackgroundImage:image forState:UIControlStateNormal];
    [backbtn setShowsTouchWhenHighlighted:YES];
    [backbtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    [self.navigationItem setRightBarButtonItem:backButtonItem];
    
    //[backButtonItem release];
    //[backbtn release];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSLog(@"Category ID From CategoryTableViewController%@",category);
    SWRevealViewController *revealViewController =  self.revealViewController;

    if (revealViewController) {
        NSLog(@"xx");
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        //[self.navigationController.navigationBar addGestureRecognizer:myrevealViewController.panGestureRecognizer];
        //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.revealViewController panGestureRecognizer];
    }
    
    
    NSString *categoryID = [category valueForKey:@"category_id"];
    subcategoryDataArray = [self fetchSubCategoryData:categoryID];
    NSLog(@"Count of subcategory %ld",[subcategoryDataArray count]);
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
    return [subcategoryDataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
     NSString *imageUrl = [NSString alloc];
    // Configure the cell...
    
    
    NSMutableArray *subcategoryData = subcategoryDataArray[indexPath.row];
    
    NSString *categoryName = [subcategoryData valueForKey:@"subcategory_name"][0];
    NSString *categoryID = [subcategoryData valueForKey:@"subcategory_id"][0];
    NSString *imageName = [subcategoryData valueForKey:@"image"][0];
    NSLog(@"Default image %@ %ld",imageName,[imageName length]);
    
    if ([imageName length] != 0) {
        imageName = [NSString stringWithFormat:@"image/%@",imageName];
    }else {
        imageName = @"Beer_cell_default.png";
    }
    
    
    
    NSLog(@"category id %@ Name %@ Image %@",categoryID,categoryName,imageName);
    
    UIImage *image;
    imageUrl = [NSString stringWithFormat:@"%@",[[GlobalData sharedGlobalData]buildHost:imageName]];
    
    imageUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"Image url %@",imageUrl);
    
    if ([[GlobalData sharedImageCache] DoesExist:imageUrl] == true) {
        image = [[GlobalData sharedImageCache] GetImage:imageUrl];
        NSLog(@"Loading image from cache");
    }else{
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        if(imageData == nil){
            NSLog(@"bad image");
            imageUrl = [NSString stringWithFormat:@"%@",[[GlobalData sharedGlobalData]buildHost:@"Beer_cell.png"]];
            imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        }
        image = [[UIImage alloc] initWithData:imageData];
        [[GlobalData sharedImageCache]AddImage:imageUrl :image];
        NSLog(@"No image in cache loading url");
    }
    cell.imageView.image = image;
    
    
    return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
            NSLog(@"Saved");
        }else{
            NSLog(@"Save error %@",error);
        }
        
    }];
    
    
    
}

-(NSArray*)fetchSubCategoryData :(NSString*)categoryID{
    NSString *name = [NSString stringWithFormat:@"subcategory-%@",categoryID];//Building category name string with combination of subcategory and category id.
    NSArray *fetchSubCategoryData  = [self readSubCategoryData:name];
    
    NSString *urlRest = [NSString stringWithFormat:[[GlobalData sharedGlobalData]buildHost:subcategoryURI],categoryID];
    NSString *postData=[NSString stringWithFormat:@"device=iOS"];
    
    NSLog(@"Name %@ URL %@",name,urlRest);
    if([fetchSubCategoryData count] > 0){
        //NSLog(@"Fetched data from core, now attaching to json object");
        Config *config = fetchSubCategoryData[0];
        fetchSubCategoryData = [fetchSubCategoryData[0] valueForKey:@"data"];
        
        //NSLog(@"[userDetails.userdata description] %@",[config.data description]);
        NSError *jsonError = nil;
        NSArray *arr =
        [NSJSONSerialization JSONObjectWithData:[[config.data description] dataUsingEncoding:NSUTF8StringEncoding]
                                        options:NSJSONReadingMutableContainers
                                          error:&jsonError];
        fetchSubCategoryData = arr;
    }else{
        //NSLog(@"NonExisting category in the coredata");
        fetchSubCategoryData = [[GlobalData sharedGlobalData] requestSynchronousData:urlRest :postData :@"POST"];
        //        //NSLog(@"User Data: %@", fetchCategoryData);
        fetchSubCategoryData = [fetchSubCategoryData valueForKey:@"data"];
        //        //NSLog(@"sssss%@", fetchCategoryData);
        [self addData:name:fetchSubCategoryData];
        
    }
    return fetchSubCategoryData;
}

//Adding custom methods to fetch category data
-(NSArray*)readSubCategoryData :(NSString *) name{
    
    NSArray *fetchedConfig = [[CoreDataManager sharedManager]fetchPredicateEntityWithClassName:@"Config" :@"data_name" :name];
    // display all objects
    for (Config *config in fetchedConfig) {
        NSLog(@"Config %@  -- Date %@ ", [config.data description], [config.datetime description]);
        
    }
    return fetchedConfig;
}

- (void)goBack {
    NSLog(@"xxx");
    

}
@end
