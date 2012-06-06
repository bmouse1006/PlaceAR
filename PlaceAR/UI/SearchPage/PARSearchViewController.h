//
//  PARSearchViewController.h
//  PlaceAR
//
//  Created by 金 津 on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PARSearchViewController : UIViewController<UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UIView* mainContent;
@property (nonatomic, retain) IBOutlet UIView* deemBackground;

@property (nonatomic, retain) IBOutlet UISearchBar* searchBar;

-(void)show;

@end
