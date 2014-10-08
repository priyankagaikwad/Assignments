//
//  DetailViewController.m
//  iTune App
//
//  Created by synerzip on 26/09/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
      //  self.appDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _appLogoImage.image = _appLogoImageFromURL;
    _appNameLabel.text = _appNameString ;
    _artistLabel.text = _artistString;
    _priceLabel.text = _priceString;
    _releaseDateLabel.text = _releaseDateString;
    _categoryLabel.text = _categoryString;
    _rightsLabel.text = _rightString;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OpenLink:(id)sender {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_linkString]];
}
@end
