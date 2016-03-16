//
//  ProductCollectionViewCell.h
//  NavCtrl
//
//  Created by Krishna Ramachandran on 3/15/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCollectionViewCell : UICollectionViewCell
@property (retain, nonatomic) IBOutlet UIImageView *productImage;
@property (retain, nonatomic) IBOutlet UILabel *productName;
@property (retain, nonatomic) IBOutlet UIButton *xMarkProduct;

@end
