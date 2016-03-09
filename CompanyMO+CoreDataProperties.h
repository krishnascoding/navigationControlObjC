//
//  CompanyMO+CoreDataProperties.h
//  NavCtrl
//
//  Created by Krishna Ramachandran on 3/7/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CompanyMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompanyMO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *logo;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *order;
@property (nullable, nonatomic, retain) NSString *stockSym;
@property (nullable, nonatomic, retain) NSNumber *companyID;
@property (nullable, nonatomic, retain) NSSet<ProductsMO *> *products;

@end

@interface CompanyMO (CoreDataGeneratedAccessors)

- (void)addProductsObject:(ProductsMO *)value;
- (void)removeProductsObject:(ProductsMO *)value;
- (void)addProducts:(NSSet<ProductsMO *> *)values;
- (void)removeProducts:(NSSet<ProductsMO *> *)values;

@end

NS_ASSUME_NONNULL_END
