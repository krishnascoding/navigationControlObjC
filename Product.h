//
//  Product.h
//  NavCtrl
//
//  Created by Krishna Ramachandran on 2/12/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic, retain) NSString *productName;
@property (nonatomic, retain) NSString *productURL;
@property (nonatomic, retain) NSString *productImage;

-(instancetype)initWithName:(NSString *)productName url:(NSString *)productURL andImage:(NSString *)productImage;
@end
