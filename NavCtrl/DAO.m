//
//  DAO.m
//  NavCtrl
//
//  Created by Krishna Ramachandran on 2/16/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "DAO.h"
#import <sqlite3.h>
#import "CompanyMO.h"


@interface DAO()

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *dbSourcePath;
@property (nonatomic, strong) NSString *databaseFilename;
@property (nonatomic, strong) NSString *databasePath;
@property (nonatomic, strong) NSMutableArray *arrResults;

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

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    [self initializeCoreData];
    
    return self;
}

- (void)initializeCoreData
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSAssert(mom != nil, @"Error initializing Managed Object Model");
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [moc setPersistentStoreCoordinator:psc];
    [self setManagedObjectContext:moc];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"DataModel.sqlite"];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSError *error = nil;
        NSPersistentStoreCoordinator *psc = [[self managedObjectContext] persistentStoreCoordinator];
        NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        NSAssert(store != nil, @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);
    });
    
    self.managedObjectContext.undoManager = [[[NSUndoManager alloc] init] autorelease];

    [self loadDataFromDB];
    [psc release];
    [moc release];
    [mom release];
}


#pragma mark SQLite DB Methods

-(instancetype)initWithDatabase{
    
    self = [super init];
    if (!self) return nil;
    

    [self initializeCoreData];

    
    return self;

}

