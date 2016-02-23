//
//  DAO.h
//  NavCtrl
//
//  Created by Krishna Ramachandran on 2/16/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Company.h"
#import "Product.h"

@interface DAO : NSObject

@property(nonatomic, strong) NSMutableArray *companies;

-(NSMutableArray *)createCompanies;
+(DAO *)sharedDAO;

@end
