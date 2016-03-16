//
//  ProductCollectionViewCell.m
//  NavCtrl
//
//  Created by Krishna Ramachandran on 3/15/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "ProductCollectionViewCell.h"

@implementation ProductCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)dealloc {
    [_productImage release];
    [_productName release];
    [_xMarkProduct release];
    [super dealloc];
}
@end
