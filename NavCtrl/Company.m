//
//  Company.m
//  NavCtrl
//
//  Created by Krishna Ramachandran on 2/12/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "Company.h"

@implementation Company

-(instancetype)initWithName:(NSString *)name logo:(NSString *)logo
{
    self = [super init];
    
    if (self) {
        
        _name = name;
        _logo = logo;
        [_name retain];
        [_logo retain];
        
        return self;
    }
    return nil;
}


@end
