//
//  CategoryTableViewController.m
//  Drunkcart
//
//  Created by Sreeji Gopal on 13/02/16.
//  Copyright © 2016 Sreeji Gopal. All rights reserved.
//

#define NSLog

#import "CategoryTableViewController.h"
#import "MainTableViewController.h"
#import "Constants.h"
#import "GlobalData.h"
#import "SWRevealViewController.h"
#import "CoreDataManager.h"
#import "Config.h"
#import "CustomHeader.h"
#import "CustomCellBackground.h"
#import "CCell.h"
#import "CartTableViewController.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"


@interface CategoryTableViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

@implementation CategoryTableViewController
@synthesize category;

@synthesize myrevealViewController;
@synthesize sectionName;
@synthesize subcategoryDataArray;
NSInteger rowInc;
NSMutableDictionary *cartArray;
NSDictionary *backArray;
NSString *identity;
bool fReload;

- (void)viewDidLoad {
    [super viewDidLoad];
    identity = @"Cell";
    cartArray = [[NSMutableDictionary alloc] init];
//    self.navigationItem.hidesBackButton = YES;
//    
    UIImage* image = [UIImage imageNamed:@"BackBtn.png"];
    CGRect frame = CGRectMake(0, 0, 40, 40);
    UIButton* backbtn = [[UIButton alloc] initWithFrame:frame];
    [backbtn setBackgroundImage:image forState:UIControlStateNormal];
    [backbtn setShowsTouchWhenHighlighted:YES];
    [backbtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    
    NSLog(@"Category ID From CategoryTableViewController%@",category);
//    SWRevealViewController *revealViewController =  self.revealViewController;
//
//    if (revealViewController) {
//        NSLog(@"xx");
//        [self.sidebarButton setTarget:self.revealViewController];
//        [self.sidebarButton setAction:@selector(revealToggle:)];
//        //[self.navigationController.navigationBar addGestureRecognizer:myrevealViewController.panGestureRecognizer];
//        //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//        [self.revealViewController panGestureRecognizer];
//    }
    
    //[activityIndicatorView startAnimating];
    NSString *categoryID = [category valueForKey:@"category_id"];
    subcategoryDataArray = [self fetchSubCategoryData:categoryID];
    NSLog(@"Count of subcategory %ld",[subcategoryDataArray count]);
    //[SVProgressHUD show];
    [self loadSubDisctionary];
    //[SVProgressHUD dismiss];
    rowInc = 0;
    fReload = NO;
    //[self.tableView reloadData];
    //Setting font genericalluy
    //[subCLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:156.0]];
 
    
    //Remove this.
    
//    for (NSString* family in [UIFont familyNames])
//    {
//        NSLog(@"FONT %@", family);
//        
//        for (NSString* name in [UIFont fontNamesForFamilyName: family])
//        {
//            NSLog(@"  %@", name);
//        }
//    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBack:) name:@"getBack1" object:backArray];
    
}


- (void) showBack:(NSNotification *)notification{
    NSDictionary  *theArray = [notification userInfo];
    NSLog(@"Got back %@",theArray);
    identity = @"Cell";
    fReload = YES;
    //[self.tableView reloadData];
    //[self.tableView beginUpdates];
    //NSIndexPath *iPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //[self.tableView deleteRowsAtIndexPaths:@[iPath] withRowAnimation:UITableViewRowAnimationNone];
    //[self.tableView reloadData];
    //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:iPath] withRowAnimation:UITableViewRowAnimationNone];
    //[self.tableView endUpdates];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getBack" object:backArray];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
   
    [super viewWillAppear:animated];
    [self.tableView reloadData]; // to reload selected cell
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    //NSLog(@"Count of sections %lu",[sectionName count]);
    return [sectionName count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    
    NSArray *categoryArray = [subcategoryDataArray objectAtIndex:section];
    NSArray *subArray = [categoryArray valueForKey:@"subcategories"];
    
    //NSLog(@"no of rowsection %lu", (unsigned long)[subArray count]);
    
    return [subArray count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    //Set the header value for each section. We return the letter for this group.
    NSArray *categoryArray = [subcategoryDataArray objectAtIndex:section];
    NSArray *subArray = [categoryArray valueForKey:@"subcategory_name"];
    NSString *key = [subArray description];
    
    return key;
    
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return 100;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    UILabel *myLabel = [[UILabel alloc] init];
//    myLabel.frame = CGRectMake(20, 2, 320, 30);
//    myLabel.font = [UIFont boldSystemFontOfSize:20];
//    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
//    
//    UIView *headerView = [[UIView alloc] init];
//    [headerView addSubview:myLabel];
//    
//    return headerView;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    CustomHeader * header = [[CustomHeader alloc] init];
    header.titleLabel.text = [self tableView: tableView titleForHeaderInSection:section];
    
    
    // START NEW
    if (section % 2) {
        header.lightColor = [UIColor colorWithRed:147.0/255.0 green:105.0/255.0 blue:216.0/255.0 alpha:1.0];
        header.darkColor = [UIColor colorWithRed:72.0/255.0 green:22.0/255.0 blue:137.0/255.0 alpha:1.0];
    }
    // END NEW
    return header;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    // create the parent view that will hold header Label
//    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 22.0)];
//    
//    UIImage *image = [UIImage imageNamed:@"cell_bg1.png"];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//    
//    // create the button object
//    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    
//    headerLabel.backgroundColor = [UIColor clearColor];
//    headerLabel.opaque = NO;
//    headerLabel.textColor = [UIColor whiteColor];
//    headerLabel.highlightedTextColor = [UIColor whiteColor];
//    headerLabel.font = [UIFont boldSystemFontOfSize:20];
//    headerLabel.frame = CGRectMake(0.0, 0.0, 320.0, 22.0);
//    
//    headerLabel.text = [self tableView:tableView titleForHeaderInSection:section];
//    
//    [customView addSubview:imageView];
//    [customView addSubview:headerLabel];
//    
//    return customView;
//}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    rowInc++;
    
    
    NSString *incStr = [NSString stringWithFormat:@"1%lu%lu",indexPath.section,indexPath.row];
    NSString *decStr = [NSString stringWithFormat:@"2%lu%lu",indexPath.section,indexPath.row];
    NSString *idLabelStr = [NSString stringWithFormat:@"1%lu%lu6",indexPath.section,indexPath.row];
    NSString *buyButtonStr = [NSString stringWithFormat:@"1%lu%lu7",indexPath.section,indexPath.row];
    
    //CCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *oldidentifier = @"Cell";
    NSString *identifier = [NSString stringWithFormat:@"%@%ld%ld",identity, indexPath.row,indexPath.section];
    //CCell *oldcell = [tableView dequeueReusableCellWithIdentifier:oldidentifier];
    //CCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    NSLog(@"Identified %@", identifier);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    
        
        cell.layer.opaque = YES;
        
        cell.opaque = YES;
    
    
        
    //[pricelabel release];
//    if (cell != nil)
//        return cell;
    
    //cell = [[CCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier];
//    //CCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//    if (cell == nil) {
//        cell = [[CCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
//        //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
//        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
    
     NSString *imageUrl = [NSString alloc];
    // Configure the cell...
    NSArray *categoryArray = [subcategoryDataArray objectAtIndex:indexPath.section];

    //NSLog(@"categoryArray %@",categoryArray);
    
    NSLog(@"--------------------------------------------------------------------------");
    NSLog(@"indexPath.row %ld indexPath.section %ld rowInc %ld",indexPath.row, indexPath.section,rowInc);
    NSLog(@"--------------------------------------------------------------------------");
    
    NSArray *subCateg = [categoryArray valueForKey:@"subcategories"];
    NSMutableArray *subcategoryData = subCateg[indexPath.row];
    
    NSString *categoryName = [subcategoryData valueForKey:@"name"];
    NSString *categoryID = [subcategoryData valueForKey:@"product_id"];
    NSString *categoryPrice = [subcategoryData valueForKey:@"price"];
    NSString *categoryAlcohol = [subcategoryData valueForKey:@"sku"];//This has alcohol content details.
    NSString *categoryVolume = [subcategoryData valueForKey:@"weight"];//This has volume in liter.
    NSString *imageName = [subcategoryData valueForKey:@"image"];
    //NSLog(@"Default image %@ %ld",imageName,[imageName length]);
    
    if ([imageName length] != 0) {
        imageName = [NSString stringWithFormat:@"image/%@",imageName];
    }else {
        imageName = @"Beer_cell_default.png";
    }
    
    
    
    //NSLog(@"category id %@ Name %@ Image %@",categoryID,categoryName,imageName);
    
    UIImage *image;
    imageUrl = [NSString stringWithFormat:@"%@",[[GlobalData sharedGlobalData]buildHost:imageName]];
    
    imageUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"Image url %@",imageUrl);
    
//    if ([[GlobalData sharedImageCache] DoesExist:imageUrl] == true) {
//        image = [[GlobalData sharedImageCache] GetImage:imageUrl];
//        NSLog(@"Loading image from cache");
//    }else{
//        NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl]];
//        if(imageData == nil){
//            NSLog(@"bad image");
//            image = [UIImage imageNamed:@"Beer_cell.png"];
//
////            imageUrl = [NSString stringWithFormat:@"%@",[[GlobalData sharedGlobalData]buildHost:@"Beer_cell.png"]];
////            if ([[GlobalData sharedImageCache] DoesExist:imageUrl] == true) {
////                image = [[GlobalData sharedImageCache] GetImage:imageUrl];
////                NSLog(@"Loading image from cache");
////            }else{
////                imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl]];
////                image = [[UIImage alloc] initWithData:imageData];
////            }
//            
//        }
//        
//        [[GlobalData sharedImageCache]AddImage:imageUrl :image];
//        NSLog(@"No image in cache loading url");
//    }
    UIImageView *sImage =[[UIImageView alloc] initWithFrame:CGRectMake(8,10,78,81)];
    [sImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"beer_cell.png"]];
//    UIImageView *subCategoryImage = (UIImageView *)[oldcell viewWithTag:1];
//    UILabel *subCategoryName = (UILabel *)[oldcell viewWithTag:2];
//    UILabel *subCategoryPrice = (UILabel *)[oldcell viewWithTag:3];
//    UILabel *subCategoryAlcohol = (UILabel *)[oldcell viewWithTag:4];
//    UILabel *subCategoryQty = (UILabel *)[oldcell viewWithTag:5];
//    
//    NSLog(@"subCategoryImage %@",subCategoryImage);
    
    //[cell.contentView addSubview: subCategoryImage];
    //[cell.contentView addSubview: subCategoryName];
    
    float price = [categoryPrice floatValue];
    float liter = [categoryVolume floatValue];
    NSString *floatWithoutZeroes = [[NSNumber numberWithFloat:price] stringValue];
    
    //subCategoryImage.image = image;
//    subCategoryName.text = categoryName;
//    subCategoryPrice.text = floatWithoutZeroes;
//    floatWithoutZeroes = [[NSNumber numberWithFloat:liter] stringValue];
//    
//
//    subCategoryAlcohol.text = [NSString stringWithFormat:@"alcohol is %@",categoryAlcohol];
//    subCategoryQty.text = [NSString stringWithFormat:@"ml %@", floatWithoutZeroes];
//    
//    //cell.imageView.image = image;
//    
//    if (![cell.backgroundView isKindOfClass:[CustomCellBackground class]]) {
//        cell.backgroundView = [[CustomCellBackground alloc] init];
//    }
//    
//    if (![cell.selectedBackgroundView isKindOfClass:[CustomCellBackground class]]) {
//        cell.selectedBackgroundView = [[CustomCellBackground alloc] init];
//    }
//    
//    [subCategoryName setFont:[UIFont fontWithName:@"DINPro-CondensedRegular" size:20]];
//    [subCategoryPrice setFont:[UIFont fontWithName:@"DINPro-CondensedRegular" size:14]];
//    [subCategoryAlcohol setFont:[UIFont fontWithName:@"DINPro-CondensedRegular" size:13]];

//    cell.incButton = (UIButton *)[oldcell viewWithTag:11];
//    cell.decButton = (UIButton *)[oldcell viewWithTag:10];
//    cell.idLabel = (UILabel *)[oldcell viewWithTag:12];
//    cell.idLabelTemp = (UILabel *)[oldcell viewWithTag:30];
//    
//    cell.buyButton = (UIButton *)[cell viewWithTag:15];
//    
//    cell.incButton.layer.borderWidth = .5f;
//    cell.decButton.layer.borderWidth = .5f;
//    cell.idLabel.layer.borderWidth = .5f;
//    
//    NSLog(@"IncTag--------- %@   DecTag ------- %@ ----- %@ ----- %@",incStr,decStr,idLabelStr, subCategoryName.text);
//    NSInteger incTag = [incStr integerValue];
//    NSInteger decag = [decStr integerValue];
//    NSInteger idLabelTag = [idLabelStr integerValue];
//    cell.incButton.tag = incTag;
//    [cell.incButton addTarget:self action:@selector(incButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    cell.decButton.tag = decag;
//    [cell.decButton addTarget:self action:@selector(decButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    cell.idLabel.tag = idLabelTag;
//    
//    cell.idLabelTemp.text = idLabelStr;
    
    //NSString *celltext=[NSString stringWithFormat:@"%ld",indexPath.row];
    
//    NSMutableArray *dArray = [[NSMutableArray alloc] init];
//    if (cell.idLabel != nil) {
//        [dArray insertObject:cell.idLabel atIndex:0];
//        [dArray insertObject:indexPath atIndex:1];
//    }
//    
//    
//    cell.idLabel.text = @"0";
//    if(cell.idLabel != nil){
//        cell.incButton.accessibilityCustomActions = [NSArray arrayWithObject: dArray];
//        cell.decButton.accessibilityCustomActions = [NSArray arrayWithObject: dArray];
//        
//        cell.idLabel.accessibilityCustomActions = [NSArray arrayWithObjects:cell.buyButton, nil];
//        
//        
//
//        //cell.hiddenLabel.accessibilityCustomActions = [NSArray arrayWithObjects:indexPath];
//    }
//    
//    //This will create dynamic buy button.
//    cell.buyButton.tag = indexPath.row;
//    [cell.buyButton addTarget:self action:@selector(buyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    
//    cell.buyButton.enabled = FALSE;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        NSLog(@"Label name %f %f %f %f %@ %@",subCategoryName.frame.origin.x, subCategoryName.frame.origin.y, subCategoryName.frame.size.width,subCategoryName.frame.size.height,subCategoryName.font.familyName, subCategoryName.font);
//        NSLog(@"Image name %f %f %f %f",subCategoryImage.frame.origin.x, subCategoryImage.frame.origin.y, subCategoryImage.frame.size.height,subCategoryImage.frame.size.width);
//        NSLog(@"Price name %f %f %f %f %@ %@",subCategoryPrice.frame.origin.x, subCategoryPrice.frame.origin.y, subCategoryPrice.frame.size.width,subCategoryPrice.frame.size.height, subCategoryPrice.font, subCategoryPrice.textColor);
//        NSLog(@"Alcohol name %f %f %f %f %@",subCategoryAlcohol.frame.origin.x, subCategoryAlcohol.frame.origin.y, subCategoryAlcohol.frame.size.width,subCategoryAlcohol.frame.size.height, subCategoryAlcohol.font);
//        NSLog(@"Qty name %f %f %f %f %@",subCategoryQty.frame.origin.x, subCategoryQty.frame.origin.y, subCategoryQty.frame.size.width,subCategoryQty.frame.size.height, subCategoryQty.font);
        
        
        //NSLog(@"inc Button  %f %f %f %f %@ %@",cell.incButton.frame.origin.x, cell.incButton.frame.origin.y, cell.incButton.frame.size.width,cell.incButton.frame.size.height, cell.incButton.font, cell.incButton);
//        NSLog(@"dec Button  %f %f %f %f %@ %@",cell.decButton.frame.origin.x, cell.decButton.frame.origin.y, cell.decButton.frame.size.width,cell.decButton.frame.size.height, cell.decButton.font, cell.decButton);
//        
//        NSLog(@"label id  %f %f %f %f %@ %@",cell.idLabel.frame.origin.x, cell.idLabel.frame.origin.y, cell.idLabel.frame.size.width,cell.idLabel.frame.size.height, cell.idLabel.font, cell.idLabel);
        
        //NSLog(@"buy id  %f %f %f %f %@ %@",cell.buyButton.frame.origin.x, cell.buyButton.frame.origin.y, cell.buyButton.frame.size.width,cell.buyButton.frame.size.height, cell.buyButton.font, cell.buyButton);
        
        UILabel *productName = [[UILabel alloc] initWithFrame:CGRectMake(125,10,243,23)];
        //productName.tag = [idLabelStr integerValue];
        productName.text = categoryName;
        [productName setFont:[UIFont fontWithName:@"DINPro-CondensedRegular" size:20.0]];
        //[productName setTextColor:[UIColor whiteColor]];
        //[productName setBackgroundColor:[UIColor clearColor]];
        
        //[cell.contentView addSubview: productName];
        
        UILabel *productPrice = [[UILabel alloc] initWithFrame:CGRectMake(125,34,243,23)];
        NSString *priceString = [[NSNumber numberWithFloat:price] stringValue];
        priceString = [NSString stringWithFormat:@"%@ ₹",priceString];
        //productPrice.tag = [idLabelStr integerValue];
        productPrice.text = priceString;
        [productPrice setFont:[UIFont fontWithName:@"DINPro-CondensedRegular" size:14.0]];
        productPrice.textColor = [UIColor colorWithRed:0 green:0.501961 blue:1.0 alpha:1.0];
        //[productName setTextColor:[UIColor whiteColor]];
        //[productName setBackgroundColor:[UIColor clearColor]];
        
        
        //[cell.contentView addSubview: productPrice];

        
        UILabel *productAlcoholPercentage = [[UILabel alloc] initWithFrame:CGRectMake(125,34,243,51)];
        //productAlcoholPercentage.tag = [idLabelStr integerValue];
        productAlcoholPercentage.text = [NSString stringWithFormat:@"alcohol is %@ %%",categoryAlcohol];;
        [productAlcoholPercentage setFont:[UIFont fontWithName:@"DINPro-CondensedRegular" size:13.0]];
        productAlcoholPercentage.textColor = [UIColor colorWithRed:0 green:0.501961 blue:1.0 alpha:1.0];
        //[productName setTextColor:[UIColor whiteColor]];
        //[productName setBackgroundColor:[UIColor clearColor]];
        
        //[cell.contentView addSubview: productAlcoholPercentage];

        UILabel *productQty = [[UILabel alloc] initWithFrame:CGRectMake(125,64,94,23)];
        NSString *qtyString = [[NSNumber numberWithFloat:liter] stringValue];
        qtyString = [NSString stringWithFormat:@"%@ ml",qtyString];
        //productQty.tag = [idLabelStr integerValue];
        productQty.text = qtyString;
        [productQty setFont:[UIFont fontWithName:@"DINPro-CondensedRegular" size:13.0]];
        productQty.textColor = [UIColor colorWithRed:0 green:0.501961 blue:1.0 alpha:1.0];
        //[productName setTextColor:[UIColor whiteColor]];
        //[productName setBackgroundColor:[UIColor clearColor]];
        
        //[cell.contentView addSubview: productQty];
        
//        UIImageView *sImage =[[UIImageView alloc] initWithFrame:CGRectMake(8,10,78,81)];
//        sImage.image = image;
        //[cell.contentView addSubview: sImage];

        //font-family: "DINPro-CondensedRegular"; font-weight: normal; font-style: normal; font-size: 20.00pt
        
        UIColor *whiteColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        NSMutableDictionary *cartArrayTemp = [[NSMutableDictionary alloc] init];
        
        
        [cartArrayTemp setValue:categoryID forKey:@"productID"];
        [cartArrayTemp setValue:categoryName forKey:@"productName"];
        [cartArrayTemp setValue:categoryPrice forKey:@"productPrice"];
        [cartArrayTemp setValue:@"Offer1" forKey:@"productOffer"];
        [cartArrayTemp setValue:idLabelStr forKey:@"idLabelStr"];
        

        UIButton *incButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        incButton.tag = [incStr integerValue];
//        incButton.frame = CGRectMake(324.0f, 34.0f, 22.0f, 19.5f);
        incButton.frame = CGRectMake(324.0f, 7.0f, 22.0f, 28.5f);
        [incButton setTitle:@"+" forState:UIControlStateNormal];
        incButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        incButton.titleLabel.font = [UIFont fontWithName:@"DINPro-CondensedRegular" size:13.0];
        incButton.layer.borderWidth = 1.0f;
        incButton.layer.borderColor = [UIColor colorWithRed:0 green:0.501961 blue:1.0 alpha:1.0].CGColor;
        //incButton.layer.borderColor = [UIColor lightGrayColor].CGColor;

        incButton.layer.cornerRadius = 5;
        incButton.clipsToBounds = YES;
        incButton.layer.masksToBounds = YES;
        incButton.accessibilityCustomActions = [NSArray arrayWithObject: cartArrayTemp];
        
        //[cell addSubview:incButton];
        
        
        
        
        [incButton addTarget:self
                         action:@selector(qtyAddButtonAction:)
               forControlEvents:UIControlEventTouchUpInside];
        //286 19; 22 19.5
        
        UIButton *decButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        decButton.tag = [incStr integerValue];
//        decButton.frame = CGRectMake(286.0f, 34.0f, 22.0f, 19.5f);
        decButton.frame = CGRectMake(289.0f, 7.0f, 22.0f, 28.5f);
        [decButton setTitle:@"-" forState:UIControlStateNormal];
        decButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        decButton.titleLabel.font = [UIFont fontWithName:@"DINPro-CondensedRegular" size:13.0];
        decButton.layer.borderWidth = 1.0f;
        decButton.layer.borderColor = [UIColor colorWithRed:0 green:0.501961 blue:1.0 alpha:1.0].CGColor;
        decButton.layer.cornerRadius = 5;
        decButton.clipsToBounds = YES;
        decButton.layer.masksToBounds = YES;
        decButton.accessibilityCustomActions = [NSArray arrayWithObject: cartArrayTemp];
        
        //[cell addSubview:decButton];
        
        [decButton addTarget:self
                      action:@selector(qtyDelButtonAction:)
            forControlEvents:UIControlEventTouchUpInside];
        
        
//        UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(305.0f, 34.0f, 22.0f, 19.5f)];
        UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(306.0f, 7.0f, 22.0f, 28.5f)];
        idLabel.tag = [idLabelStr integerValue];
        idLabel.text = @"0";
        idLabel.textAlignment = NSTextAlignmentCenter;
        [idLabel setFont:[UIFont fontWithName:@"DINPro-CondensedRegular" size:12.0]];
        idLabel.textColor = [UIColor blackColor];
        idLabel.layer.borderColor = [UIColor colorWithRed:0 green:0.501961 blue:1.0 alpha:1.0].CGColor;
        idLabel.layer.borderWidth = 1.0f;
        
        //[cell.contentView addSubview: idLabel];

        UIView* mask = [[UIView alloc] initWithFrame:CGRectMake(1, 0, incButton.frame.size.width - 1, incButton.frame.size.height)];
        mask.backgroundColor = [UIColor blackColor];
        mask.layer.cornerRadius = 5;
        mask.clipsToBounds = YES;
        mask.layer.masksToBounds = YES;
        
        incButton.layer.mask = mask.layer;
        
        

        UIView* mask1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, decButton.frame.size.width - 1, decButton.frame.size.height)];
        mask1.backgroundColor = [UIColor blackColor];
        mask1.layer.cornerRadius = 5;
        mask1.clipsToBounds = YES;
        mask1.layer.masksToBounds = YES;

        decButton.layer.mask = mask1.layer;
        
        
        
        UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        buyButton.tag = [buyButtonStr integerValue];
        buyButton.frame = CGRectMake(295.0f, 56.0f, 44.0f, 44.0f);
        buyButton.enabled = FALSE;
        UIImage *buyImage = [UIImage imageNamed:@"buy_now.png"];
        [buyButton setImage:buyImage forState:UIControlStateNormal];
        buyButton.accessibilityCustomActions = [NSArray arrayWithObject: cartArrayTemp];
        [buyButton addTarget:self
                      action:@selector(buyButtonClicked:)
            forControlEvents:UIControlEventTouchUpInside];
        
        
        dispatch_queue_t queue = dispatch_queue_create("myqueue", NULL);
        dispatch_async(queue, ^{
            // create UIwebview, other things too
            
            // Perform on main thread/queue
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell.contentView addSubview: idLabel];
                [cell addSubview:incButton];
                [cell addSubview:decButton];
                [cell addSubview:buyButton];
                
                [cell addSubview: productAlcoholPercentage];
                [cell addSubview: productQty];
                [cell addSubview: productPrice];
                [cell addSubview: productName];
                [cell addSubview: sImage];
            });
        });
        
        
    }    
        
        
    
    
    return cell;
    
}


