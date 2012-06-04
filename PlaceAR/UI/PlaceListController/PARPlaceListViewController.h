//
//  PARPlaceListViewController.h
//  PlaceAR
//
//  Created by 金 津 on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PARPlaceListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSArray* placeList;
@property (nonatomic, retain) IBOutlet UITableView* tableView;

@end
