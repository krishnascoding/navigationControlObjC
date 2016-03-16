//
//  ProductCollectionViewController.m
//  NavCtrl
//
//  Created by Krishna Ramachandran on 3/15/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "ProductCollectionViewController.h"
#import "MyWebViewViewController.h"
#import "ProductCollectionViewCell.h"


@interface ProductCollectionViewController ()
@property (nonatomic, retain) DAO *dao;
@property (nonatomic) bool xMarkHidden;

@end

@implementation ProductCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    self.xMarkHidden = YES;
    
//    [self.collectionView registerClass:[ProductCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    // self.navigationItem.leftBarButtonItem = addButton;
    
    // Create the refresh, fixed-space (optional), and profile buttons.
    UIBarButtonItem *undoBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undo)];
    
    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    saveBarButtonItem.style = UIBarButtonItemStyleBordered;
    
    UIBarButtonItem *deleteBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(delete)];
    deleteBarButtonItem.style = UIBarButtonItemStyleBordered;

    
    //    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
    
    self.navigationItem.rightBarButtonItems = @[addButton, saveBarButtonItem, undoBarButtonItem, deleteBarButtonItem];
    
    self.dao = [DAO sharedDAO];
    AddProductViewController* __addProductVC = [[AddProductViewController alloc] initWithNibName:@"AddProductViewController" bundle:nil];
    
    self.addProductVC = __addProductVC;
    [__addProductVC release];
    
    self.installsStandardGestureForInteractiveMovement = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.currentCompany = self.dao.companies[self.currentComp];
    [self.collectionView reloadData];
}
-(void)save
{
    [self.dao saveContext];
    self.currentCompany = self.dao.companies[self.currentComp];
    
    [self.collectionView reloadData];
    self.editing = false;
    
}
-(void)undo
{
    [self.dao undoContext];
    self.currentCompany = self.dao.companies[self.currentComp];
    [self.collectionView reloadData];
    self.editing = false;
    
}
-(void)delete
{
    self.editing = true;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addItem:(id)sender
{
    [self.addProductVC setTitle:@"Add Product"];
    [self.addProductVC setCurrentCompany:self.currentCompany];
    [self.navigationController pushViewController:self.addProductVC animated:YES];
    
    [self.collectionView reloadData];
    
}

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
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.currentCompany.products count];
}

-  (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    cell.productName.text = [[self.currentCompany.products objectAtIndex:[indexPath row]] productName];
    cell.productImage.image = [UIImage imageNamed:[[self.currentCompany.products objectAtIndex:indexPath.row] productImage]];
    
    
    if (self.editing == false) {
        
        cell.xMarkProduct.hidden = true;
    } else {
        
        cell.xMarkProduct.hidden = false;
    }
    
    [cell.xMarkProduct addTarget:self action:@selector(deleteCompany:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    Product *product = [self.currentCompany.products objectAtIndex:indexPath.row];
    
    MyWebViewViewController *myWebView = [[MyWebViewViewController alloc] init];
    myWebView.urlString = [product productURL];
    myWebView.title = [product productName];
    
    [self.navigationController pushViewController:myWebView animated:YES];
    [myWebView release];

    
}

//-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
//{
//    
//
//}

-(void)deleteCompany:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:(ProductCollectionViewCell *)[[senderButton superview] superview]];
    
    [self.dao deleteProductWithCurrentCompany:self.currentCompany atIndex:indexPath.row];
    [self.currentCompany.products removeObjectAtIndex:indexPath.row];
    
    [self.collectionView reloadData];
    self.editing = false;
}

- (void)dealloc {
    [super dealloc];
}
@end
