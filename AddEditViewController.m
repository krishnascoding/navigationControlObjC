//
//  AddEditViewController.m
//  NavCtrl
//
//  Created by Krishna Ramachandran on 2/17/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "AddEditViewController.h"
#import "DAO.h"

@interface AddEditViewController ()


@end

@implementation AddEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    DAO *dao = [DAO sharedDAO];

    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveItems)];
    
    self.navigationItem.rightBarButtonItem = saveButton;
    
    if ([self.title  isEqual: @"Edit Company"]) {
        self.companyName.text = [[[[DAO sharedDAO] companies] objectAtIndex:self.indexPathRow] name];
        self.companyLogoURL.text = [[[[DAO sharedDAO] companies] objectAtIndex:self.indexPathRow] logo];
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)saveItems
{
    if ([self.title  isEqual: @"Edit Company"]) {
        
        [[DAO sharedDAO] editCompany:self.companyName.text logo:self.companyLogoURL.text andIndexPath:self.indexPathRow];
        
    }
    else {
        
    [[DAO sharedDAO] createNewCompany:self.companyName.text andLogo:self.companyLogoURL.text];
        
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
    [_companyName release];
    [_companyLogoURL release];
    [super dealloc];
}
@end
