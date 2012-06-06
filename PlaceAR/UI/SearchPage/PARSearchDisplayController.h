//
//  PARSearchDisplayController.h
//  PlaceAR
//
//  Created by Jin Jin on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PARSearchDisplayController : NSObject <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

- (id)initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)viewController;

-(void)setAllTypes:(NSArray*)types;

@end
