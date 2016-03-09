//
//  ProductsMO+CoreDataProperties.h
//  NavCtrl
//
//  Created by Krishna Ramachandran on 3/7/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ProductsMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProductsMO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *productImage;
@property (nullable, nonatomic, retain) NSString *productName;
@property (nullable, nonatomic, retain) NSNumber *productOrder;
@property (nullable, nonatomic, retain) NSString *productURL;
@property (nullable, nonatomic, retain) NSNumber *company_id;
@property (nullable, nonatomic, retain) CompanyMO *company;

@end

NS_ASSUME_NONNULL_END
