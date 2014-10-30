//
//  MasterViewController.m
//  iTune App
//
//  Created by synerzip on 26/09/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "MasterViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "Reachability.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end


@implementation MasterViewController

NSMutableArray *appNames, *imageURLs, *rights, *links, *prices, *artists, *categories, *releaseDates, *downloadImages,*directoryContents;
AppDelegate *appDelegate;
NSData *offlineImageData;
NSArray *filePaths;
NSInteger indexCountForImages = 0;
- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
	
    appNames          = [[NSMutableArray alloc] init];
    imageURLs         = [[NSMutableArray alloc] init];
    rights            = [[NSMutableArray alloc] init];
    prices            = [[NSMutableArray alloc] init];
    artists           = [[NSMutableArray alloc] init];
    releaseDates      = [[NSMutableArray alloc] init];
    links             = [[NSMutableArray alloc] init];
    categories        = [[NSMutableArray alloc] init];
    downloadImages    = [[NSMutableArray alloc] init];
    directoryContents = [[NSMutableArray alloc] init];
    //Activity indicator
    [self.tableView addSubview:_activity];
    [self.tableView bringSubviewToFront:_activity];
    _activity.center = self.tableView.center;
    [_activity startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/us/rss/newfreeapplications/limit=2/json"];
        NSURLResponse *response;
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
        NSData *iTuneData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
        [self fetchiTuneDataInArrayFromJson:iTuneData];
        dispatch_async(dispatch_get_main_queue(),^{
            [self.tableView reloadData];
        });
    });
}

-(void) fetchiTuneDataInArrayFromJson:(NSData *) allData
{
    NSDictionary *allDataInDictionary;
    NSDictionary *feedDictionary;
    NSArray *pathForDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *pathString = [pathForDirectory objectAtIndex:0];
    NSString *filePath =[pathString stringByAppendingFormat:@"iTuneData.json"];
    if (appDelegate.hasInternet)  {
        allDataInDictionary = [NSJSONSerialization JSONObjectWithData:allData options:kNilOptions error:nil];
        feedDictionary = allDataInDictionary[@"feed"];
    }
    else {
        feedDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    }
    [feedDictionary writeToFile:filePath atomically:YES];
    NSArray *entry = feedDictionary[@"entry"];
    NSDictionary *nameDictionary, *rightsDictionary, *priceDictionary, *artistDictionary, *releaseDateDictionary, *linkDictionary, *categoryDictionary, *subDictionary;
    for (NSDictionary *try in entry)
    {
        nameDictionary = try[@"im:name"];
        [appNames insertObject:nameDictionary[@"label"] atIndex:[appNames count]];
        
        NSArray *images = try[@"im:image"];
        NSDictionary *imageLogoDictionary = [images objectAtIndex:0];
        [imageURLs insertObject:imageLogoDictionary[@"label"] atIndex:[imageURLs count]];
        NSURL *imageUrl = [NSURL URLWithString:imageLogoDictionary[@"label"]];
        //Download image for offline mode
        [self downloadImage:nameDictionary[@"label"]:imageUrl];
        
        artistDictionary = try[@"im:artist"];
        [artists insertObject:artistDictionary[@"label"] atIndex:[artists count]];
        
        priceDictionary = try[@"im:price"];
        subDictionary = priceDictionary[@"attributes"];
        [prices insertObject:[NSString stringWithFormat:@"%@%@",subDictionary[@"amount"], subDictionary[@"currency"]] atIndex:[prices count]];
        
        releaseDateDictionary = try[@"im:releaseDate"];
        subDictionary = releaseDateDictionary[@"attributes"];
        [releaseDates insertObject:subDictionary[@"label"] atIndex:[releaseDates count]];
        
        linkDictionary = try[@"link"];
        subDictionary = linkDictionary[@"attributes"];
        [links insertObject:subDictionary[@"href"] atIndex:[links count]];
        
        categoryDictionary = try[@"category"];
        subDictionary = categoryDictionary[@"attributes"];
        [categories insertObject:subDictionary[@"label"] atIndex:[categories count]];
        
        rightsDictionary = try[@"rights"];
        [rights insertObject:rightsDictionary[@"label"] atIndex:[rights count]];
    }
    
    //offline image
    
    NSString *stringPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    filePaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] error:nil];
    
    for(int i=0;i<[filePaths count];i++)
    {
        NSString *filePath = [filePaths objectAtIndex:i];
        if ([[filePath pathExtension] isEqualToString:@"jpg"] || [[filePath pathExtension] isEqualToString:@"png"] || [[filePath pathExtension] isEqualToString:@"PNG"]) {
            NSString *imagePath = [[stringPath stringByAppendingFormat:@"/"] stringByAppendingFormat:@"%@",filePath];
            NSData *data = [NSData dataWithContentsOfFile:imagePath];
            if(data) {
                UIImage *image = [UIImage imageWithData:data];
                [directoryContents addObject:image];
            }
        }
        else {
            [directoryContents addObject:[directoryContents objectAtIndex:0]];
        }
    }
}

