//
//  CollectionViewCell.m
//  NavCtrl
//
//  Created by Krishna Ramachandran on 3/14/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)dealloc {
    [_companyName release];
    [_companyImage release];
    [_stockPrice release];
    [_xMarkOutlet release];
    [super dealloc];
}

@end