- (IBAction)qtyAddButtonAction:(id)sender
{
    NSLog(@"Add friend.");
    UIButton *updateButton = (UIButton *)sender;
    NSLog(@"%li %@", updateButton.tag,sender);
    
    CCell *cell = (CCell *)updateButton.superview.superview;
    
    NSString *idLabelStr = [NSString stringWithFormat:@"%lu6",updateButton.tag];
    
    NSString *buyButtonStr = [NSString stringWithFormat:@"%lu7",updateButton.tag];
    
    UIButton *buyButton = (UIButton *)[cell viewWithTag:[buyButtonStr integerValue]];
    NSLog(@"%@", buyButton);

    NSLog(@"%@", sender);
    NSLog(@"Tag %lu lbTag %@",updateButton.tag, idLabelStr);
    NSInteger idLabelTag = [idLabelStr integerValue];
    UILabel *idLabel = (UILabel *)[cell viewWithTag:idLabelTag];
    NSLog(@"Label %@",idLabel.text);
    NSInteger myInt = [idLabel.text intValue];
    myInt++;
    NSString *strFromInt = [NSString stringWithFormat:@"%li",myInt];
    
    idLabel.text = strFromInt;
    
    if(myInt > 0){
        buyButton.enabled = TRUE;
    }
    [self buildCartArray:sender];
}