-(void) downloadImage:(NSString *)labelAsImageName:(NSURL *) imageUrl
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *imageName = [NSString stringWithFormat:@"%@%@",labelAsImageName,@".png"];
    NSString *pathTosaveImage = [docPath stringByAppendingPathComponent:imageName];
    if (![fileManager fileExistsAtPath:pathTosaveImage]) {
        NSString *pathTosaveImage = [docPath stringByAppendingPathComponent:imageName];
        offlineImageData = [NSData dataWithContentsOfURL:imageUrl];
        if (offlineImageData) {
            [offlineImageData writeToFile:pathTosaveImage atomically:YES];
        }
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [appNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *logo ;
        if (appDelegate.hasInternet) {
            logo = [UIImage imageWithData:[ NSData dataWithContentsOfURL:[ NSURL URLWithString:[imageURLs objectAtIndex:indexPath.row]]]];
        }
        else {
            indexCountForImages = [self indexCountOfArrayOfImage:[appNames objectAtIndex:indexPath.row]];
            logo = [directoryContents objectAtIndex:indexCountForImages];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = logo;
        });
    });
    cell.textLabel.text = [appNames objectAtIndex:indexPath.row];
    [_activity stopAnimating];
    _activity.hidden = YES;
    return cell;
}

- (NSInteger ) indexCountOfArrayOfImage : (NSString *) labelName
{
    NSInteger count = 0;
    for (NSString * imageName in filePaths)
    {
        NSString* imageNames = [[imageName lastPathComponent] stringByDeletingPathExtension];
        if([labelName isEqualToString:imageNames]){
            return count;
        }
        count++;
    }
    return 0;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController * detailViewController = segue.destinationViewController;
        if(appDelegate.hasInternet) {
           detailViewController.appLogoImageFromURL = [UIImage imageWithData:[ NSData dataWithContentsOfURL:[ NSURL URLWithString:[imageURLs objectAtIndex:indexPath.row]]]];
        }
        else {
            indexCountForImages = [self indexCountOfArrayOfImage:[appNames objectAtIndex:indexPath.row]];
            detailViewController.appLogoImageFromURL = [directoryContents objectAtIndex:indexCountForImages];
        }
        detailViewController.appNameString = [appNames objectAtIndex:indexPath.row];
        detailViewController.artistString = [artists objectAtIndex:indexPath.row];
        detailViewController.priceString = [prices objectAtIndex:indexPath.row];
        detailViewController.releaseDateString = [releaseDates objectAtIndex:indexPath.row];
        detailViewController.linkString = [links objectAtIndex:indexPath.row];
        detailViewController.categoryString = [categories objectAtIndex:indexPath.row];
        detailViewController.rightString = [rights objectAtIndex:indexPath.row];
    }
}

@end
