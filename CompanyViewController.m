//
//  CompanyViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "CompanyViewController.h"
#import "ProductViewController.h"

@interface CompanyViewController ()

@end

@implementation CompanyViewController

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
//    self.companyList = [[NSMutableArray alloc] initWithObjects:@"Apple mobile devices",@"Samsung mobile devices", @"Microsoft", @"Dell", nil];
//    self.companyLogos = [[NSMutableArray alloc] initWithObjects:@"appleimage.jpg", @"samsunglogo.jpg", @"microsoftlogo.png", @"delllogo.jpg", nil];
    
//    self.companyList = @[@"Apple mobile devices",@"Samsung mobile devices", @"Microsoft", @"Dell"];
//    self.companyLogos = @[@"appleimage.jpg", @"samsunglogo.jpg", @"microsoftlogo.png", @"delllogo.jpg"];
    self.title = @"Mobile device makers";
    
    Company *apple = [[Company alloc] initWithName:@"Apple mobile devices" logo:@"appleimage.jpg"];
    
     Company *samsung = [[Company alloc] initWithName:@"Samsung mobile devices" logo:@"samsunglogo.jpg"];
    
     Company *microsoft = [[Company alloc] initWithName:@"Microsoft" logo:@"microsoftlogo.png"];
    
    Company *dell = [[Company alloc] initWithName:@"Dell" logo:@"delllogo.jpg"];
    
    self.companyList = [[NSMutableArray alloc] initWithObjects:apple, samsung, microsoft, dell, nil];
    
    // Create and add Products to Company instances
    // Apple products
    Product *iPad = [[Product alloc] initWithName:@"iPad" url:@"http://www.apple.com/ipad/" andImage:@"ipad.jpg"];
    
    Product *iPhone = [[Product alloc] initWithName:@"iPhone" url:@"http://www.apple.com/iphone/" andImage:@"iphone.jpg"];
    
    Product *iPodTouch = [[Product alloc] initWithName:@"iPod Touch" url:@"http://www.apple.com/ipod-touch/" andImage:@"ipodtouch.jpg"];
    
    apple.products = [[NSMutableArray alloc] initWithObjects:iPad, iPhone,iPodTouch, nil];
    
    // Samsung products
    
    Product *galaxyS4 = [[Product alloc] initWithName:@"Galaxy S4" url:@"http://www.samsung.com/global/microsite/galaxys4/" andImage:@"galaxys4.jpg"];
    Product *galaxyNote = [[Product alloc] initWithName:@"Galaxy Note" url: @"http://www.samsung.com/global/microsite/galaxynote/note/index.html?type=find" andImage:@"galaxynote.jpg"];
    Product *galaxyTab = [[Product alloc] initWithName:@"Galaxy Tab" url: @"http://www.samsung.com/us/mobile/galaxy-tab/" andImage:@"galaxytab.jpg"];
    
    samsung.products = [[NSMutableArray alloc] initWithObjects:galaxyS4, galaxyTab, galaxyNote, nil];
    
    // Microsoft Products
    
    Product *windows = [[Product alloc] initWithName:@"Windows" url: @"https://www.microsoft.com/en-us/windows/" andImage:@"windows.jpg"];
    Product *office = [[Product alloc] initWithName:@"Office" url: @"https://products.office.com/en-us/home" andImage:@"office.jpg"];
    Product *lumia = [[Product alloc] initWithName:@"Lumia" url:@"https://www.microsoft.com/en-us/mobile/" andImage:@"lumia.png"];
    microsoft.products = [[NSMutableArray alloc] initWithObjects:windows, office, lumia, nil];
    
    // Dell Products
    
    Product *inspiron = [[Product alloc] initWithName:@"Inspiron" url:@"http://www.dell.com/us/p/laptops/inspiron-laptops" andImage:@"inspiron.jpg"];
    Product *chromeBook = [[Product alloc] initWithName:@"Chromebook" url:@"http://www.dell.com/us/business/p/chromebook-13-7310/pd?oc=ss0010c731013us&model_id=chromebook-13-7310" andImage:@"chromebook.jpg"];
    Product *venuePro = [[Product alloc] initWithName:@"Venue Pro" url:@"http://www.dell.com/us/business/p/dell-venue-8-pro-5855-tablet/pd?oc=bto10005t58558usca&model_id=dell-venue-8-pro-5855-tablet&l=en&s=bsd" andImage:@"venuepro.jpg"];
    
    dell.products = [[NSMutableArray alloc] initWithObjects:inspiron, chromeBook, venuePro, nil];
    
    NSLog(@"%@", [[apple.products objectAtIndex:0] productName]);
    
    
    
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
    return [self.companyList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
//    cell.textLabel.text = [self.companyList objectAtIndex:[indexPath row]];
//    [[cell imageView] setImage:[UIImage imageNamed:self.companyLogos[indexPath.row]]];
    
    cell.textLabel.text = [[self.companyList objectAtIndex:[indexPath row]] name];
    cell.imageView.image = [UIImage imageNamed:[[self.companyList objectAtIndex:indexPath.row] logo]];
//    [[cell imageView] setImage:[UIImage imageNamed:self.companyList[indexPath.row]]];
    
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
        
        [self.companyList removeObjectAtIndex:indexPath.row];
        [self.companyLogos removeObjectAtIndex:indexPath.row];
        
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
    //Move items around in companyList array
    id company = [[[self.companyList objectAtIndex:fromIndexPath.row] retain] autorelease];
    [self.companyList removeObjectAtIndex:fromIndexPath.row];
    [self.companyList insertObject:company atIndex:toIndexPath.row];
    //Move items around in companyLogos array
    id logo = [[[self.companyLogos objectAtIndex:fromIndexPath.row] retain] autorelease];
    [self.companyLogos removeObjectAtIndex:fromIndexPath.row];
    [self.companyLogos insertObject:logo atIndex:toIndexPath.row];
    
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


//    if (indexPath.row == 0){
//        self.productViewController.title = @"Apple mobile devices";
//    } else {
//        self.productViewController.title = @"Samsung mobile devices";
//    }
    
    self.productViewController.title = [self.companyList[indexPath.row] name];
    self.productViewController.currentCompany = self.companyList[indexPath.row];
    self.productViewController.companyList = self.companyList;
    
    [self.navigationController
        pushViewController:self.productViewController
        animated:YES];

}


@end