- (IBAction)qtyDelButtonAction:(id)sender
{
    NSLog(@"Add friend.");
    
    UIButton *updateButton = (UIButton *)sender;
    NSLog(@"%li %@", updateButton.tag,sender);
    
    CCell *cell = (CCell *)updateButton.superview.superview;
    
    NSString *idLabelStr = [NSString stringWithFormat:@"%lu6",updateButton.tag];
    NSString *buyButtonStr = [NSString stringWithFormat:@"%lu7",updateButton.tag];

    UIButton *buyButton = (UIButton *)[cell viewWithTag:[buyButtonStr integerValue]];
    NSLog(@"%@", buyButton);
    NSLog(@"Tag %lu lbTag %@",updateButton.tag, idLabelStr);
    NSInteger idLabelTag = [idLabelStr integerValue];
    UILabel *idLabel = (UILabel *)[cell viewWithTag:idLabelTag];
    NSLog(@"Label %@",idLabel.text);
    NSInteger myInt = [idLabel.text intValue];
    if(myInt == 0){
        buyButton.enabled = FALSE;
        return;
    }else{
        myInt--;
        NSString *strFromInt = [NSString stringWithFormat:@"%li",myInt];
        
        idLabel.text = strFromInt;
        if (myInt == 0) {
            buyButton.enabled = FALSE;
        }
    }
    [self buildCartArray:sender];
}


