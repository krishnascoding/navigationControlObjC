//
//  CollectionViewCell.h
//  NavCtrl
//
//  Created by Krishna Ramachandran on 3/14/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell
@property (retain, nonatomic) IBOutlet UILabel *companyName;
@property (retain, nonatomic) IBOutlet UIImageView *companyImage;
@property (retain, nonatomic) IBOutlet UILabel *stockPrice;
@property (retain, nonatomic) IBOutlet UIButton *xMarkOutlet;

@end
