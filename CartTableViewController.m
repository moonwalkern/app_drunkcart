//
//  CartTableViewController.m
//  Drunkcart
//
//  Created by Sreeji Gopal on 08/03/16.
//  Copyright © 2016 Sreeji Gopal. All rights reserved.
//


#import "CartTableViewController.h"
#import "CustomHeader.h"
#import "Constants.h"
#import "GlobalData.h"
#import "CustomCellBackground.h"
#import "CategoryTableViewController.h"
#import "SVProgressHUD.h"
#import "PopupViewController1.h"
#import "STPopup.h"


@interface CartTableViewController (){
    NSDictionary *cartData;
    NSDictionary *textData;
    NSArray *cartSections;
    NSArray *cartNotSorted;
    NSInteger subTotal;
    NSString *backArray;
    NSString *sentArray;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}



@end



@implementation CartTableViewController
@synthesize cartArray;



- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *tempCart = [[NSMutableArray alloc]init];
    NSArray *fetchCategoryData;
    textData = [[NSMutableDictionary alloc]init];
    subTotal = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPopup:) name:@"getMobile" object:backArray];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showReload:) name:@"sentReload" object:sentArray];
    NSLog(@"Cart Array from %@ %ld",cartArray,[cartArray count]);
    [SVProgressHUD show];
    for(id key in cartArray) {
        id value = [cartArray objectForKey:key];
        NSLog(@"%@",[value valueForKey:@"productID"]);
        [tempCart addObject:[value valueForKey:@"productID"]];
    }
    //[tempCart addObject:@"Total"];