-(void)buyButtonClicked:(UIButton*)sender
{
    NSLog(@"Cart Array %@",cartArray);
    NSLog(@"buyButtonClicked Button clicked %lu",sender.tag);
//    UIButton *updateButton = (UIButton *)sender;
//    CCell *cell = (CCell *)updateButton.superview.superview;
//
//    NSLog(@"%li %@", updateButton.tag,sender);
//    NSArray *arrHeart = (NSArray *)updateButton.accessibilityCustomActions;
//    
//    NSString *idLabelStr = arrHeart[0][4];
//    NSInteger idLabelTag = [idLabelStr integerValue];
//
//    UILabel *qtyLabel = (UILabel *)[cell viewWithTag:idLabelTag];
//    NSLog(@"Label %@",qtyLabel.text);
//
//    cartArray = arrHeart[0];
//    
//    //[cartArray insertObject:qtyLabel.text atIndex:5];
//    
//    NSLog(@"Cart Array %@",cartArray);
    NSString *cartConfigName = [NSString stringWithFormat:@"%@Cart- ",@"sreeji.gopal@gmail.com"];
    
    NSArray *fetchSubCategoryData  = [self readSubCategoryData:cartConfigName];
    if([fetchSubCategoryData count] > 0){
        [self updateData:cartConfigName];
        [self addData:cartConfigName :cartArray];
    }else{
        [self addData:cartConfigName :cartArray];
    }
    
    [self performSegueWithIdentifier:@"Associate" sender:sender];
    
}



