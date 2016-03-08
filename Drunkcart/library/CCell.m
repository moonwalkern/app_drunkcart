//
//  CCell.m
//  Drunkcart
//
//  Created by Sreeji Gopal on 29/02/16.
//  Copyright © 2016 Sreeji Gopal. All rights reserved.
//

#import "CCell.h"
#import "CategoryTableViewController.h"

@implementation CCell


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CategoryTableViewController *categ = [[CategoryTableViewController init]alloc];
    NSArray *tempArray = categ.subcategoryDataArray;
    
    NSArray *categoryArray = [tempArray objectAtIndex:indexPath.section];
    NSLog(@"categoryArray %@",categoryArray);
    
    return cell;
}

@end
