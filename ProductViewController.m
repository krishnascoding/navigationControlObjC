//
//  ProductViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "ProductViewController.h"
#import "MyWebViewViewController.h"

@interface ProductViewController ()
//@property (nonatomic, retain) MyWebViewViewController *myWebView;

@property (nonatomic, retain) CompanyViewController *companyVC;

@end

@implementation ProductViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Company list - same as  as CompanyViewController
//    self.companyList = [[NSMutableArray alloc] initWithObjects:apple, samsung, microsoft, dell, nil];
    
    // Company products dictionary
//    self.companyProducts = [[NSMutableDictionary alloc] init];
//    [self.companyProducts setValue:[NSMutableArray arrayWithArray: @[@"Galaxy S4", @"Galaxy Note", @"Galaxy Tab"]] forKey:@"Samsung mobile devices"];
//    [self.companyProducts setValue:[NSMutableArray arrayWithArray: @[@"iPad", @"iPod Touch",@"iPhone"]] forKey:@"Apple mobile devices"];
//    [self.companyProducts setValue:[NSMutableArray arrayWithArray:@[@"Windows",@"Office", @"Lumia"]] forKey:@"Microsoft"];
//    [self.companyProducts setValue:[NSMutableArray arrayWithArray:@[@"Inspiron",@"Chromebook", @"Venue Pro"]] forKey:@"Dell"];
//    
//    // Product URL dictionary
//    self.productURLs = [[NSMutableDictionary alloc] init];
//    [self.productURLs setValue:[NSMutableArray arrayWithArray:@[@"http://www.samsung.com/global/microsite/galaxys4/", @"http://www.samsung.com/global/microsite/galaxynote/note/index.html?type=find", @"http://www.samsung.com/us/mobile/galaxy-tab/"]] forKey:@"Samsung mobile devices"];
//    [self.productURLs setValue:[NSMutableArray arrayWithArray:@[@"http://www.apple.com/ipad/", @"http://www.apple.com/ipod-touch/",@"http://www.apple.com/iphone/"]] forKey:@"Apple mobile devices"];
//    [self.productURLs setValue:[NSMutableArray arrayWithArray:@[@"https://www.microsoft.com/en-us/windows/",@"https://products.office.com/en-us/home", @"https://www.microsoft.com/en-us/mobile/"]] forKey:@"Microsoft"];
//    [self.productURLs setValue:[NSMutableArray arrayWithArray:@[@"http://www.dell.com/us/p/laptops/inspiron-laptops",@"http://www.dell.com/us/business/p/chromebook-13-7310/pd?oc=ss0010c731013us&model_id=chromebook-13-7310", @"http://www.dell.com/us/business/p/dell-venue-8-pro-5855-tablet/pd?oc=bto10005t58558usca&model_id=dell-venue-8-pro-5855-tablet&l=en&s=bsd"]] forKey:@"Dell"];
//    
//    // Product image dictionary
//    self.productImages = [[NSMutableDictionary alloc] init];
//    [self.productImages setValue:[NSMutableArray arrayWithArray:@[@"galaxys4.jpg", @"galaxynote.jpg", @"galaxytab.jpg"]] forKey:@"Samsung mobile devices"];
//    [self.productImages setValue:[NSMutableArray arrayWithArray:@[@"ipad.jpg", @"ipodtouch.jpg",@"iphone.jpg"]] forKey:@"Apple mobile devices"];
//    [self.productImages setValue:[NSMutableArray arrayWithArray:@[@"windows.jpg",@"office.jpg", @"lumia.png"]] forKey:@"Microsoft"];
//    [self.productImages setValue:[NSMutableArray arrayWithArray:@[@"inspiron.jpg",@"chromebook.jpg", @"venuepro.jpg"]] forKey:@"Dell"];
//    
//    
    
    
    
    
    

    
    
//    self.companyVC = [[CompanyViewController alloc] init];
//    self.companyVC.productViewController = self;
 

