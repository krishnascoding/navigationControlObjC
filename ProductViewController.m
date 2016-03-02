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

@property (nonatomic, retain) CompanyViewController *companyVC;
@property (nonatomic, retain) DAO *dao;

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
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.dao = [DAO sharedDAO];
    AddProductViewController* __addProductVC = [[AddProductViewController alloc] initWithNibName:@"AddProductViewController" bundle:nil];
    
    self.addProductVC = __addProductVC;
    [__addProductVC release];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addItem:(id)sender
{
    [self.addProductVC setTitle:@"Add Product"];
    [self.addProductVC setCurrentCompany:self.currentCompany];
    [self.navigationController pushViewController:self.addProductVC animated:YES];
    
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    // Configure the cell...
    
    
    cell.textLabel.text = [[self.currentCompany.products objectAtIndex:[indexPath row]] productName];
    cell.imageView.image = [UIImage imageNamed:[[self.currentCompany.products objectAtIndex:indexPath.row] productImage]];
  
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 2.0; 
    lpgr.delegate = self;
    [self.tableView addGestureRecognizer:lpgr];
    [lpgr release];
    
    
    return cell;
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    if (indexPath == nil) {
//        NSLog(@"long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
//        AddProductViewController *__addProductVC = [[AddProductViewController alloc] initWithNibName:@"AddProductViewController" bundle:nil];
        
//        [self setAddProductVC: [[AddProductViewController alloc] initWithNibName:@"AddProductViewController" bundle:nil]];
        
//        [__addProductVC release];
        
        self.addProductVC.title = @"Edit Product";
        self.addProductVC.indexPathRow = indexPath.row;
        self.addProductVC.currentCompany = self.currentCompany;
        
        [self.navigationController pushViewController:self.addProductVC animated:YES];
        
    } else {
        
    }
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    
    tableView.allowsSelectionDuringEditing = YES;
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        // Delete the selected record.
        // Find the record ID.l
        int recordToDelete = [[self.currentCompany.products objectAtIndex:indexPath.row] productID];
        [self.dao deleteProduct:recordToDelete];
        [self.currentCompany.products removeObjectAtIndex:indexPath.row];
        
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
    
    Product *product = [self.currentCompany.products objectAtIndex:indexPath.row];
    
    MyWebViewViewController *myWebView = [[MyWebViewViewController alloc] init];
    myWebView.urlString = [product productURL];
    myWebView.title = [product productName];
    
    [self.navigationController pushViewController:myWebView animated:YES];
    [myWebView release];
}


-(void)dealloc{
    [super dealloc];
}

@end
