//
//  MasterViewController.h
//  iTune App
//
//  Created by synerzip on 26/09/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface MasterViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

- (void) fetchiTuneDataInArrayFromJson:(NSData *) allData;
- (NSInteger) indexCountOfArrayOfImage: (NSString *) labelName;
- (void) downloadImage:(NSString *)labelAsImageName:(NSURL *) url;
@end
