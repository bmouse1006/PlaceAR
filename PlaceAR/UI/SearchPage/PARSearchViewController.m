//
//  PARSearchViewController.m
//  PlaceAR
//
//  Created by 金 津 on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PARSearchViewController.h"
#import "GooglePlaceClient.h"

@interface PARSearchViewController ()

@property (nonatomic, retain) NSArray* categories;
@property (nonatomic, retain) NSDictionary* types;
@property (nonatomic, retain) NSMutableArray* tableItems;
@property (nonatomic, retain) NSMutableSet* unfoldedCategories;

@end

@implementation PARSearchViewController

@synthesize deemBackground = _deemBackground, mainContent = _mainContent;
@synthesize categories = _categories, types = _types;
@synthesize unfoldedCategories = _unfoldedCategories;
@synthesize tableItems = _tableItems;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.deemBackground = nil;
    self.mainContent = nil;
    self.categories = nil;
    self.types = nil;
    self.tableItems = nil;
    self.unfoldedCategories = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarStatusChanged:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
        [self setupPlaceTypeData];
        self.tableItems = [NSMutableArray array];
        [self.tableItems addObjectsFromArray:self.categories];
        self.unfoldedCategories = [NSMutableSet set];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - data initiate
-(void)setupPlaceTypeData{
    NSArray* allTypes = [GooglePlaceClient googlePlaceTypeList];
    NSMutableArray* categories = [NSMutableArray array];
    NSMutableDictionary* types = [NSMutableDictionary dictionary];
    [allTypes enumerateObjectsUsingBlock:^(NSDictionary* userInfo, NSUInteger idx, BOOL* stop){
        NSString* category = [userInfo objectForKey:@"category"];
        NSString* type = [userInfo objectForKey:@"types"];
        [categories addObject:category];
        [types setObject:type forKey:category];
    }];
    
    self.categories = categories;
    self.types = types;
}

#pragma mark - search bar and search display delegate

#pragma mark - view appearence
-(void)statusBarStatusChanged:(NSNotification*)notification{
    CGRect frame = [[notification.userInfo objectForKey:UIApplicationStatusBarFrameUserInfoKey] CGRectValue];
    frame.origin.y += 20.0f;
    [UIView animateWithDuration:0.2f animations:^{
        self.mainContent.frame = frame;
    }];
}

-(void)show{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    self.deemBackground.alpha = 0.0f;
    CGRect frame = self.mainContent.frame;
    frame.origin.x = 0;
    frame.origin.y = -frame.size.height;
    self.mainContent.frame = frame;
    
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationCurveEaseOut animations:^{
        self.deemBackground.alpha = 1.0f;
        CGRect frame = self.mainContent.frame;
        frame.origin.y = ([UIApplication sharedApplication].statusBarHidden)?0.0f:20.0f;
        self.mainContent.frame = frame;
    } completion:NULL];
}

-(void)dismissAnimated:(BOOL)animated{
    double duration = animated?0.4f:0;
    [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationCurveEaseIn animations:^{
        CGRect frame = self.mainContent.frame;
        frame.origin.y -= frame.size.height;
        self.mainContent.frame = frame;
        
        self.deemBackground.alpha = 0.0f;
    } completion:^(BOOL finished){
        [self.view removeFromSuperview];
        self.view = nil;
    }];
}

#pragma mark - table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tableItems count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = [self objectAtIndexPath:indexPath];
    
    static NSString* categoryIdentifier = @"categoryIdentifier";
    static NSString* typeIdentifier = @"typeIdentifier";
    UITableViewCell* cell = nil;
    
    if ([self.categories containsObject:[item description]]){
        cell = [tableView dequeueReusableCellWithIdentifier:categoryIdentifier];
        if (cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:categoryIdentifier] autorelease];
            cell.indentationLevel = 0;
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:typeIdentifier];
        if (cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:typeIdentifier] autorelease];
            cell.indentationLevel = 1;
        }
    }
    
    cell.textLabel.text = GoogleClientLocalizedString([item description], nil);
    
    return cell;
}

-(id)objectAtIndexPath:(NSIndexPath*)indexPath{
    return [self.tableItems objectAtIndex:indexPath.row];
}

#pragma mark - table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = [self objectAtIndexPath:indexPath];
    if ([self.categories containsObject:item]){
        //fold or unfold types
        if ([self.unfoldedCategories containsObject:item]){
            //fold
            [self foldForItem:item indexPath:indexPath tableView:tableView];    
        }else{
            //unfold
            [self unfoldForItem:item indexPath:indexPath tableView:tableView];
        }
    }else{
        //search type
        [self sendSearchNotificationWithType:item];
        [self dismissAnimated:YES];
    }
}

-(void)foldForItem:(id)item indexPath:(NSIndexPath*)indexPath tableView:(UITableView*)tableView{
    NSArray* types = [self.types objectForKey:item];
    [self.tableItems removeObjectsInArray:types];
    NSMutableArray* indexPaths = [NSMutableArray array];
    for (int i = 0; i < [types count]; i++){
        NSIndexPath* ip = [NSIndexPath indexPathForRow:indexPath.row + 1 + i inSection:0];
        [indexPaths addObject:ip];
    }
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.unfoldedCategories removeObject:item];
}

-(void)unfoldForItem:(id)item indexPath:(NSIndexPath*)indexPath tableView:(UITableView*)tableView{
    NSArray* types = [self.types objectForKey:item];
    NSRange range = {indexPath.row+1, [types count]};
    NSIndexSet* indexes = [[[NSIndexSet alloc] initWithIndexesInRange:range] autorelease];
    
    [self.tableItems insertObjects:types atIndexes:indexes];
    
    NSMutableArray* indexPaths = [NSMutableArray array];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL* stop){
        [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:indexPath.section]]; 
    }];
    [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.unfoldedCategories addObject:item];
}

#pragma mark - send search notification
-(void)sendSearchNotificationWithType:(NSString*)type{
    NSDictionary* parameters = [NSDictionary dictionaryWithObject:[NSArray arrayWithObject:type] forKey:@"types"];
    [self sendSearchNotificationWithParameters:parameters];
}

-(void)sendSearchNotificationWithParameters:(NSDictionary*)parameters{
    NSNotification* notification = [NSNotification notificationWithName:NOTIFICATION_STARTSEARCHING object:nil userInfo:[NSDictionary dictionaryWithObject:parameters forKey:@"parameters"]];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
