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

@property(nonatomic, retain) NSMutableArray *companies;

-(NSMutableArray *)createCompanies;
+(DAO *)sharedDAO;
-(void)createNewCompany:(NSString *)name andLogo:(NSString *)logo;
-(void)editCompany:(NSString *)newName logo:(NSString *)logo andIndexPath:(NSInteger)indexPath;
-(void)createNewProduct:(NSString *)name andImage:(NSString *)image andURL:(NSString *)url forCurrentCompany:(Company*)currentCompany;
-(void)editProduct:(NSString *)name andImage:(NSString *)image andURL:(NSString *)url forCurrentCompany:(Company*)currentCompany atIndexPath:(NSInteger)indexPath;



@end
