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
    self.arrResults = [[NSMutableArray alloc] init];
    
    // Initialize the column names array.
    if (self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];
    
    
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

-(void)loadDataFromDB:(NSString *)query{
    // Run the query and indicate that is not executable.
    // The query string is converted to a char* object.
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.arrResults.count; i++) {
        
        Company *company = [[Company alloc] initWithName:[[self.arrResults objectAtIndex:i] objectAtIndex:1]logo:[[self.arrResults objectAtIndex:i] objectAtIndex:2] andStockSym:[[self.arrResults objectAtIndex:i] objectAtIndex:3]];
        
        [arr addObject:company];
        
    }
    
    self.companies = arr;
    
}

-(void)executeQuery:(NSString *)query{
    // Run the query and indicate that is executable.
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}


#pragma mark create and edit Company and Product methods

-(void)createNewCompany:(NSString *)name andLogo:(NSString *)logo andStockSym:(NSString *)stockSym
{
    
    Company *newCompany = [[Company alloc] initWithName:name logo:logo andStockSym:stockSym];

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
