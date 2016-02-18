//
//  ProductViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyViewController.h"
#import "Company.h"

@interface ProductViewController : UITableViewController
@property (nonatomic, retain) NSMutableArray *products;


@property (nonatomic, retain) Company *currentCompany;
@property (nonatomic, retain) Product *currentProduct;

@property (nonatomic, retain) NSMutableArray *companyList;

@end
