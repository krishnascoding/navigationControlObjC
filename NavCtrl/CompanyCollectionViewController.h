//
//  CompanyCollectionViewController.h
//  NavCtrl
//
//  Created by Krishna Ramachandran on 3/14/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "Company.h"
#import "DAO.h"
#import "AddEditViewController.h"
#import "CollectionViewCell.h"
#import "ProductCollectionViewController.h"
#import "AFNetworking.h"

@class ProductViewController;

@interface CompanyCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, retain)  ProductCollectionViewController * productViewController;
@property (nonatomic, retain) AddEditViewController *addEditVC;
//@property (nonatomic, strong) NSMutableArray *stockPrices;


@end