-(NSMutableDictionary*)buildCartArray:(UIButton*)sender{
    NSMutableArray *tempCart = [[NSMutableArray alloc] init];
    
    UIButton *updateButton = (UIButton *)sender;
    CCell *cell = (CCell *)updateButton.superview.superview;
    
    //NSLog(@"%li %@", updateButton.tag,sender);
    NSArray *arrHeart = (NSArray *)updateButton.accessibilityCustomActions;
    arrHeart = [arrHeart objectAtIndex:0];
    NSString *idLabelStr = [arrHeart valueForKey:@"idLabelStr"];
    NSInteger idLabelTag = [idLabelStr integerValue];
    
    UILabel *qtyLabel = (UILabel *)[cell viewWithTag:idLabelTag];
    
    
    
    NSLog(@"Key %@",[arrHeart valueForKey:@"productID"]);
    //[tempCart insertObject:qtyLabel.text atIndex:5];
    [arrHeart setValue:qtyLabel.text forKey:@"qty"];
    [cartArray removeObjectForKey:[arrHeart valueForKey:@"productID"]];
    if (![qtyLabel.text isEqualToString:@"0"]) {
        [cartArray setValue:arrHeart forKey:[arrHeart valueForKey:@"productID"]];
    }
    
    
    //[cartArray set:[tempCart objectAtIndex:0] forKey:tempCart];
    
    NSLog(@"Temp Array %@ Cart Array %@",tempCart, cartArray);
    return cartArray;
    
}

