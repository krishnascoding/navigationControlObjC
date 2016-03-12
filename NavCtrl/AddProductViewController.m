//
//  AddProductViewController.m
//  NavCtrl
//
//  Created by Krishna Ramachandran on 2/18/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "AddProductViewController.h"
#import "DAO.h"

@interface AddProductViewController ()

@end

@implementation AddProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveItems)];
    
    self.navigationItem.rightBarButtonItem = saveButton;
    
 }

-(void)saveItems
{
    
    if ([self.title  isEqual: @"Edit Product"]) {
        
        [[DAO sharedDAO] editProduct:self.productName.text andImage:self.productLogo.text andURL:self.productURL.text forCurrentCompany:self.currentCompany atIndexPathRow:self.indexPathRow andProduct:self.currentProduct];
                
    }
    else {

        [[DAO sharedDAO] createNewProduct:self.productName.text andImage:self.productLogo.text andURL:self.productURL.text forCurrentCompany:self.currentCompany];
     
    }
    
    [self.navigationController popViewControllerAnimated:YES];

    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    if ([self.title  isEqual: @"Edit Product"]) {
        
        //        Product *product = [self.currentCompany.products objectAtIndex:self.indexPathRow];
        Product *product = self.currentProduct;
        
        
        self.productName.text = [product productName];
        self.productLogo.text = [product productImage];
        self.productURL.text = [product productURL];
        
    } else {
        self.productName.text = @"";
        self.productLogo.text = @"";
        self.productURL.text = @"";
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_productName release];
    [_productLogo release];
    [_productURL release];
    [super dealloc];
}
@end