//    [[[self.companyVC.companyList objectAtIndex:self.currentCompany]  products] addObject:iPad];
//    [[[self.companyVC.companyList objectAtIndex:self.currentCompany]  products] addObject:iPhone];
//    [[[self.companyVC.companyList objectAtIndex:self.currentCompany]  products] addObject:iPodTouch];

    

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.products = self.currentCompany.products;
    
//    
//    if ([self.title isEqualToString:@"Apple mobile devices"]) {
//        
//        self.products = @[@"iPad", @"iPod Touch",@"iPhone"];
//        
//    } else if ([self.title isEqualToString:@"Samsung mobile devices"]) {
//        
//        self.products = @[@"Galaxy S4", @"Galaxy Note", @"Galaxy Tab"];
//        
//    } else if ([self.title isEqualToString:@"Microsoft"]) {
//        
//        self.products = @[@"Windows",@"Office", @"Lumia"];
//        
//    } else {
//    
//          self.products = @[@"Inspiron",@"Chromebook", @"Venue Pro"];
//
//    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.currentCompany.products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.textLabel.text = [[self.products objectAtIndex:[indexPath row]] productName];
    cell.imageView.image = [UIImage imageNamed:[[self.products objectAtIndex:indexPath.row] productImage]];
//    [[cell imageView] setImage:[UIImage imageNamed:[[self.productImages objectForKey:self.currentCompany] objectAtIndex:indexPath.row]]];
    
    
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        [self.currentCompany.products removeObjectAtIndex:indexPath.row];
        
        
//        [[self.companyProducts objectForKey:self.currentCompany] removeObjectAtIndex:indexPath.row];
//        [[self.productImages objectForKey:self.currentCompany] removeObjectAtIndex:indexPath.row];
//        [[self.productURLs objectForKey:self.currentCompany] removeObjectAtIndex:indexPath.row];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
    [tableView reloadData];
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    //Move item from companyProducts
    id product = [[[self.currentCompany.products objectAtIndex:fromIndexPath.row] retain] autorelease];
    [self.currentCompany.products removeObjectAtIndex:fromIndexPath.row];
    [self.currentCompany.products insertObject:product atIndex:toIndexPath.row];
    
    
//    id products = [[[[self.companyProducts objectForKey:self.currentCompany] objectAtIndex:fromIndexPath.row] retain] autorelease];
//    [[self.companyProducts objectForKey:self.currentCompany] removeObjectAtIndex:fromIndexPath.row];
//    [[self.companyProducts objectForKey:self.currentCompany] insertObject:products atIndex:toIndexPath.row];
//    // Move items from companyImages
//    id images = [[[[self.productImages objectForKey:self.currentCompany] objectAtIndex:fromIndexPath.row] retain] autorelease];
//    [[self.productImages objectForKey:self.currentCompany] removeObjectAtIndex:fromIndexPath.row];
//    [[self.productImages objectForKey:self.currentCompany] insertObject:images atIndex:toIndexPath.row];
//    // Move items from productURLs
//    id urls = [[[[self.productURLs objectForKey:self.currentCompany] objectAtIndex:fromIndexPath.row] retain] autorelease];
//    [[self.productURLs objectForKey:self.currentCompany] removeObjectAtIndex:fromIndexPath.row];
//    [[self.productURLs objectForKey:self.currentCompany] insertObject:urls atIndex:toIndexPath.row];
    
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//     Pass the selected object to the new view controller.
//     Push the view controller.
    
    MyWebViewViewController *myWebView = [[MyWebViewViewController alloc] init];
    myWebView.urlString = [[self.products objectAtIndex:indexPath.row] productURL];
    myWebView.title = [[self.products objectAtIndex:indexPath.row]productName];
    
//    myWebView.urlString = [[self.productURLs valueForKey:self.currentCompany] objectAtIndex:indexPath.row];
//    myWebView.title = [[self.companyProducts valueForKey:self.currentCompany] objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:myWebView animated:YES];
}
 

@end