-(void)incButtonClicked:(UIButton*)sender
{
    CCell *cell = (CCell *)sender.superview.superview;
    NSString *idLabelStr = [NSString stringWithFormat:@"%lu6",sender.tag];
    NSLog(@"%@", sender);
    NSLog(@"Tag %lu lbTag %@",sender.tag, idLabelStr);
    NSInteger idLabelTag = [idLabelStr integerValue];
    UILabel *idLabel = (UILabel *)[cell viewWithTag:idLabelTag];
    NSLog(@"Label %@",idLabel.text);
    NSInteger myInt = [idLabel.text intValue];
    myInt++;
    NSString *strFromInt = [NSString stringWithFormat:@"%li",myInt];
   
    idLabel.text = strFromInt;

}

-(void)incButtonClicked1:(UIButton*)sender
{
    
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSIndexPath *rowNo = [self.tableView indexPathForSelectedRow];
    NSLog(@"Tag %lu",sender.tag);
    //NSLog(@"indexPath.row %ld indexPath.section %ld",indexPath.row, indexPath.section);
    
    UIButton *updateButton = (UIButton *)sender;
    
    //NSLog(@"%li", updateButton.tag);
    NSMutableArray *arrHeart = (NSMutableArray *)updateButton.accessibilityCustomActions;
    UILabel *lblHeart = (UILabel *)[arrHeart[0] objectAtIndex:0]; // getting 0th index of `accessibilityCustomActions` array.
    //    NSLog(@"222 %@", lblHeart.text);
    NSInteger myInt = [lblHeart.text intValue];
        //NSLog(@"222 %li", myInt++);
    myInt++;
    NSString *strFromInt = [NSString stringWithFormat:@"%li",myInt];
    
    lblHeart.text = strFromInt;
    
    NSIndexPath *sIndexPath = (NSIndexPath *)[arrHeart[0] objectAtIndex:1]; // getting 0th index of `accessibilityCustomActions` array.
    
    NSLog(@"***************************************************************************");
    NSLog(@"indexPath.row %ld indexPath.section %ld -- sindexPath.row %ld sindexPath.section %ld",indexPath.row, indexPath.section, sIndexPath.row, sIndexPath.section);
    NSLog(@"***************************************************************************");
    
    NSArray *arrBuyButton = (NSArray *)lblHeart.accessibilityCustomActions;
    if ((indexPath.row == rowNo.row) && (indexPath.section == rowNo.section) ){
        UIButton *buyButton = (UIButton *)[arrBuyButton objectAtIndex:0];;
        //NSLog(@"Inc Button clicked %lu %d",sender.tag, buyButton.enabled);
        if (myInt > 0) {
            buyButton.enabled = YES;
        }else{
            buyButton.enabled = NO;
        }
    }
    
    
}

