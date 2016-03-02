//
//  DAO.m
//  NavCtrl
//
//  Created by Krishna Ramachandran on 2/16/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "DAO.h"
#import <sqlite3.h>

@interface DAO()

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *dbSourcePath;
@property (nonatomic, strong) NSString *databaseFilename;
@property (nonatomic, strong) NSString *databasePath;
@property (nonatomic, strong) NSMutableArray *arrResults;

-(void)copyDatabaseIntoDocumentsDirectory;
-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

@end

@implementation DAO

+(DAO *)sharedDAO
{
    static DAO *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[DAO alloc] initWithDatabase];
    });
    
    return _sharedInstance;
    
}

#pragma mark SQLite DB Methods

-(instancetype)initWithDatabase{
    
    self = [super init];
    
    if (self) {
        
        _dbSourcePath = [[NSBundle mainBundle] pathForResource:@"NavCtrl" ofType:@"db"];
        
        // Set the documents directory path to the documentsDirectory property
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _documentsDirectory = [paths objectAtIndex:0];
        
        // Keep the database filename
        _databaseFilename = @"/NavCtrl.db";
        
        //If needed, copy the database file into the documents directory
        [self copyDatabaseIntoDocumentsDirectory];
        
    }
    
    return self;
}

-(void)copyDatabaseIntoDocumentsDirectory{
    // Check if the database file exists in the documents directory
    self.databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.databasePath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] copyItemAtPath:self.dbSourcePath toPath:self.databasePath error:&error];

        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
    }
}

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable{
    // Create a sqlite object
    sqlite3 *sqlite3Database;
    
    // Initialize the results array.
    if (self.arrResults != nil) {
        [self.arrResults removeAllObjects];
        self.arrResults = nil;
    }
    
    NSMutableArray * __arrResults = [[NSMutableArray alloc] init];
    self.arrResults = __arrResults;
    [__arrResults release];
    
    // Initialize the column names array.
    if (self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    
    NSMutableArray * __arrColumnNames = [[NSMutableArray alloc] init];
    
    self.arrColumnNames = __arrColumnNames;
    [__arrColumnNames release];
    
    
    // Open the database.
    int openDatabaseResult = sqlite3_open([self.databasePath UTF8String], &sqlite3Database);
    if(openDatabaseResult == SQLITE_OK) {
        // Declare a sqlite3_stmt object in which will be stored the query after having been compiled into a SQLite statement.
        sqlite3_stmt *compiledStatement;
        
        // Load all data from database to memory
        int prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        if(prepareStatementResult == SQLITE_OK) {
            // Check if the query is non-executable.
            if (!queryExecutable){
                // In this case data must be loaded from the database
                
                // Declare an array to keep the data for each fetched row
                NSMutableArray *arrDataRow;
                
                // Loop through the results and add them to the results array row by row
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    // Initialize the mutable array that will contain the data of a fetched row.
                     arrDataRow = [[NSMutableArray alloc] init];
                    
                    // Get the total number of columns.
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    
                    // Go through all columns and fetch each column data.
                    for (int i=0; i<totalColumns; i++){
                        // Convert the column data to text (characters).
                        char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        
                        // If there are contents in the currenct column (field) then add them to the current row array.
                        if (dbDataAsChars != NULL) {
                            // Convert the characters to string.
                            [arrDataRow addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
                        }
                        
                        // Keep the current column name.
                        if (self.arrColumnNames.count != totalColumns) {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
                    
                    // Store each fetched data row in the results array, but first check if there is actually data.
                    if (arrDataRow.count > 0) {
                        [self.arrResults addObject:arrDataRow];
                    }
                    
                    [arrDataRow release];
                    
                }
            }
            else {
                // This is the case of an executable query (insert, update, ...).
                
                // Execute the query.
                NSInteger executeQueryResults = sqlite3_step(compiledStatement);
                if(executeQueryResults == SQLITE_DONE) {
                    // Keep the affected rows.
                    self.affectedRows = sqlite3_changes(sqlite3Database);
                    
                    // Keep the last inserted row ID.
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                }
                else {
                    // If could not execute the query show the error message on the debugger.
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
                }
            }
        }
        else {
            // In the database cannot be opened then show the error message on the debugger.
            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
        }
        
        // Release the compiled statement from memory.
        sqlite3_finalize(compiledStatement);
        
    }
    
    // Close the database.
    sqlite3_close(sqlite3Database);
}

-(void)loadDataFromDB {
    // Run the query and indicate that is not executable.
    // The query string is converted to a char* object.
    
    // Form the query.
    NSString *query = @"select * from Company order by companyOrder";
    
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    NSArray *clist = [NSArray arrayWithArray: self.arrResults];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];

    
    for (int i = 0; i < clist.count; i++) {
        
        NSArray *cdata = [clist objectAtIndex:i];
        
        Company *company = [[Company alloc] initWithName:[cdata objectAtIndex:2]logo:[cdata objectAtIndex:3] andStockSym:[cdata  objectAtIndex:4]];
        
        
        double compOrder = [[cdata objectAtIndex:1] doubleValue];
        int companyID = [[cdata objectAtIndex:0] intValue];
        
        [company setOrder:compOrder];
        [company setID:companyID];
        
       
            NSString *productQuery = [NSString stringWithFormat:@"select * from Products where company_id=%d",companyID];
            [self runQuery:[productQuery UTF8String] isQueryExecutable:NO];
        
        
            NSMutableArray *productArr = [[NSMutableArray alloc] init];
            
            for (int p = 0; p < self.arrResults.count; p++) {
                Product *product = [[Product alloc]initWithName:[[self.arrResults objectAtIndex:p] objectAtIndex:3] url:[[self.arrResults objectAtIndex:p] objectAtIndex:4] andImage:[[self.arrResults objectAtIndex:p] objectAtIndex:5]];
                
                double productOrder = [[[self.arrResults objectAtIndex:p] objectAtIndex:1] doubleValue];
                int productID = [[[self.arrResults objectAtIndex:p] objectAtIndex:0] intValue];
                
                [product setProductID:productID];
                [product setProductOrder:productOrder];
                [productArr addObject:product];
                
                [product release];
                
            }
        
            [company setProducts:productArr];
            [productArr release];
        
            [arr addObject:company];
            [company release];
        
    }
    
    self.companies = arr;
    [arr release];
    
    
}

-(void)executeQuery:(NSString *)query{
    // Run the query and indicate that is executable.
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}


#pragma mark create and edit Company and Product methods

-(void)createNewCompany:(NSString *)name andLogo:(NSString *)logo andStockSym:(NSString *)stockSym
{
    double companyOrder = 0;
    double newCompOrder = 0;
    
    if ([self.companies objectAtIndex:self.companies.count - 1] >= 0) {
        companyOrder = [[self.companies objectAtIndex:self.companies.count - 1] order];
        newCompOrder = companyOrder + 1.0;
    } else {
        newCompOrder = 1.0;
    }


    
    NSString *query = [NSString stringWithFormat:@"insert into Company (companyName, companyLogo, stockSymbol, companyOrder) values ('%@','%@', '%@', '%f')", name, logo, stockSym, newCompOrder];
    
    [self executeQuery:query];
    
    Company *newCompany = [[Company alloc] initWithName:name logo:logo andStockSym:stockSym];
    [newCompany setOrder:newCompOrder];
    [self.companies addObject:newCompany];
    
    [newCompany release];
    
    
}

-(void)editCompany:(NSString *)newName logo:(NSString *)logo andIndexPathRow:(NSInteger)indexPathRow andStockSymbol:(NSString *)stockSymbol
{

    int companyID = [[self.companies objectAtIndex:indexPathRow] ID];
    
    NSString *query = [NSString stringWithFormat:@"update Company Set companyName='%@', companyLogo='%@', stockSymbol='%@' where ID=%d", newName, logo, stockSymbol, companyID];
    
    [self executeQuery:query];


}
-(void)createNewProduct:(NSString *)name andImage:(NSString *)image andURL:(NSString *)url forCurrentCompany:(Company *)currentCompany
{
    double prodOrder = 0;
    double newProductOrder = 0;

    
    if (currentCompany.products.count >= 1) {
        prodOrder = [[currentCompany.products objectAtIndex:currentCompany.products.count - 1] productOrder];
        newProductOrder = prodOrder + 1.0;
    } else {
        newProductOrder = 1.0;
    }
    
    
    int companyID = currentCompany.ID;
    
    
    NSString *query = [NSString stringWithFormat:@"insert into Products (productName, productImage, productURL, productOrder, company_id) values ('%@','%@', '%@', '%f', %d)", name, image, url, newProductOrder, companyID];
    
    [self executeQuery:query];
    
    Product *newProduct = [[Product alloc] initWithName:name url:url andImage:image];
    [newProduct setProductOrder:newProductOrder];
    [newProduct setProductID:[currentCompany ID]];
    
    [[currentCompany products] addObject:newProduct];
    
    [newProduct release];



}

-(void)editProduct:(NSString *)name andImage:(NSString *)image andURL:(NSString *)url forCurrentCompany:(Company *)currentCompany atIndexPathRow:(NSInteger)indexPathRow
{
    
//    int companyProducts = currentCompany.products;
    int productID = [[currentCompany.products objectAtIndex:indexPathRow]productID];
    
    
    NSString *query = [NSString stringWithFormat:@"update Products Set productName='%@', productImage='%@', productURL='%@' where ID=%d", name, image, url, productID];
    
    [self executeQuery:query];
    
    
    Product *product = [currentCompany.products objectAtIndex:indexPathRow];
    
    [product setProductName:name];
    [product setProductImage:image];
    [product setProductURL:url];
    
}


-(void)deleteCompany:(int)ID
{
    // Prepare the query.
    NSString *query = [NSString stringWithFormat:@"delete from Company where ID=%d", ID];
    
    // Execute the query.
    [self executeQuery:query];
    
    for (Company *company in self.companies) {
        if (company.ID  == ID) {
            [self.companies removeObject:company];
            break;
        }
    }
}

-(void)moveCompany:(double)companyOrder andID:(int)companyID
{
    NSString *query = [NSString stringWithFormat:@"update Company Set companyOrder=%f where id =%d",companyOrder, companyID];
    
    [self executeQuery:query];
    
    [self loadDataFromDB];
    
}

-(void)moveCompany:(int)companyID toIndexPathRow:(NSInteger )toIndexPathRow fromIndexPathRow:(NSInteger)fromIndexPathRow
{
    
    // Query to update Order
    double orderBefore = 0;
    double orderAfter = [self.companies count] - 1;
    
    if (toIndexPathRow == 0) {
        if ([self.companies objectAtIndex:toIndexPathRow]) {
            orderAfter = [[self.companies objectAtIndex:toIndexPathRow] order];
        } else {
            return;
        }
        
    } else {
        
        if (toIndexPathRow == orderAfter) {
            orderBefore = [[self.companies objectAtIndex:toIndexPathRow] order];
            orderAfter = orderBefore + 1.0;
            
        } else {
            
            if (toIndexPathRow > fromIndexPathRow) {
                orderBefore = [[self.companies objectAtIndex:toIndexPathRow] order];
                orderAfter = [[self.companies objectAtIndex:toIndexPathRow + 1] order];
                
            } else {
                
                orderBefore = [[self.companies objectAtIndex:toIndexPathRow - 1] order];
                orderAfter = [[self.companies objectAtIndex:toIndexPathRow] order];
                
            }
            
        }
        
    }
    
    double orderQuery = ((orderBefore + orderAfter) / 2);    
    NSString *query = [NSString stringWithFormat:@"update Company Set companyOrder=%f where id =%d",orderQuery, companyID];
    [self executeQuery:query];
    [self loadDataFromDB];
    
}

-(void)deleteProduct:(int)productID
{
    
    // Prepare the query.
    NSString *query = [NSString stringWithFormat:@"delete from Products where id=%d", productID];
    
    // Execute the query.
    [self executeQuery:query];

}

@end
