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
    
    // Create the refresh, fixed-space (optional), and profile buttons.
    UIBarButtonItem *undoBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undo)];
    
    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    saveBarButtonItem.style = UIBarButtonItemStyleBordered;
    
//    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
    
    self.navigationItem.leftBarButtonItems = @[addButton, saveBarButtonItem, undoBarButtonItem];
    
    self.title = @"Mobile device makers";
    
    self.dao = [DAO sharedDAO];
    [self.dao loadDataFromDB];
    
    
    AddEditViewController *__addEditVC = [[AddEditViewController alloc] initWithNibName:@"AddEditViewController" bundle:nil];
    
    self.addEditVC = __addEditVC;
    [__addEditVC release];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)save
{
    [self.dao saveContext];
    [self.tableView reloadData];

}
-(void)undo
{
    [self.dao undoContext];
    [self.tableView reloadData];

}

-(void)addItem:(id)sender
{
    
    //    self.addEditVC = [[AddEditViewController alloc] initWithNibName:@"AddEditViewController" bundle:nil];
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
    return [self.dao.companies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    Company *company = [self.dao.companies objectAtIndex: indexPath.row];
    
    cell.textLabel.text =  company.name;
    cell.imageView.image = [UIImage imageNamed: company.logo];
    cell.detailTextLabel.text = [[self.dao.companies objectAtIndex:indexPath.row] stockPrice];
    
    return cell;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.productViewController.currentCompany = nil;
    
    //    [self.dao loadDataFromDB];
    
    //
    __unused NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateStockPrice) userInfo:nil repeats:YES];
    [timer fire];
    [self.tableView reloadData];
    
}

-(void)updateStockPrice
{
    //    NSString *stockURL = @"http://finance.yahoo.com/d/quotes.csv?s=AAPL+jh+MSFT+GOOG&f=l1";
    
    NSMutableString *baseURL = [[NSMutableString alloc ] initWithString: @"http://finance.yahoo.com/d/quotes.csv?s="];
    
    for (int i = 0; i < [self.dao.companies count]; i++) {
        
        NSString *stock = [[self.dao.companies objectAtIndex:i]stockSym];
        
        if (![[self.dao.companies objectAtIndex:i]stockSym]) {
            
            [baseURL appendString:[NSString stringWithFormat:@"%@+", @"xyda"]];
            
            //  baseURL = (NSMutableString*)[NSString stringWithFormat:@"%@%@+", baseURL,@"xyda"];
            
        } else {
            [baseURL appendString:[NSString stringWithFormat:@"%@+", stock]];
            
            //baseURL = (NSMutableString*)[NSString stringWithFormat:@"%@%@+", baseURL,stock];
        }
        
    }
    [baseURL appendString:@"@&f=l1"];
    //baseURL = (NSMutableString *)[NSString stringWithFormat:@"%@&f=l1", baseURL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:baseURL]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *stockString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        NSArray *rows = [stockString componentsSeparatedByString:@"\n"];
        //_stockPrices = [[NSMutableArray alloc] init];
        int i = 0;
        for (NSString *row in rows) {
            if ([row isEqualToString:@""] ) {
                break;
            }
            //[self.stockPrices addObject:row];
            [[self.dao.companies objectAtIndex:i] setStockPrice:row];
            i++;
        }
        //
        //        for (int i = 0; i < self.stockPrices.count; i++) {
        //
        //            [[self.dao.companies objectAtIndex:i] setStockPrice:self.stockPrices[i]];
        //
        //        }
        //
        //        NSLog(@"%@", self.stockPrices);
        
        
        [self.tableView performSelectorOnMainThread:@selector(reloadData)
                                         withObject:nil
                                      waitUntilDone:NO];
        
    }] resume];
    [baseURL release];
    
    //    [self.stockPrices release];
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
        // Delete the selected record
        // Find the record ID
        //        int recordToDelete = [[self.dao.companies objectAtIndex:indexPath.row] ID];
        [self.dao deleteCompany:indexPath.row];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
    [self.tableView reloadData];
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    int companyID = [[self.dao.companies objectAtIndex:fromIndexPath.row] ID];
    [self.dao moveCompany:companyID toIndexPathRow:toIndexPath.row fromIndexPathRow:fromIndexPath.row];
    
    [tableView reloadData];
    
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
        //        self.addEditVC = [[AddEditViewController alloc] initWithNibName:@"AddEditViewController" bundle:nil];
        self.addEditVC.title = @"Edit Company";
        self.addEditVC.indexPathRow = indexPath.row;
        
        [self.navigationController pushViewController:self.addEditVC animated:YES];
        return;
    }
    
    
    self.productViewController.title = [self.dao.companies[indexPath.row] name];
    self.productViewController.currentComp = indexPath.row;
    self.productViewController.currentCompany = self.dao.companies[indexPath.row];
    
    [self.navigationController
     pushViewController:self.productViewController
     animated:YES];
}


@end