-(void)decButtonClicked:(UIButton*)sender
{
    
    UIButton *updateButton = (UIButton *)sender;
    //NSLog(@"%li", updateButton.tag);
    NSArray *arrHeart = (NSArray *)updateButton.accessibilityCustomActions;
    UILabel *lblHeart = (UILabel *)[arrHeart objectAtIndex:0]; // getting 0th index of `accessibilityCustomActions` array.
        //NSLog(@"222 %@", lblHeart.text);
    NSInteger myInt = [lblHeart.text intValue];
    if(myInt == 0){
        return;
    }
        //NSLog(@"222 %li", myInt--);
    myInt--;
    NSString *strFromInt = [NSString stringWithFormat:@"%li",myInt];
    lblHeart.text = strFromInt;
    NSArray *arrBuyButton = (NSArray *)lblHeart.accessibilityCustomActions;
    
    UIButton *buyButton = (UIButton *)[arrBuyButton objectAtIndex:0];;
    //NSLog(@"Inc Button clicked %lu %d",sender.tag, buyButton.enabled);
    if (myInt > 0) {
        buyButton.enabled = YES;
    }else{
        buyButton.enabled = NO;
    }

    
    //NSLog(@"Dec Button clicked %lu",sender.tag);
    
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
    NSLog(@"Segu Clicked %@", cartArray);
    
    UINavigationController *navigationController = [segue destinationViewController];
    
    CartTableViewController *cartViewController = [navigationController childViewControllers].firstObject;
    cartViewController.cartArray = cartArray;
}


