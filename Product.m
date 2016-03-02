//
//  Product.m
//  NavCtrl
//
//  Created by Krishna Ramachandran on 2/12/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "Product.h"

@implementation Product

-(instancetype)initWithName:(NSString *)productName url:(NSString *)productURL andImage:(NSString *)productImage
{
    self = [super init];
    
    if (self) {
        _productName = productName;
        _productURL = productURL;
        _productImage = productImage;

        [_productImage retain];
        [_productName retain];
        [_productURL retain];
        
        return self;
    }
    
    return nil;
}

-(void)dealloc
{
    [_productImage release];
    [_productName release];
    [_productURL release];
    [super dealloc];
}

@end
