//
//  ProductViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductViewController : UITableViewController
@property (nonatomic, retain) NSMutableArray *products;
@property (nonatomic, retain) NSMutableDictionary *companyProducts;
@property (nonatomic, retain) NSMutableDictionary *productURLs;
@property (nonatomic, retain) NSMutableDictionary *productImages;

@property (nonatomic, retain) NSString *currentCompany;
@property (nonatomic, retain) NSString *currentProduct;


@end