-(void)updateData :(NSString *) name {
    NSArray *fetchedConfig = [[CoreDataManager sharedManager]fetchPredicateEntityWithClassName:@"Config" :@"data_name" :name];
    // display all objects
    for (Config *config in fetchedConfig) {
        NSLog(@"Config %@  -- Date %@ ", [config.data description], [config.datetime description]);
        [[CoreDataManager sharedManager]deleteEntity: config];
    }
    [[CoreDataManager sharedManager]saveDataInManagedContextUsingBlock:^(BOOL saved, NSError *error){
        if(error != nil){
            NSLog(@"Saved");
        }else{
            NSLog(@"Save error %@",error);
        }
        
    }];
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
    
    //NSLog(@"Name %@ URL %@",name,urlRest);
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
        //NSLog(@"Config %@  -- Date %@ ", [config.data description], [config.datetime description]);
        
    }
    return fetchedConfig;
}

-(NSDictionary*)loadSubDisctionary{
    NSMutableDictionary *categData = [[NSMutableDictionary alloc]init];
    NSString *subCategoryName = [[NSString alloc]init];
    NSArray *subcategData = [[NSArray alloc]init];
    //NSLog(@"Sub Data %@",subcategoryDataArray);
    
    NSArray *subCateg = [subcategoryDataArray valueForKey:@"subcategories"];
    //NSLog(@"----XXXXX%@--- ",subCateg);
    
    
    for (NSMutableArray *columnItems  in subcategoryDataArray) {
        //NSLog(@"SubCategory - %@", [columnItems valueForKey:@"subcategory_name"]);
        subCategoryName = [columnItems valueForKey:@"subcategory_name"];
        
        subcategData = [columnItems valueForKey:@"subcategories"];
        //NSLog(@"Count of SubCategoryData %lu", (unsigned long)[subcategData count]);
        for (NSMutableArray *rowItems in subcategData) {
            //NSLog(@"Sub %@",[rowItems valueForKey:@"name"]);
            [categData setValue:[rowItems valueForKey:@"name"] forKey:subCategoryName];
        }
    }
    
    //NSLog(@"cagegData - %@",categData);
    sectionName = categData;
    return nil;
}

- (void)goBack {
    NSLog(@"xxx");
    //MainTableViewController *mainTableViewController = [[MainTableViewController alloc]init];
    //mainTableViewController.de
    //[self.navigationController pushViewController:mainTableViewController animated:YES];
    if(self.parentViewController)
        [self.parentViewController dismissModalViewControllerAnimated:YES];
    else
        [self.presentingViewController dismissModalViewControllerAnimated:YES];
    

}


- (UIImage *)imageByDrawingCircleOnImage:(UIImage *)image
{
    // begin a graphics context of sufficient size
    UIGraphicsBeginImageContext(image.size);
    
    // draw original image into the context
    [image drawAtPoint:CGPointZero];
    
    // get the context for CoreGraphics
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // set stroking color and draw circle
    [[UIColor redColor] setStroke];
    
    // make circle rect 5 px from border
    CGRect circleRect = CGRectMake(0, 0,
                                   image.size.width,
                                   image.size.height);
    circleRect = CGRectInset(circleRect, 5, 5);
    
    // draw circle
    CGContextStrokeEllipseInRect(ctx, circleRect);
    
    // make image out of bitmap context
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // free the context
    UIGraphicsEndImageContext();
    
    return retImage;
}

@end
