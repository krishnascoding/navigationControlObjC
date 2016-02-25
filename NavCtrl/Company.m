//
//  Company.m
//  NavCtrl
//
//  Created by Krishna Ramachandran on 2/12/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "Company.h"

@implementation Company

-(instancetype)initWithName:(NSString *)name logo:(NSString *)logo andStockSym:(NSString *)stockSym
{
    self = [super init];
    
    if (self) {
        
        _products = [[NSMutableArray alloc] init];
        
        _stockSym = stockSym;
        _name = name;
        _logo = logo;
        [_stockSym retain];
        [_name retain];
        [_logo retain];
        
        return self;
    }
    return nil;
}


@end
