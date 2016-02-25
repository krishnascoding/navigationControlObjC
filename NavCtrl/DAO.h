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

// SQLite properties and methods
@property (nonatomic, strong) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;

-(instancetype)initWithDatabase;
-(void)loadDataFromDB:(NSString *)query;
-(void)executeQuery:(NSString *)query;

// DAO methods and property
@property(nonatomic, retain) NSMutableArray *companies;

//-(NSMutableArray *)createCompanies;
+(DAO *)sharedDAO;
-(void)createNewCompany:(NSString *)name andLogo:(NSString *)logo andStockSym:(NSString *)stockSym;
-(void)editCompany:(NSString *)newName logo:(NSString *)logo andIndexPathRow:(NSInteger)indexPathRow andStockSymbol:(NSString *)stockSymbol;
-(void)createNewProduct:(NSString *)name andImage:(NSString *)image andURL:(NSString *)url forCurrentCompany:(Company*)currentCompany;
-(void)editProduct:(NSString *)name andImage:(NSString *)image andURL:(NSString *)url forCurrentCompany:(Company*)currentCompany atIndexPathRow:(NSInteger)indexPathRow;


@end
