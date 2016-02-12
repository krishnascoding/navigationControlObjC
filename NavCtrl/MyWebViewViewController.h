//
//  MyWebViewViewController.h
//  NavCtrl
//
//  Created by Krishna Ramachandran on 2/11/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface MyWebViewViewController : UIViewController <WKNavigationDelegate>

@property (nonatomic, retain) UIWebView *myWebView;
@property (nonatomic, retain) NSString *urlString;

@end
