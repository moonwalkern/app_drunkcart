//
//  Config+CoreDataProperties.h
//  Drunkcart
//
//  Created by Sreeji Gopal on 12/02/16.
//  Copyright © 2016 Sreeji Gopal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Config.h"

NS_ASSUME_NONNULL_BEGIN

@interface Config (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *data;
@property (nullable, nonatomic, retain) NSDate *datetime;
@property (nullable, nonatomic, retain) NSString *data_name;

@end

NS_ASSUME_NONNULL_END