//    cartData = @{
//                 @"Delivery Details" : @[@"Name",@"Phone No",@"Email",@"OTP"],
//                 @"Cart" : tempCart,
//                 @"CartTotal" : @[@"Address"],
//                 @"Location" : @[@"Name",@"Phone No",@"Email",@"OTP"]
//                 };

    cartData = @{
                 @"Delivery Details" : @[@"Name",@"Phone No",@"Email",@"Zip",@"Appt#,"@"Address",@"Street",@"OTP"],
                 @"Cart" : tempCart,
                 @"CartTotal" : @[@"Address"]
                 };

    
    cartSections = [[cartData allKeys]sortedArrayUsingSelector:@selector(compare:)];
    //[SVProgressHUD dismiss];
    
    UIImage* image = [UIImage imageNamed:@"BackBtn.png"];
    CGRect frame = CGRectMake(0, 0, 40, 40);
    UIButton* backbtn = [[UIButton alloc] initWithFrame:frame];
    [backbtn setBackgroundImage:image forState:UIControlStateNormal];
    [backbtn setShowsTouchWhenHighlighted:YES];
    [backbtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    NSString *urlRest = [[GlobalData sharedGlobalData]buildHost:categoryURI];
    NSString *postData=[NSString stringWithFormat:@"device=iOS"];
    //fetchCategoryData = [[GlobalData sharedGlobalData] requestSynchronousData:urlRest :postData :@"POST"];
    
    
    //init location manager
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    //[locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    //[locationManager startUpdatingLocation];
    [self->locationManager requestWhenInUseAuthorization];  // For foreground access
    [self->locationManager requestAlwaysAuthorization]; // For background access
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return [cartSections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return [cartSections objectAtIndex:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CustomHeader * header = [[CustomHeader alloc] init];
    if ([[self tableView: tableView titleForHeaderInSection:section] isEqualToString:@"CartTotal" ]) {
        header.lightColor = [UIColor colorWithRed:0.887 green:1.000 blue:0.975 alpha:1.00];
        header = nil;
    }else{
        header.titleLabel.text = [self tableView: tableView titleForHeaderInSection:section];
        
        // START NEW
        if (section % 2) {
            //header.lightColor = [UIColor colorWithRed:147.0/255.0 green:105.0/255.0 blue:216.0/255.0 alpha:1.0];
            header.darkColor = [UIColor colorWithRed:72.0/255.0 green:22.0/255.0 blue:137.0/255.0 alpha:1.0];
        }
        // END NEW
    }
    
    return header;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    
    NSString *sectionTitle = [cartSections objectAtIndex:section];
    NSArray *sectionCart = [cartData objectForKey:sectionTitle];
    
    return [sectionCart count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[self tableView: tableView titleForHeaderInSection:section] isEqualToString:@"CartTotal" ]) {
        return 0;
    }else{
        return 50;
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSString *sectionTitle = [cartSections objectAtIndex:indexPath.section];
    NSArray *sectionArray = [cartData objectForKey:sectionTitle];
    NSString *prodcutID = [sectionArray objectAtIndex:indexPath.row];
    //cell.textLabel.text = sectionTitle;
    //cell.imageView.image = [UIImage imageNamed:[self getImageFilename:animal]];
    
    [SVProgressHUD show];
    
    if (![cell.backgroundView isKindOfClass:[CustomCellBackground class]]) {
        cell.backgroundView = [[CustomCellBackground alloc] init];
    }
    
    if (![cell.selectedBackgroundView isKindOfClass:[CustomCellBackground class]]) {
        cell.selectedBackgroundView = [[CustomCellBackground alloc] init];
    }
    
    if ([sectionTitle isEqualToString:@"Cart" ]) {
        
        NSString *incStr = [NSString stringWithFormat:@"1%lu%lu",indexPath.section,indexPath.row];
        NSString *decStr = [NSString stringWithFormat:@"2%lu%lu",indexPath.section,indexPath.row];
        
        NSString *costLabelStr = [NSString stringWithFormat:@"1%lu%lu7",indexPath.section,indexPath.row];
        
        cell.layer.opaque = YES;
        
        cell.opaque = YES;
        
        
        NSDictionary *cellCartArray = [cartArray objectForKey:prodcutID];
        //NSLog(@"Card Data %@",[cartArray objectForKey:prodcutID]);
        UILabel *productName = [[UILabel alloc] initWithFrame:CGRectMake(25,10,243,23)];
        //productName.tag = [idLabelStr integerValue];
        productName.text = [cellCartArray objectForKey:@"productName"];
        [productName setFont:[UIFont fontWithName:@"DINPro-CondensedRegular" size:16.0]];
        //[productName setTextColor:[UIColor whiteColor]];
        //[productName setBackgroundColor:[UIColor clearColor]];
        
        [cell.contentView addSubview: productName];
        
        
        NSString *idLabelStr = [cellCartArray objectForKey:@"idLabelStr"];
        
        float price = [[cellCartArray objectForKey:@"productPrice"] floatValue];
        
        NSString *priceString = [[NSNumber numberWithFloat:price] stringValue];
        priceString = [NSString stringWithFormat:@"%@ ₹",priceString];
        
        float qty = [[cellCartArray objectForKey:@"qty"] floatValue];

        NSString *productQtyString = [[NSNumber numberWithFloat:qty] stringValue];
        
        float total = price * qty;
        subTotal = subTotal + total;
        NSString *totalString = [[NSNumber numberWithFloat:total] stringValue];
        
        totalString = [NSString stringWithFormat:@"%@ ₹",totalString];
        
        UILabel *productPrice = [[UILabel alloc] initWithFrame:CGRectMake(30,34,243,23)];

        //productPrice.tag = [idLabelStr integerValue];
        productPrice.text = priceString;
        [productPrice setFont:[UIFont fontWithName:@"DINPro-CondensedRegular" size:14.0]];
        productPrice.textColor = [UIColor colorWithRed:0 green:0.501961 blue:1.0 alpha:1.0];
        //[productName setTextColor:[UIColor whiteColor]];
        //[productName setBackgroundColor:[UIColor clearColor]];
        
        [cell.contentView addSubview: productPrice];

        
        UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(119.0f, 36.0f, 22.0f, 19.5f)];
        idLabel.tag = [idLabelStr integerValue];
        idLabel.text = productQtyString;
        idLabel.textAlignment = NSTextAlignmentCenter;
        [idLabel setFont:[UIFont fontWithName:@"DINPro-CondensedRegular" size:12.0]];
        idLabel.textColor = [UIColor blackColor];
        idLabel.layer.borderColor = [UIColor colorWithRed:0 green:0.501961 blue:1.0 alpha:1.0].CGColor;
        idLabel.layer.borderWidth = 1.0f;

        [cell.contentView addSubview: idLabel];
        
        
        UIButton *incButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        incButton.tag = [incStr integerValue];
        incButton.frame = CGRectMake(138.0f, 36.0f, 22.0f, 19.5f);
        [incButton setTitle:@"+" forState:UIControlStateNormal];
        incButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        incButton.titleLabel.font = [UIFont fontWithName:@"DINPro-CondensedRegular" size:13.0];
        incButton.layer.borderWidth = 1.0f;
        incButton.layer.borderColor = [UIColor colorWithRed:0 green:0.501961 blue:1.0 alpha:1.0].CGColor;
        //incButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        incButton.layer.cornerRadius = 5;
        incButton.clipsToBounds = YES;
        incButton.layer.masksToBounds = YES;
        incButton.accessibilityCustomActions = [NSArray arrayWithObject: cellCartArray];
        
        [cell addSubview:incButton];
        
        [incButton addTarget:self
                      action:@selector(qtyAddButtonAction:)
            forControlEvents:UIControlEventTouchUpInside];
        //286 19; 22 19.5
        
        UIButton *decButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        decButton.tag = [incStr integerValue];
        decButton.frame = CGRectMake(100.0f, 36.0f, 22.0f, 19.5f);
        [decButton setTitle:@"-" forState:UIControlStateNormal];
        decButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        decButton.titleLabel.font = [UIFont fontWithName:@"DINPro-CondensedRegular" size:13.0];
        decButton.layer.borderWidth = 1.0f;
        decButton.layer.borderColor = [UIColor colorWithRed:0 green:0.501961 blue:1.0 alpha:1.0].CGColor;
        decButton.layer.cornerRadius = 5;
        decButton.clipsToBounds = YES;
        decButton.layer.masksToBounds = YES;
        decButton.accessibilityCustomActions = [NSArray arrayWithObject: cellCartArray];
        
        [cell addSubview:decButton];
        
        [decButton addTarget:self
                      action:@selector(qtyDelButtonAction:)
            forControlEvents:UIControlEventTouchUpInside];
        
        
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
        
        
        UILabel *idLabelMultiplySign = [[UILabel alloc] initWithFrame:CGRectMake(76,34,243,23)];
        idLabelMultiplySign.text = @"x";
        [idLabelMultiplySign setFont:[UIFont fontWithName:@"DINPro-CondensedRegular" size:18.0]];
        idLabelMultiplySign.textColor = [UIColor colorWithRed:1.000 green:0.045 blue:1.000 alpha:1.00];
        
        
        [cell.contentView addSubview: idLabelMultiplySign];

        
        UILabel *idLabelCost = [[UILabel alloc] initWithFrame:CGRectMake(286,34,243,23)];
        idLabelCost.text = totalString;
        idLabelCost.tag = [costLabelStr integerValue];
        [idLabelCost setFont:[UIFont fontWithName:@"DINPro-CondensedRegular" size:16.0]];
        idLabelCost.textColor = [UIColor colorWithRed:0 green:0.501961 blue:1.0 alpha:1.0];
        
        
        [cell.contentView addSubview: idLabelCost];
        
        
    }else if ([sectionTitle isEqualToString:@"CartTotal" ]){
        
        NSString *subTotalString = [[NSNumber numberWithFloat:subTotal] stringValue];
        subTotalString = [NSString stringWithFormat:@"%@ ₹",subTotalString];
        
        
        UILabel *subLabelTotal = [[UILabel alloc] initWithFrame:CGRectMake(30,14,243,23)];
        
        
        subLabelTotal.text = @"Sub Total";
        [subLabelTotal setFont:[UIFont fontWithName:@"DINPro-CondensedRegular" size:20.0]];
        subLabelTotal.textColor = [UIColor colorWithRed:1.000 green:0.043 blue:0.132 alpha:1.00];

        [cell.contentView addSubview: subLabelTotal];
        
        UILabel *idLabelTotalCost = [[UILabel alloc] initWithFrame:CGRectMake(286,14,243,23)];
        idLabelTotalCost.tag = 10007;
        idLabelTotalCost.text = subTotalString;
        [idLabelTotalCost setFont:[UIFont fontWithName:@"DINPro-CondensedRegular" size:18.0]];
        idLabelTotalCost.textColor =  [UIColor colorWithRed:1.000 green:0.043 blue:0.132 alpha:1.00];
        
        
        [cell.contentView addSubview: idLabelTotalCost];

    }else if ([sectionTitle isEqualToString:@"Delivery Details" ]){
        
        if(![sectionArray[indexPath.row] isEqualToString:@"OTP"]){      //This draws 
            UITextField *textCustomerDetails;
            NSInteger indexTag = [[NSString stringWithFormat:@"%lu%lu",indexPath.section,indexPath.row] integerValue];
            NSString *indexText = [NSString stringWithFormat:@"%ld",indexTag];
            [textData setValue:indexText forKey:sectionArray[indexPath.row]];
            if ([sectionArray[indexPath.row] isEqualToString:@"Zip"]) {
                textCustomerDetails = [[UITextField alloc] initWithFrame:CGRectMake(25,8,183,25)];
                UIButton *zipButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                //incButton.tag = [incStr integerValue];
                zipButton.frame = CGRectMake(230,8,33,25);
                //[zipButton setTitle:@"LOC" forState:UIControlStateNormal];
                zipButton.titleLabel.textAlignment = NSTextAlignmentCenter;
                zipButton.titleLabel.font = [UIFont fontWithName:@"DINPro-CondensedRegular" size:13.0];
                //zipButton.layer.borderWidth = 1.0f;
                //otpButton.layer.borderColor = [UIColor colorWithRed:0 green:0.501961 blue:1.0 alpha:1.0].CGColor;
                //zipButton.layer.backgroundColor = [[UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1.00]CGColor];
                
                zipButton.layer.cornerRadius = 5;
                zipButton.clipsToBounds = YES;
                zipButton.layer.masksToBounds = YES;
                
                
                UIImageView *sImage =[[UIImageView alloc] initWithFrame:CGRectMake(230,8,33,25)];
                UIImage *lImage = [UIImage imageNamed:@"Location.png"];
                [sImage setImage:lImage];
                [zipButton setBackgroundImage:lImage forState:UIControlStateNormal];
                //incButton.accessibilityCustomActions = [NSArray arrayWithObject: cellCartArray];
                [zipButton addTarget:self
                              action:@selector(locationButtonAction:)
                    forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview: zipButton];

            }else{
                textCustomerDetails = [[UITextField alloc] initWithFrame:CGRectMake(25,8,243,25)];
            }
            
            textCustomerDetails.tag = indexTag;
            textCustomerDetails.placeholder = sectionArray[indexPath.row];
            //textCustomerDetails.text = sectionArray[indexPath.row];
            [textCustomerDetails setFont:[UIFont fontWithName:@"DINPro-CondensedRegular" size:18.0]];
            textCustomerDetails.textColor =  [UIColor colorWithRed:1.000 green:0.043 blue:0.132 alpha:1.00];
            textCustomerDetails.returnKeyType = UIReturnKeyDone;
            //        textCustomerDetails.layer.cornerRadius=2.0f;
            //        textCustomerDetails.layer.masksToBounds=YES;
            //        textCustomerDetails.layer.borderColor=[[UIColor redColor]CGColor];
            //        textCustomerDetails.layer.borderWidth= 1.0f;
            textCustomerDetails.borderStyle = UITextBorderStyleRoundedRect;
                        [cell.contentView addSubview: textCustomerDetails];
        }
        else if([sectionArray[indexPath.row] isEqualToString:@"OTP"]){
            
            UIButton *otpButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            //incButton.tag = [incStr integerValue];
            otpButton.frame = CGRectMake(25,8,243,25);
            [otpButton setTitle:@"Sent OTP" forState:UIControlStateNormal];
            otpButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            otpButton.titleLabel.font = [UIFont fontWithName:@"DINPro-CondensedRegular" size:13.0];
            otpButton.layer.borderWidth = 1.0f;
            //otpButton.layer.borderColor = [UIColor colorWithRed:0 green:0.501961 blue:1.0 alpha:1.0].CGColor;
            otpButton.layer.backgroundColor = [[UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1.00]CGColor];
            
            otpButton.layer.cornerRadius = 5;
            otpButton.clipsToBounds = YES;
            otpButton.layer.masksToBounds = YES;
            //incButton.accessibilityCustomActions = [NSArray arrayWithObject: cellCartArray];
            [otpButton addTarget:self
                          action:@selector(otpSendButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview: otpButton];
        }
        

        
        
        
    }
    [SVProgressHUD dismiss];
    
    return cell;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return 80;
    }else{
        if ([[self tableView: tableView titleForHeaderInSection:indexPath.section] isEqualToString:@"CartTotal" ]) {
            return 60;
        }else{
            return 44;
        }
    }
}

- (IBAction)locationButtonAction:(id)sender
{
    NSLog(@"Location");
    UIButton *updateButton = (UIButton *)sender;
    NSLog(@"%li %@", updateButton.tag,sender);
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *lastLocation = [locations lastObject];
    
    NSLog(@" Location %@ ", lastLocation);
    
    NSLog(@"Latitude %f",lastLocation.coordinate.latitude);
    NSLog(@"Latitude %f",lastLocation.coordinate.latitude);
    
    geocoder = [[CLGeocoder alloc] init];
    
    
    [locationManager stopUpdatingLocation];
    
    //[geocoder reverseGeocodeLocation:<#(nonnull CLLocation *)#> completionHandler:<#^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error)completionHandler#>]
    
    [geocoder reverseGeocodeLocation:lastLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            NSString *get = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                             placemark.subThoroughfare, placemark.thoroughfare,
                             placemark.postalCode, placemark.locality,
                             placemark.administrativeArea,
                             placemark.country];
            NSLog(@"State -: %@", placemark.administrativeArea);
            NSLog(@"Country -: %@", placemark.country);
            NSLog(@"Zip -: %@", placemark.postalCode);

            //txtEmail.text = placemark.country;
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    NSLog(@"%@",placemark);


    
}
- (IBAction)otpSendButtonAction:(id)sender
{
    STPopupController *popupController = [[STPopupController alloc]initWithRootViewController:[PopupViewController1 new]];
    popupController.containerView.layer.cornerRadius = 4;
    
    NSMutableData *addUserResponse;
    //[popupController navigationBarHidden];
    NSString *urlRest = [[GlobalData sharedGlobalData]buildHost:authCustomerOtpURI];
    //NSMutableData *addUserResponse = [[NSMutableData alloc]init];
    NSLog(@"%@",textData);
    NSInteger idLabelTag = [[textData valueForKey:@"Email" ] integerValue];
    UITextField *txtEmail = (UITextField*)[self.view viewWithTag:idLabelTag];
    idLabelTag = [[textData valueForKey:@"Phone No" ] integerValue];
    UITextField *txtMobile = (UITextField*)[self.view viewWithTag:idLabelTag];
    idLabelTag = [[textData valueForKey:@"Name" ] integerValue];
    UITextField *txtName = (UITextField*)[self.view viewWithTag:idLabelTag];
    NSLog(@"%@ %@ ---- %@",txtEmail.text,txtMobile.text,txtName.text);
    //Sent mail and sms request for OTP
    
    NSURL *url = [NSURL URLWithString:urlRest];
    NSString *postData = [NSString stringWithFormat:@"device=iOS&email=%@&password=%@&firstname=%@&lastname=%@&mobile=%@&govtid=%@&auth=FALSE",txtEmail.text,@"password",txtName.text,txtName.text,txtMobile.text,@"AHPPG0245F"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"email" forKey:@"sreeji.gopal@gmail.com"];
    [parameters setObject:@"password" forKey:@"password"];

    //NSString *postData = [NSString stringWithFormat:@"device=iOS&email=%@&password=%@&firstname=%@&lastname=%@&mobile=%@&govtid=%@",txtEmail.text,@"password",txtName.text,txtName.text,txtMobile.text,@"AHPPG0245F"];
    NSDictionary *mobilArray = [[NSMutableDictionary alloc]init];
    [mobilArray setValue:txtMobile.text forKey:@"Mobile"];
    [mobilArray setValue:txtEmail.text forKey:@"Email"];
    NSLog(@"Post Data 22222 %@ %@",postData,urlRest);
   
    //[SVProgressHUD showWithStatus:@"OTP Sending"];
    addUserResponse = [[GlobalData sharedGlobalData] requestSynchronousData:urlRest :postData :@"POST"];
    NSLog(@"addUserResponse - %@",addUserResponse);
    
    [popupController presentInViewController:self completion:^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getMobile" object:self userInfo:mobilArray];
        
    }];
  
}

