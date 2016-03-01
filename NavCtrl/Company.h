//
//  Company.h
//  NavCtrl
//
//  Created by Krishna Ramachandran on 2/12/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface Company : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, retain) NSString *logo;
@property (nonatomic, retain) NSMutableArray *products;
@property (nonatomic, strong) NSString *stockPrice;
@property (nonatomic, strong) NSString *stockSym;
@property (nonatomic) double order;
@property (nonatomic) int ID;

-(instancetype)initWithName:(NSString *)name logo:(NSString *)logo andStockSym:(NSString *)stockSym;
@end
