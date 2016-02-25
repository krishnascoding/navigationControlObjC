//
//  AddEditViewController.h
//  NavCtrl
//
//  Created by Krishna Ramachandran on 2/17/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddEditViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *companyName;
@property (retain, nonatomic) IBOutlet UITextField *companyLogoURL;
@property (nonatomic) NSInteger indexPathRow;
@property (retain, nonatomic) IBOutlet UITextField *stockSymbol;


@end