- (IBAction)qtyAddButtonAction:(id)sender
{
    
    UIButton *updateButton = (UIButton *)sender;
    NSLog(@"%li %@", updateButton.tag,sender);
    
    UITableViewCell *cell = (UITableViewCell *)updateButton.superview.superview;
    
    NSString *idLabelStr = [NSString stringWithFormat:@"%lu6",updateButton.tag];
    
    NSString *costLabelStr = [NSString stringWithFormat:@"%lu7",updateButton.tag];
    
    UILabel *costlabel = (UILabel *)[cell viewWithTag:[costLabelStr integerValue]];
    NSLog(@"%@", costlabel);
    
    NSLog(@"%@", sender);
    NSLog(@"Tag %lu lbTag %@",costlabel.tag, idLabelStr);
    //NSInteger idLabelTag = [idLabelStr integerValue];
    
    NSArray *arrHeart = (NSArray *)updateButton.accessibilityCustomActions;
    arrHeart = [arrHeart objectAtIndex:0];
    idLabelStr = [arrHeart valueForKey:@"idLabelStr"];
    NSInteger idLabelTag = [idLabelStr integerValue];
    
    UILabel *idLabel = (UILabel *)[cell viewWithTag:idLabelTag];
    NSLog(@"Label %@",idLabel.text);
    NSInteger myInt = [idLabel.text intValue];
    myInt++;
    NSString *strFromInt = [NSString stringWithFormat:@"%li",myInt];
    
    idLabel.text = strFromInt;
    [self buildCartArray:sender];
    
    [self subTotal:sender];
}

