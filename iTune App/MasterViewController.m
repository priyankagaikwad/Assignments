//
//  MasterViewController.m
//  iTune App
//
//  Created by synerzip on 26/09/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"



@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end


@implementation MasterViewController

NSMutableArray *appNamesArray, *imageView, *rightsArray, *linkArray, *priceArray, *artistArray, *categoryArray, *releaseDateArray;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    appNamesArray = [[NSMutableArray alloc] init];
    imageView = [[NSMutableArray alloc] init];
    rightsArray = [[NSMutableArray alloc] init];
    priceArray = [[NSMutableArray alloc] init];
    artistArray = [[NSMutableArray alloc] init];
    releaseDateArray = [[NSMutableArray alloc] init];
    linkArray = [[NSMutableArray alloc] init];
    categoryArray = [[NSMutableArray alloc] init];
    
    NSData *allData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:@"https://itunes.apple.com/us/rss/newfreeapplications/limit=2/json"]];
        
             [self fetchiTuneDataInArrayFromJson:allData];
    
}

-(void) fetchiTuneDataInArrayFromJson:(NSData *) allData
{
    NSDictionary *allDataInDictionary;
    NSDictionary *feedDictionary;
    NSArray *pathForDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *pathString = [pathForDirectory objectAtIndex:0];
    NSString *filePath =[pathString stringByAppendingFormat:@"iTuneData.json"];
    if (allData != NULL)
    {
        allDataInDictionary = [NSJSONSerialization JSONObjectWithData:allData options:kNilOptions error:nil];
        feedDictionary = allDataInDictionary[@"feed"];
    }else
    {
        feedDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
        if (feedDictionary == NULL) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please check your internet connection" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    [feedDictionary writeToFile:filePath atomically:YES];
    NSArray *entry = feedDictionary[@"entry"];
    NSDictionary *nameDictionary, *rightsDictionary, *priceDictionary, *artistDictionary, *releaseDateDictionary, *linkDictionary, *categoryDictionary, *subDictionary;
    for (NSDictionary *try in entry)
    {
        NSArray *image = try[@"im:image"];
        NSDictionary *imageLogoDictionary = [image objectAtIndex:0];
        [imageView insertObject:imageLogoDictionary[@"label"] atIndex:[imageView count]];
        
        nameDictionary = try[@"im:name"];
        [appNamesArray insertObject:nameDictionary[@"label"] atIndex:[appNamesArray count]];
        
        artistDictionary = try[@"im:artist"];
        [artistArray insertObject:artistDictionary[@"label"] atIndex:[artistArray count]];
        
        priceDictionary = try[@"im:price"];
        subDictionary = priceDictionary[@"attributes"];
        [priceArray insertObject:[NSString stringWithFormat:@"%@%@",subDictionary[@"amount"], subDictionary[@"currency"]] atIndex:[priceArray count]];
        
        releaseDateDictionary = try[@"im:releaseDate"];
        subDictionary = releaseDateDictionary[@"attributes"];
        [releaseDateArray insertObject:subDictionary[@"label"] atIndex:[releaseDateArray count]];
        
        linkDictionary = try[@"link"];
        subDictionary = linkDictionary[@"attributes"];
        [linkArray insertObject:subDictionary[@"href"] atIndex:[linkArray count]];
        
        categoryDictionary = try[@"category"];
        subDictionary = categoryDictionary[@"attributes"];
        [categoryArray insertObject:subDictionary[@"label"] atIndex:[categoryArray count]];
        
        rightsDictionary = try[@"rights"];
        [rightsArray insertObject:rightsDictionary[@"label"] atIndex:[rightsArray count]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [appNamesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageWithData:[ NSData dataWithContentsOfURL:[ NSURL URLWithString:[imageView objectAtIndex:indexPath.row]]]];
    cell.textLabel.text = [appNamesArray objectAtIndex:indexPath.row];

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController * detailViewController = segue.destinationViewController;
        detailViewController.appLogoImageFromURL = [UIImage imageWithData:[ NSData dataWithContentsOfURL:[ NSURL URLWithString:[imageView objectAtIndex:indexPath.row]]]];
        detailViewController.appNameString = [appNamesArray objectAtIndex:indexPath.row];
        detailViewController.artistString = [artistArray objectAtIndex:indexPath.row];
        detailViewController.priceString = [priceArray objectAtIndex:indexPath.row];
        detailViewController.releaseDateString = [releaseDateArray objectAtIndex:indexPath.row];
        detailViewController.linkString = [linkArray objectAtIndex:indexPath.row];
        detailViewController.categoryString = [categoryArray objectAtIndex:indexPath.row];
        detailViewController.rightString = [rightsArray objectAtIndex:indexPath.row];
    }
}

@end
