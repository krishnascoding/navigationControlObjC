//
//  AddProductViewController.h
//  NavCtrl
//
//  Created by Krishna Ramachandran on 2/18/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Company.h"

@interface AddProductViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *productName;
@property (retain, nonatomic) IBOutlet UITextField *productLogo;
@property (retain, nonatomic) IBOutlet UITextField *productURL;
@property (nonatomic, retain) Company *currentCompany;
@property (nonatomic, retain) Product *currentProduct;
@property (nonatomic) NSInteger indexPathRow;

@end
