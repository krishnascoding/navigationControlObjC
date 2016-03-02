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
        
        _stockSym = stockSym;
        _name = name;
        _logo = logo;
        [_stockSym retain];
        [_name retain];
        [_logo retain];
        
        
    }
    return self;
}

-(NSMutableArray*)products{
    if(!_products){
        _products = [[NSMutableArray alloc] init];
        [_products retain];
    }
    return _products;
}



-(void)dealloc
{
    [_stockSym release];
    [_name release];
    [_logo release];
    [_products release];
    [_stockPrice release];
    [super dealloc];

}

@end
