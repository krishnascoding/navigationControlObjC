//
//  CompanyCollectionViewController.m
//  NavCtrl
//
//  Created by Krishna Ramachandran on 3/14/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "CompanyCollectionViewController.h"
#import "CollectionViewCell.h"


@interface CompanyCollectionViewController ()
@property (nonatomic, retain) DAO *dao;
@property (nonatomic) bool xMarkHidden;

@end

@implementation CompanyCollectionViewController

static NSString * const reuseIdentifier = @"Cell";



//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithCollectionViewLayout:];
//    
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.xMarkHidden = YES;
    
  //  [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
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
    
    self.installsStandardGestureForInteractiveMovement = YES;
    
    [__addEditVC release];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setEditing:NO animated:true];
    [self reachability];
    __unused NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateStockPrice) userInfo:nil repeats:YES];
    [timer fire];
    [self.collectionView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)save
{
    [self.dao saveContext];
    [self.collectionView reloadData];
    
}
-(void)undo
{
    [self.dao undoContext];
    [self.collectionView reloadData];
    
}

-(void)addItem:(id)sender
{
    
    //    self.addEditVC = [[AddEditViewController alloc] initWithNibName:@"AddEditViewController" bundle:nil];
    self.addEditVC.title = @"Add Company";
    
    [self.navigationController pushViewController:self.addEditVC animated:YES];
}
-(void)updateStockPrice
{
    
    NSMutableString *baseURL = [[NSMutableString alloc ] initWithString: @"http://finance.yahoo.com/webservice/v1/symbols/"];

    
    for (int i = 0; i < [self.dao.companies count]; i++) {
        
        NSString *stock = [[self.dao.companies objectAtIndex:i]stockSym];
        
        if (![[self.dao.companies objectAtIndex:i]stockSym]) {
            
            [baseURL appendString:[NSString stringWithFormat:@"%@,", @"xyda"]];
            
            //  baseURL = (NSMutableString*)[NSString stringWithFormat:@"%@%@+", baseURL,@"xyda"];
            
        } else {
            [baseURL appendString:[NSString stringWithFormat:@"%@,", stock]];
            
            //baseURL = (NSMutableString*)[NSString stringWithFormat:@"%@%@+", baseURL,stock];
        }
        
    }

    [baseURL appendString:@"/quote?format=json"];

    NSURL *url = [NSURL URLWithString:baseURL];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [baseURL release];
    
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//        NSDictionary *responseDictionary = responseObject;
        
        for (int i = 0;i < [[responseObject valueForKeyPath:@"list.resources"] count]; i++) {
            
            NSString *stockPrice = [[[responseObject valueForKeyPath:@"list.resources"] objectAtIndex:i ] valueForKeyPath:@"resource.fields.price"];
            
            [[self.dao.companies objectAtIndex:i] setStockPrice:stockPrice];
            
        }
        
        
        [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:NULL waitUntilDone:YES];
        
        
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
}


-(void)reachability
{
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

    //    NSString *stockURL = @"http://finance.yahoo.com/d/quotes.csv?s=AAPL+jh+MSFT+GOOG&f=l1";
    
//    NSMutableString *baseURL = [[NSMutableString alloc ] initWithString: @"http://finance.yahoo.com/d/quotes.csv?s="];
    
//    for (int i = 0; i < [self.dao.companies count]; i++) {
//        
//        NSString *stock = [[self.dao.companies objectAtIndex:i]stockSym];
//        
//        if (![[self.dao.companies objectAtIndex:i]stockSym]) {
//            
//            [baseURL appendString:[NSString stringWithFormat:@"%@+", @"xyda"]];
//            
//            //  baseURL = (NSMutableString*)[NSString stringWithFormat:@"%@%@+", baseURL,@"xyda"];
//            
//        } else {
//            [baseURL appendString:[NSString stringWithFormat:@"%@+", stock]];
//            
//            //baseURL = (NSMutableString*)[NSString stringWithFormat:@"%@%@+", baseURL,stock];
//        }
//        
//    }
//    [baseURL appendString:@"@&f=l1"];
    //baseURL = (NSMutableString *)[NSString stringWithFormat:@"%@&f=l1", baseURL];
    
//    NSURLSession *session = [NSURLSession sharedSession];
//    
//    [[session dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:baseURL]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSString *stockString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
//        NSArray *rows = [stockString componentsSeparatedByString:@"\n"];
//        //_stockPrices = [[NSMutableArray alloc] init];
//        int i = 0;
//        for (NSString *row in rows) {
//            if ([row isEqualToString:@""] ) {
//                break;
//            }
//            //[self.stockPrices addObject:row];
//            [[self.dao.companies objectAtIndex:i] setStockPrice:row];
//            i++;
//        }
        //
        //        for (int i = 0; i < self.stockPrices.count; i++) {
        //
        //            [[self.dao.companies objectAtIndex:i] setStockPrice:self.stockPrices[i]];
        //
        //        }
        //
        //        NSLog(@"%@", self.stockPrices);
        
        
//        [self.collectionView performSelectorOnMainThread:@selector(reloadData)
//                                         withObject:nil
//                                      waitUntilDone:NO];
//        
//    }] resume];
//    [baseURL release];
//    
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of items
    return [self.dao.companies count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    Company *company = [self.dao.companies objectAtIndex: indexPath.row];
    
    cell.companyName.text =  company.name;
    cell.companyImage.image = [UIImage imageNamed: company.logo];
    cell.stockPrice.text = [[self.dao.companies objectAtIndex:indexPath.row] stockPrice];
    
    if (self.editing == false) {
        
        cell.xMarkOutlet.hidden = true;
    } else {
        
        cell.xMarkOutlet.hidden = false;
    }
    
    [cell.xMarkOutlet addTarget:self action:@selector(deleteCompany:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.collectionView reloadData];
    
}

#pragma mark <UICollectionViewDelegate>


// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}


// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return YES;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.editing == YES) {
        //        self.addEditVC = [[AddEditViewController alloc] initWithNibName:@"AddEditViewController" bundle:nil];
        
        self.addEditVC.title = @"Edit Company";
        self.addEditVC.indexPathRow = indexPath.row;
        
        [self.navigationController pushViewController:self.addEditVC animated:YES];
        return;
    }
    
    self.productViewController = [[[ProductCollectionViewController alloc] initWithNibName:@"ProductCollectionViewController" bundle:nil] autorelease];
    self.productViewController.title = [self.dao.companies[indexPath.row] name];
    self.productViewController.currentComp = indexPath.row;
    self.productViewController.currentCompany = self.dao.companies[indexPath.row];
    
    [self.navigationController
     pushViewController:self.productViewController
     animated:YES];
    
}

-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
    int companyID = [[self.dao.companies objectAtIndex:sourceIndexPath.row] ID];
    [self.dao moveCompany:companyID toIndexPathRow:destinationIndexPath.row fromIndexPathRow:sourceIndexPath.row];
    
    [self updateStockPrice];
    [collectionView reloadData];
 
}

-(void)deleteCompany:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:(CollectionViewCell *)[[senderButton superview] superview]];
    
    [self.dao deleteCompany:indexPath.row];
    
    [self updateStockPrice];

    [self.collectionView reloadData];
    
}

- (void)dealloc {
    [super dealloc];
}
@end
