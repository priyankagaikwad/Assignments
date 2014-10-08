//
//  DetailViewController.h
//  iTune App
//
//  Created by synerzip on 26/09/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UIImageView *appLogoImage;
@property (strong,nonatomic) NSString *appNameString, *rightString, *priceString, *artistString, *releaseDateString, *linkString, *categoryString;
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;

@property (strong , nonatomic) UIImage *appLogoImageFromURL;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightsLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

- (IBAction)OpenLink:(id)sender;

@end