- (IBAction)qtyDelButtonAction:(id)sender
{
    
    
    UIButton *updateButton = (UIButton *)sender;
    NSLog(@"%li %@", updateButton.tag,sender);
    
    UITableViewCell *cell = (UITableViewCell *)updateButton.superview.superview;
    
    NSString *idLabelStr = [NSString stringWithFormat:@"%lu6",updateButton.tag];
    NSString *buyButtonStr = [NSString stringWithFormat:@"%lu7",updateButton.tag];
    
    UIButton *buyButton = (UIButton *)[cell viewWithTag:[buyButtonStr integerValue]];
    NSLog(@"%@", buyButton);
    NSLog(@"Tag %lu lbTag %@",updateButton.tag, idLabelStr);
    
    NSArray *arrHeart = (NSArray *)updateButton.accessibilityCustomActions;
    arrHeart = [arrHeart objectAtIndex:0];
    idLabelStr = [arrHeart valueForKey:@"idLabelStr"];
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
    
    [self subTotal:sender];
    
}

-(void)subTotal:(UIButton*)sender{
    
    NSMutableArray *tempCart = [[NSMutableArray alloc] init];
    
    UIButton *updateButton = (UIButton *)sender;
    UITableView *cell = (UITableView *)updateButton.superview.superview;
    
    
    NSString *costLabelStr = [NSString stringWithFormat:@"%lu7",updateButton.tag];
    
    UILabel *costlabel = (UILabel *)[cell viewWithTag:[costLabelStr integerValue]];
    NSLog(@"%@", costlabel.text);

    
    //NSLog(@"%li %@", updateButton.tag,sender);
    NSArray *arrHeart = (NSArray *)updateButton.accessibilityCustomActions;
    arrHeart = [arrHeart objectAtIndex:0];
    NSString *idLabelStr = [arrHeart valueForKey:@"idLabelStr"];
    NSInteger idLabelTag = [idLabelStr integerValue];
    
    UILabel *qtyLabel = (UILabel *)[cell viewWithTag:idLabelTag];
    
    NSLog(@"Qty = %@",qtyLabel.text);
    
    float qty = [qtyLabel.text integerValue];
    float price = [[arrHeart valueForKey:@"productPrice"] integerValue];
    float total = qty*price;
    float subtotal = 0;
    NSString *totalString = [[NSNumber numberWithFloat:total] stringValue];
    
    
    subtotal = 0;
    costlabel.text = [NSString stringWithFormat:@"%@ ₹",totalString];
    
    for(id key in cartArray) {
        id value = [cartArray objectForKey:key];
        NSLog(@"Price %@ x Qty %@",[value objectForKey:@"productPrice"],[value objectForKey:@"qty"]);
        qty = [[value objectForKey:@"qty"] integerValue];
        price = [[value objectForKey:@"productPrice"] integerValue];
        total = qty*price;
        subtotal = subtotal + total;
        // do something with key and obj
    }
    
    NSLog(@"Sub Total %f",subtotal);
    NSString *subTotalString = [[NSNumber numberWithFloat:subtotal] stringValue];
    
    UILabel *subTotalLabel = (UILabel *)[cell viewWithTag:10007];
    
    subTotalLabel.text = [NSString stringWithFormat:@"%@ ₹",subTotalString];;
    
    
    //[tempCart insertObject:qtyLabel.text atIndex:5];
//    [arrHeart setValue:qtyLabel.text forKey:@"qty"];
//    [cartArray removeObjectForKey:[arrHeart valueForKey:@"productID"]];
//    if (![qtyLabel.text isEqualToString:@"0"]) {
//        [cartArray setValue:arrHeart forKey:[arrHeart valueForKey:@"productID"]];
//    }
    
    
    //[cartArray set:[tempCart objectAtIndex:0] forKey:tempCart];
    
    //NSLog(@"Temp Array %@ Cart Array %@",tempCart, cartArray);
    //return cartArray;
}

