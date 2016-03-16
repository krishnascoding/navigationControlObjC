//
//  ProductCollectionViewController.h
//  NavCtrl
//
//  Created by Krishna Ramachandran on 3/15/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyViewController.h"
#import "Company.h"
#import "AddProductViewController.h"

@interface ProductCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>


@property (nonatomic, retain) NSMutableArray *products;
@property (nonatomic, retain) Company *currentCompany;
@property (nonatomic, retain) Product *currentProduct;
@property (nonatomic, retain) AddProductViewController *addProductVC;
@property (nonatomic) NSInteger currentComp;

@end
