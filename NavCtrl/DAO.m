//
//  DAO.m
//  NavCtrl
//
//  Created by Krishna Ramachandran on 2/16/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "DAO.h"

@implementation DAO

+(DAO *)sharedDAO
{
    static DAO *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[DAO alloc] init];
    });
    
    return _sharedInstance;
    
}

-(void)createNewCompany:(NSString *)name andLogo:(NSString *)logo
{
    
    Company *newCompany = [[Company alloc] initWithName:name logo:logo];

    [self.companies addObject:newCompany];
    
}

-(void)editCompany:(NSString *)newName logo:(NSString *)logo andIndexPathRow:(NSInteger)indexPathRow andStockSymbol:(NSString *)stockSymbol
{
    Company *company = [self.companies objectAtIndex:indexPathRow];
    
    [company setLogo:logo];
    [company setName: newName];
    [company setStockSym: stockSymbol];

    
}
-(void)createNewProduct:(NSString *)name andImage:(NSString *)image andURL:(NSString *)url forCurrentCompany:(Company *)currentCompany
{
    Product *newProduct = [[Product alloc] initWithName:name url:url andImage:image];
    
    [currentCompany.products addObject:newProduct];

}

-(void)editProduct:(NSString *)name andImage:(NSString *)image andURL:(NSString *)url forCurrentCompany:(Company *)currentCompany atIndexPathRow:(NSInteger)indexPathRow
{
    Product *product = [currentCompany.products objectAtIndex:indexPathRow];
    
    [product setProductName:name];
    [product setProductImage:image];
    [product setProductURL:url];
    
}


@end