-(NSMutableDictionary*)buildCartArray:(UIButton*)sender{
    NSMutableArray *tempCart = [[NSMutableArray alloc] init];
    
    UIButton *updateButton = (UIButton *)sender;
    UITableView *cell = (UITableView *)updateButton.superview.superview;
    
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
- (void)goBack {
    NSLog(@"xxx %@",cartArray);
    //MainTableViewController *mainTableViewController = [[MainTableViewController alloc]init];
    //mainTableViewController.de
    //[self.navigationController pushViewController:mainTableViewController animated:YES];
    CategoryTableViewController *categoryViewController = [[CategoryTableViewController alloc] initWithNibName:nil bundle:nil];
    //categoryViewController.m
    //categoryViewController.m = cartSections;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getBack" object:self userInfo:cartArray];
    
    if(self.parentViewController)
        [self.parentViewController dismissModalViewControllerAnimated:YES];
    else
        [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (void) showPopup:(NSNotification *)notification{
    NSDictionary  *theArray = [notification userInfo];
    NSLog(@"Got back %@",theArray);
    //[self.tableView reloadData];
    //[self.tableView beginUpdates];
    //NSIndexPath *iPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //[self.tableView deleteRowsAtIndexPaths:@[iPath] withRowAnimation:UITableViewRowAnimationNone];
    //[self.tableView reloadData];
    //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:iPath] withRowAnimation:UITableViewRowAnimationNone];
    //[self.tableView endUpdates];
}

- (void) showReload:(NSNotification *)notification{
    NSDictionary  *theArray = [notification userInfo];
    NSLog(@"Got back Reload %@",theArray);
    //[self.tableView reloadData];
    //[self.tableView beginUpdates];
    //NSIndexPath *iPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //[self.tableView deleteRowsAtIndexPaths:@[iPath] withRowAnimation:UITableViewRowAnimationNone];
    //[self.tableView reloadData];
    //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:iPath] withRowAnimation:UITableViewRowAnimationNone];
    //[self.tableView endUpdates];
    [self.tableView reloadData];
}


@end
