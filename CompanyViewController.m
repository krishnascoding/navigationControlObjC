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
@property (nonatomic, retain) DAO *dao;
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
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    self.navigationItem.leftBarButtonItem = addButton;
    
    self.title = @"Mobile device makers";
    
    self.dao = [DAO sharedDAO];
    NSLog(@"first->%@",self.dao.companies);
    [self.dao createCompanies];
//       NSLog(@"second->%@",dao1.companies);
    self.companyList = self.dao.companies;
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addItem:(id)sender
{
 
    self.addEditVC = [[AddEditViewController alloc] initWithNibName:@"AddEditViewController" bundle:nil];
    self.addEditVC.title = @"Add Company";
    
    [self.navigationController pushViewController:self.addEditVC animated:YES];
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
    
    Company *company = [self.dao.companies objectAtIndex: indexPath.row];
    
       
    cell.textLabel.text =  company.name;
    cell.imageView.image = [UIImage imageNamed: company.logo];
    
    return cell;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
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
        
        [self.companyList removeObjectAtIndex:indexPath.row];
//        [self.companyLogos removeObjectAtIndex:indexPath.row];
        
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
//    //Move items around in companyLogos array
//    id logo = [[[self.companyLogos objectAtIndex:fromIndexPath.row] retain] autorelease];
//    [self.companyLogos removeObjectAtIndex:fromIndexPath.row];
//    [self.companyLogos insertObject:logo atIndex:toIndexPath.row];
    
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
    
    if (tableView.editing == YES) {
        self.addEditVC = [[AddEditViewController alloc] initWithNibName:@"AddEditViewController" bundle:nil];
        self.addEditVC.title = @"Edit Company";
        self.addEditVC.indexPathRow = indexPath.row;
        
        [self.navigationController pushViewController:self.addEditVC animated:YES];
        return;
    }
    
    self.productViewController.title = [self.dao.companies[indexPath.row] name];
    self.productViewController.currentCompany = self.companyList[indexPath.row];
    self.productViewController.companyList = self.companyList;
    
    [self.navigationController
        pushViewController:self.productViewController
        animated:YES];
}


@end
