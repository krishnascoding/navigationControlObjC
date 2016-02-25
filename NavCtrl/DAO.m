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

//-(NSMutableArray *)createCompanies
//{
//    
//    if (self.companies == nil) {
// 
//
//    Company *apple = [[Company alloc] initWithName:@"Apple mobile devices" logo:@"appleimage.jpg"];
//        [apple setStockSym:@"AAPL"];
//    
//    
//    Company *samsung = [[Company alloc] initWithName:@"Samsung mobile devices" logo:@"samsunglogo.jpg"];
//        [samsung setStockSym:@"SSNLF"];
//
//    
//    Company *microsoft = [[Company alloc] initWithName:@"Microsoft" logo:@"microsoftlogo.png"];
//        [microsoft setStockSym:@"MSFT"];
//
//    
//    Company *dell = [[Company alloc] initWithName:@"Dell" logo:@"delllogo.jpg"];
//        
//        [dell setStockSym:@"GOOG"];
//
//    
////    NSMutableArray *companyList = [[NSMutableArray alloc] initWithObjects:apple, samsung, microsoft, dell, nil];
//    
//    self.companies = [[NSMutableArray alloc] init];
//    [self.companies addObject:apple];
//    [self.companies addObject:samsung];
//    [self.companies addObject:microsoft];
//    [self.companies addObject:dell];
//
//
//    // Create and add Products to Company instances
//    // Apple products
//    Product *iPad = [[Product alloc] initWithName:@"iPad" url:@"http://www.apple.com/ipad/" andImage:@"ipad.jpg"];
//    
//    Product *iPhone = [[Product alloc] initWithName:@"iPhone" url:@"http://www.apple.com/iphone/" andImage:@"iphone.jpg"];
//    
//    Product *iPodTouch = [[Product alloc] initWithName:@"iPod Touch" url:@"http://www.apple.com/ipod-touch/" andImage:@"ipodtouch.jpg"];
//    
//    apple.products = [[NSMutableArray alloc] initWithObjects:iPad, iPhone,iPodTouch, nil];
//    
//    // Samsung products
//    
//    Product *galaxyS4 = [[Product alloc] initWithName:@"Galaxy S4" url:@"http://www.samsung.com/global/microsite/galaxys4/" andImage:@"galaxys4.jpg"];
//    Product *galaxyNote = [[Product alloc] initWithName:@"Galaxy Note" url: @"http://www.samsung.com/global/microsite/galaxynote/note/index.html?type=find" andImage:@"galaxynote.jpg"];
//    Product *galaxyTab = [[Product alloc] initWithName:@"Galaxy Tab" url: @"http://www.samsung.com/us/mobile/galaxy-tab/" andImage:@"galaxytab.jpg"];
//    
//    samsung.products = [[NSMutableArray alloc] initWithObjects:galaxyS4, galaxyTab, galaxyNote, nil];
//    
//    // Microsoft Products
//    
//    Product *windows = [[Product alloc] initWithName:@"Windows" url: @"https://www.microsoft.com/en-us/windows/" andImage:@"windows.jpg"];
//    Product *office = [[Product alloc] initWithName:@"Office" url: @"https://products.office.com/en-us/home" andImage:@"office.jpg"];
//    Product *lumia = [[Product alloc] initWithName:@"Lumia" url:@"https://www.microsoft.com/en-us/mobile/" andImage:@"lumia.png"];
//    microsoft.products = [[NSMutableArray alloc] initWithObjects:windows, office, lumia, nil];
//    
//    // Dell Products
//    
//    Product *inspiron = [[Product alloc] initWithName:@"Inspiron" url:@"http://www.dell.com/us/p/laptops/inspiron-laptops" andImage:@"inspiron.jpg"];
//    Product *chromeBook = [[Product alloc] initWithName:@"Chromebook" url:@"http://www.dell.com/us/business/p/chromebook-13-7310/pd?oc=ss0010c731013us&model_id=chromebook-13-7310" andImage:@"chromebook.jpg"];
//    Product *venuePro = [[Product alloc] initWithName:@"Venue Pro" url:@"http://www.dell.com/us/business/p/dell-venue-8-pro-5855-tablet/pd?oc=bto10005t58558usca&model_id=dell-venue-8-pro-5855-tablet&l=en&s=bsd" andImage:@"venuepro.jpg"];
//    
//    dell.products = [[NSMutableArray alloc] initWithObjects:inspiron, chromeBook, venuePro, nil];
//
//    
//    return self.companies;
//    }
//    return self.companies;
//}

-(void)createNewCompany:(NSString *)name andLogo:(NSString *)logo
{
    
    Company *newCompany = [[Company alloc] initWithName:name logo:logo];

    [self.companies addObject:newCompany];
    
}

-(void)editCompany:(NSString *)newName logo:(NSString *)logo andIndexPath:(NSInteger)indexPath andStockSymbol:(NSString *)stockSymbol
{
   
    [[self.companies objectAtIndex:indexPath] setLogo:logo];
    [[self.companies objectAtIndex:indexPath] setName: newName];
    [[self.companies objectAtIndex:indexPath] setStockSym: stockSymbol];

    
}
-(void)createNewProduct:(NSString *)name andImage:(NSString *)image andURL:(NSString *)url forCurrentCompany:(Company *)currentCompany
{
    Product *newProduct = [[Product alloc] initWithName:name url:url andImage:image];
    
    [currentCompany.products addObject:newProduct];

}

-(void)editProduct:(NSString *)name andImage:(NSString *)image andURL:(NSString *)url forCurrentCompany:(Company *)currentCompany atIndexPath:(NSInteger)indexPath
{
    [[currentCompany.products objectAtIndex:indexPath] setProductName:name];
    [[currentCompany.products objectAtIndex:indexPath] setProductImage:image];
    [[currentCompany.products objectAtIndex:indexPath] setProductURL:url];
    
}


@end