-(void)loadDataFromDB {
    // Run the query and indicate that is not executable.
    // The query string is converted to a char* object.
    
    // Fetching
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CompanyMO"];
    
    // Add Sort Descriptor
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Execute Fetch Request
    NSError *fetchError = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    
    self.moArray = [NSMutableArray arrayWithArray:result];
    
    if (!fetchError) {
        

      
        if (result == nil || [result count] == 0) {
 
            
//            Company *apple = [[Company alloc] initWithName:@"Apple mobile" logo:@"appleimage.jpg" andStockSym:@"AAPL"];
            // Create Managed Object
            NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"CompanyMO" inManagedObjectContext:self.managedObjectContext];
           
            CompanyMO *appleMO = [[CompanyMO alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
            
            [appleMO setName:@"Apple mobile"];
            //[appleMO setValue:@"Apple mobile"  forKey:@"name"];
            [appleMO setLogo:@"appleimage.jpg"];
            [appleMO setStockSym:@"AAPL"];
            [appleMO setOrder:@1.0];
            [appleMO setCompanyID:@1];
            
            
            NSManagedObject *samsungMO = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
            [samsungMO setValue:@"Samsung mobile"  forKey:@"name"];
            [samsungMO setValue:@"samsunglogo.jpg"  forKey:@"logo"];
            [samsungMO setValue:@"GOOG" forKey:@"stockSym"];
            [samsungMO setValue:@2.0 forKey:@"order"];
            [samsungMO setValue:@2 forKey:@"companyID"];
            
            NSManagedObject *dellMO = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
            [dellMO setValue:@"Dell"  forKey:@"name"];
            [dellMO setValue:@"delllogo.jpg"  forKey:@"logo"];
            [dellMO setValue:@"FB" forKey:@"stockSym"];
            [dellMO setValue:@3.0 forKey:@"order"];
            [dellMO setValue:@3 forKey:@"companyID"];
            
            
            NSManagedObject *microsoftMO = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
            [microsoftMO setValue:@"Microsoft"  forKey:@"name"];
            [microsoftMO setValue:@"microsoftlogo.png"  forKey:@"logo"];
            [microsoftMO setValue:@"MSFT" forKey:@"stockSym"];
            [microsoftMO setValue:@4.0 forKey:@"order"];
            [microsoftMO setValue:@4 forKey:@"companyID"];
            
            
            NSEntityDescription *productEntityDescription = [NSEntityDescription entityForName:@"ProductsMO" inManagedObjectContext:self.managedObjectContext];
            
            NSManagedObject *ipadMO = [[NSManagedObject alloc] initWithEntity:productEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
            [ipadMO setValue:@"iPad"  forKey:@"productName"];
            [ipadMO setValue:@"ipad.jpg"  forKey:@"productImage"];
            [ipadMO setValue:@"http://www.apple.com/ipad" forKey:@"productURL"];
            [ipadMO setValue:@1 forKey:@"productOrder"];
            [ipadMO setValue:@1 forKey:@"company_id"];
            [ipadMO setValue:appleMO forKey:@"company"];

            NSManagedObject *iphoneMO = [[NSManagedObject alloc] initWithEntity:productEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
            [iphoneMO setValue:@"iPhone"  forKey:@"productName"];
            [iphoneMO setValue:@"ipad.jpg"  forKey:@"productImage"];
            [iphoneMO setValue:@"http://www.apple.com/iphone/" forKey:@"productURL"];
            [iphoneMO setValue:@2 forKey:@"productOrder"];
            [iphoneMO setValue:@1 forKey:@"company_id"];
            [iphoneMO setValue:appleMO forKey:@"company"];

            
            NSManagedObject *iPodTouchMO = [[NSManagedObject alloc] initWithEntity:productEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
            [iPodTouchMO setValue:@"iPod Touch"  forKey:@"productName"];
            [iPodTouchMO setValue:@"ipodtouch.jpg"  forKey:@"productImage"];
            [iPodTouchMO setValue:@"http://www.apple.com/ipod-touch/" forKey:@"productURL"];
            [iPodTouchMO setValue:@3 forKey:@"productOrder"];
            [iPodTouchMO setValue:@1 forKey:@"company_id"];
            [iPodTouchMO setValue:appleMO forKey:@"company"];

            
            
            NSManagedObject *galaxyS4 = [[NSManagedObject alloc] initWithEntity:productEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
            
            [galaxyS4 setValue:@"Galaxy S4" forKey:@"productName"];
            [galaxyS4 setValue:@"galaxys4.jpg"  forKey:@"productImage"];
            [galaxyS4 setValue:@"http://www.samsung.com/global/microsite/galaxys4/" forKey:@"productURL"];
            [galaxyS4 setValue:@1 forKey:@"productOrder"];
            [galaxyS4 setValue:@2 forKey:@"company_id"];
            [galaxyS4 setValue:samsungMO forKey:@"company"];

            
            NSManagedObject *galaxyNote = [[NSManagedObject alloc] initWithEntity:productEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
            
            [galaxyNote setValue:@"Galaxy Note" forKey:@"productName"];
            [galaxyNote setValue:@"galaxynote.jpg"  forKey:@"productImage"];
            [galaxyNote setValue:@"http://www.samsung.com/global/microsite/galaxynote/note/index.html?type=find" forKey:@"productURL"];
            [galaxyNote setValue:@2 forKey:@"productOrder"];
            [galaxyNote setValue:@2 forKey:@"company_id"];
            [galaxyNote setValue:samsungMO forKey:@"company"];


            
            NSManagedObject *galaxyTab = [[NSManagedObject alloc] initWithEntity:productEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
            
            [galaxyTab setValue:@"Galaxy Tab" forKey:@"productName"];
            [galaxyTab setValue:@"galaxytab.jpg"  forKey:@"productImage"];
            [galaxyTab setValue:@"http://www.samsung.com/us/mobile/galaxy-tab/" forKey:@"productURL"];
            [galaxyTab setValue:@3 forKey:@"productOrder"];
            [galaxyTab setValue:@2 forKey:@"company_id"];
            [galaxyTab setValue:samsungMO forKey:@"company"];

            
            NSManagedObject *windows = [[NSManagedObject alloc] initWithEntity:productEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
            
            [windows setValue:@"Windows" forKey:@"productName"];
            [windows setValue:@"windows.jpg"  forKey:@"productImage"];
            [windows setValue:@"https://www.microsoft.com/en-us/windows/" forKey:@"productURL"];
            [windows setValue:@1 forKey:@"productOrder"];
            [windows setValue:@4 forKey:@"company_id"];
            [windows setValue:microsoftMO forKey:@"company"];

            
            
            NSManagedObject *office = [[NSManagedObject alloc] initWithEntity:productEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
            
            [office setValue:@"Office" forKey:@"productName"];
            [office setValue:@"office.jpg"  forKey:@"productImage"];
            [office setValue:@"https://products.office.com/en-us/home" forKey:@"productURL"];
            [office setValue:@2 forKey:@"productOrder"];
            [office setValue:@4 forKey:@"company_id"];
            [office setValue:microsoftMO forKey:@"company"];

            
            NSManagedObject *lumia = [[NSManagedObject alloc] initWithEntity:productEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
            
            [lumia setValue:@"Lumia" forKey:@"productName"];
            [lumia setValue:@"lumia.png"  forKey:@"productImage"];
            [lumia setValue:@"https://www.microsoft.com/en-us/mobile/" forKey:@"productURL"];
            [lumia setValue:@3 forKey:@"productOrder"];
            [lumia setValue:@4 forKey:@"company_id"];
            [lumia setValue:microsoftMO forKey:@"company"];

            
            NSManagedObject *inspiron = [[NSManagedObject alloc] initWithEntity:productEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
            
            [inspiron setValue:@"Inspiron" forKey:@"productName"];
            [inspiron setValue:@"inspiron.jpg"  forKey:@"productImage"];
            [inspiron setValue:@"http://www.dell.com/us/p/laptops/inspiron-laptops" forKey:@"productURL"];
            [inspiron setValue:@1 forKey:@"productOrder"];
            [inspiron setValue:@3 forKey:@"company_id"];
            [inspiron setValue:dellMO forKey:@"company"];

            
            NSManagedObject *chromebook = [[NSManagedObject alloc] initWithEntity:productEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
            
            [chromebook setValue:@"Chromebook" forKey:@"productName"];
            [chromebook setValue:@"chromebook.jpg"  forKey:@"productImage"];
            [chromebook setValue:@"http://www.dell.com/us/business/p/chromebook-13-7310/pd?oc=ss0010c731013us&model_id=chromebook-13-7310" forKey:@"productURL"];
            [chromebook setValue:@2 forKey:@"productOrder"];
            [chromebook setValue:@3 forKey:@"company_id"];
            [chromebook setValue:dellMO forKey:@"company"];

            
            NSManagedObject *venuePro = [[NSManagedObject alloc] initWithEntity:productEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
            [venuePro setValue:@"Venue Pro" forKey:@"productName"];
            [venuePro setValue:@"venuepro.jpg"  forKey:@"productImage"];
            [venuePro setValue:@"http://www.dell.com/us/business/p/dell-venue-8-pro-5855-tablet/pd?oc=bto10005t58558usca&model_id=dell-venue-8-pro-5855-tablet&l=en&s=bsd" forKey:@"productURL"];
            [venuePro setValue:@3 forKey:@"productOrder"];
            [venuePro setValue:@3 forKey:@"company_id"];
            [venuePro setValue:dellMO forKey:@"company"];

            
//           [self.managedObjectContext save:nil];
            [appleMO release];
            [samsungMO release];
            [dellMO release];
            [microsoftMO release];
            [ipadMO release];
            [iphoneMO release];
            [iPodTouchMO release];
            [galaxyNote release];
            [galaxyS4 release];
            [galaxyTab release];
            [windows release ];
            [office release];
            [lumia release];
            [inspiron release];
            [chromebook release];
            [venuePro release];
            
            
        } else {
            
            // Company and product mutable array
            NSMutableArray *arr = [[NSMutableArray alloc] init];

            
            for (NSManagedObject *managedObject in result) {
                NSLog(@"%@, %@ order %@", [managedObject valueForKey:@"name"], [managedObject valueForKey:@"logo"], [managedObject valueForKey:@"order"]);
                
                Company *company = [[Company alloc] initWithName:[managedObject valueForKey:@"name"] logo:[managedObject valueForKey:@"logo"] andStockSym:[managedObject valueForKey:@"stockSym"]];
                [company setOrder:[[managedObject valueForKey:@"order"] doubleValue]];
                [company setID:[[managedObject valueForKey:@"companyID"] intValue]];
                
                NSSet *products = [managedObject valueForKey:@"products"];
                
                NSSortDescriptor *positionSort = [NSSortDescriptor sortDescriptorWithKey:@"productOrder" ascending:YES];
                
                NSArray *children = [[products allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:positionSort]];
                
                
                NSMutableArray *productArray = [[NSMutableArray alloc] init];

                for (NSManagedObject *product in children) {
                    
                    Product *newProduct = [[Product alloc] initWithName:[product valueForKey:@"productName"] url:[product valueForKey:@"productURL"] andImage:[product valueForKey:@"productImage"]];
                    [newProduct setCompanyID:[[product valueForKey:@"company_id"] intValue]];
                    [newProduct setProductOrder:[[product valueForKey:@"productOrder"] doubleValue]];
                    [productArray addObject:newProduct];
                    [newProduct release];
                    
                }
                
                [company setProducts:productArray];
                [arr addObject:company];
                [productArray release];
                [company release];

            }
            
            self.companies = arr;
            [arr release];


        }
    } else {
        NSLog(@"Error fetching Company data.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
    }
    
    [fetchRequest release];


}

#pragma mark create and edit Company and Product methods

-(void)createNewCompany:(NSString *)name andLogo:(NSString *)logo andStockSym:(NSString *)stockSym
{
    double companyOrder = 0;
    double newCompOrder = 0;
    
    if ([self.companies objectAtIndex:self.companies.count - 1] >= 0) {
        companyOrder = [(Company*)[self.companies objectAtIndex:self.companies.count - 1] order];
        newCompOrder = companyOrder + 1.0;
    } else {
        newCompOrder = 1.0;
    }
    
    int maxCompID = 0;
    
    for (Company *company in self.companies) {
        
        if (company.ID > maxCompID) {
            maxCompID = company.ID;
        }
        
    }
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"CompanyMO" inManagedObjectContext:self.managedObjectContext];
    
    NSManagedObject *newComp = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    
    [newComp setValue:name  forKey:@"name"];
    [newComp setValue:logo  forKey:@"logo"];
    [newComp setValue:stockSym forKey:@"stockSym"];
    [newComp setValue:[NSNumber numberWithDouble:newCompOrder] forKey:@"order"];
    [newComp setValue:[NSNumber numberWithInt:maxCompID + 1] forKey:@"companyID"];

    
//    [self.managedObjectContext save:nil];
    
    [self loadDataFromDB];
    
    [newComp release];

}

-(void)editCompany:(NSString *)newName logo:(NSString *)logo andIndexPathRow:(NSInteger)indexPathRow andStockSymbol:(NSString *)stockSymbol
{
    
    // Fetching
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CompanyMO"];
    
    // Add Sort Descriptor
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Execute Fetch Request
    NSError *fetchError = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    
    if (!fetchError) {
        
        NSManagedObject *company = (NSManagedObject *)[result objectAtIndex:indexPathRow];

        [company setValue:newName  forKey:@"name"];
        [company setValue:logo  forKey:@"logo"];
        [company setValue:stockSymbol forKey:@"stockSym"];

        NSError *deleteError = nil;
        
        if (![company.managedObjectContext save:&deleteError]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", deleteError, deleteError.localizedDescription);
        }
        
     //   [self.managedObjectContext save:nil];
        
        
    } else {
        NSLog(@"Error fetching Company data.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
    }
    
    [self loadDataFromDB];
    
    [fetchRequest release];

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
    
    int compID = currentCompany.ID;
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CompanyMO"];
    
    // Create Predicate
    NSPredicate *companyPredicate = [NSPredicate predicateWithFormat:@"companyID = %d", currentCompany.ID];
    [fetchRequest setPredicate:companyPredicate];
    
    // Execute Fetch Request
    NSError *fetchError = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];

    
    
    CompanyMO *companyMO = [result objectAtIndex:0];
    
    
    NSEntityDescription *productEntityDescription = [NSEntityDescription entityForName:@"ProductsMO" inManagedObjectContext:self.managedObjectContext];
    
    NSManagedObject *newProd = [[NSManagedObject alloc] initWithEntity:productEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    [newProd setValue:name forKey:@"productName"];
    [newProd setValue:image  forKey:@"productImage"];
    [newProd setValue:url forKey:@"productURL"];
    [newProd setValue:[NSNumber numberWithDouble:newProductOrder] forKey:@"productOrder"];
    [newProd setValue:[NSNumber numberWithInt:compID] forKey:@"company_id"];
    [newProd setValue:companyMO forKey:@"company"];

    
   // [self.managedObjectContext save:nil];
    [self loadDataFromDB];
    
    [newProd release];
    [fetchRequest release];

}

-(void)editProduct:(NSString *)name andImage:(NSString *)image andURL:(NSString *)url forCurrentCompany:(Company *)currentCompany atIndexPathRow:(NSInteger)indexPathRow andProduct:(Product *)product
{
    
    
    // Fetching
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ProductsMO"];
    
    // Create Predicate
    NSPredicate *companyPredicate = [NSPredicate predicateWithFormat:@"(company_id = %d) AND (productOrder == %f)", currentCompany.ID, product.productOrder];
    [fetchRequest setPredicate:companyPredicate];

    
    // Add Sort Descriptor
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"productOrder" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Execute Fetch Request
    NSError *fetchError = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    
    if (!fetchError) {
        
        NSManagedObject *product = (NSManagedObject *)[result objectAtIndex:0];
        
        [product setValue:name  forKey:@"productName"];
        [product setValue:image  forKey:@"productImage"];
        [product setValue:url forKey:@"productURL"];
        
        NSError *deleteError = nil;
        
        if (![product.managedObjectContext save:&deleteError]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", deleteError, deleteError.localizedDescription);
        }
        
       // [self.managedObjectContext save:nil];
        
        
    } else {
        NSLog(@"Error fetching Product data.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
    }
    
    [self loadDataFromDB];
    
    [fetchRequest release];
    
}


-(void)deleteCompany:(NSInteger)indexPathRow
{
    // Fetching
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CompanyMO"];
    
    // Add Sort Descriptor
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Execute Fetch Request
    NSError *fetchError = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    
    if (!fetchError) {
        
        NSManagedObject *company = (NSManagedObject *)[result objectAtIndex:indexPathRow];
        
        [self.companies removeObjectAtIndex:indexPathRow];

        [self.managedObjectContext deleteObject:company];
        
        NSError *deleteError = nil;
        
        if (![company.managedObjectContext save:&deleteError]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", deleteError, deleteError.localizedDescription);
        }
        
//        [self.managedObjectContext save:nil];
        
        
    } else {
        NSLog(@"Error fetching Company data.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
    }
    
    [fetchRequest release];

}


-(void)moveCompany:(int)companyID toIndexPathRow:(NSInteger )toIndexPathRow fromIndexPathRow:(NSInteger)fromIndexPathRow
{
    
    // Query to update Order
    double orderBefore = 0;
    double orderAfter = [self.companies count] - 1;
    
    if (toIndexPathRow == 0) {
        if ([self.companies objectAtIndex:toIndexPathRow]) {
            
            orderAfter = [(Company*)[self.companies objectAtIndex:toIndexPathRow] order];
        } else {
            return;
        }
        
    } else {
        
        if (toIndexPathRow == orderAfter) {
            orderBefore = [(Company*)[self.companies objectAtIndex:toIndexPathRow] order];
            orderAfter = orderBefore + 1.0;
            
        } else {
            
            if (toIndexPathRow > fromIndexPathRow) {
                orderBefore = [(Company*)[self.companies objectAtIndex:toIndexPathRow] order];
                orderAfter = [(Company*)[self.companies objectAtIndex:toIndexPathRow + 1] order];
                
            } else {
                
                orderBefore = [(Company*)[self.companies objectAtIndex:toIndexPathRow - 1] order];
                orderAfter = [(Company*)[self.companies objectAtIndex:toIndexPathRow] order];
                
            }
            
        }
        
    }
    
    double orderQuery = ((orderBefore + orderAfter) / 2);
    

    // Fetching
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CompanyMO"];
    
    // Add Sort Descriptor
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Execute Fetch Request
    NSError *fetchError = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    
    if (!fetchError) {
        
        NSManagedObject *company = (NSManagedObject *)[result objectAtIndex:fromIndexPathRow];
        
        [company setValue:[NSNumber numberWithDouble:orderQuery] forKey:@"order"];
        
        NSError *deleteError = nil;
        
        if (![company.managedObjectContext save:&deleteError]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", deleteError, deleteError.localizedDescription);
        }
        
       // [self.managedObjectContext save:nil];
        
        
    } else {
        NSLog(@"Error fetching Company data.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
    }
    
      [self loadDataFromDB];
        [fetchRequest release];

    
}

-(void)deleteProductWithCurrentCompany:(Company *)currentCompany atIndex:(NSInteger)indexPathRow
{

    // Fetching
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ProductsMO"];
    
    // Create Predicate
    NSPredicate *productPredicate = [NSPredicate predicateWithFormat:@"company_id = %d", currentCompany.ID];
    [fetchRequest setPredicate:productPredicate];
    
    // Add Sort Descriptor
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"productOrder" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Execute Fetch Request
    NSError *fetchError = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    
    if (!fetchError) {
        
        NSManagedObject *product = (NSManagedObject *)[result objectAtIndex:indexPathRow];
        
        [self.managedObjectContext deleteObject:product];
        
        NSError *deleteError = nil;
        
        if (![product.managedObjectContext save:&deleteError]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", deleteError, deleteError.localizedDescription);
        }
        
     //   [self.managedObjectContext save:nil];
        
        
    } else {
        NSLog(@"Error fetching Company data.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
    }
    
    [self loadDataFromDB];
    [fetchRequest release];

}

#pragma mark undo and save operations
-(void)saveContext;
{
    [self.managedObjectContext save:nil];
    [self loadDataFromDB];

}
-(void)undoContext
{
    
    [self.managedObjectContext undo];
    
    [self loadDataFromDB];
    
}


@end
