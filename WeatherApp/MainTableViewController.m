//
//  MainTableViewController.m
//  WeatherApp
//
//  Created by Pavel on 9/27/14.
//  Copyright (c) 2014 Pavel Anashkevich. All rights reserved.
//

#import "MainTableViewController.h"
#import "WeatherDetailController.h"
#import "AddWeatherController.h"
#import "WeatherViewCell.h"
#import "AFNetworking.h"
#import "Weather.h"

#define BASE_URL @"http://api.openweathermap.org/data/2.5/weather"
#define DEFAULT_WEATHER_PLIST_NAME @"defaultWeather"
#define WEATHER_PLIST_NAME @"weather.plist"
#define SUCCESS_CITY_CODE 200

@interface MainTableViewController ()
{
    int updateCounter;
    BOOL connectionSuccess;
}

- (void) updateWeatherInformation;
- (void) getWeatherByCity:(NSString *) city;

- (void) refreshTableView:(UIRefreshControl *) refreshControl;
- (void) convertDictToArray;
- (void) updateCounter:(NSNotification *) notification;

- (void) readDefaultWeatherFromPlist;
- (void) readDictFromPlist;
- (void) saveWeatherDictToPlist;
- (NSString *) getWeatherPlistFilePath;

- (void) showConnectionError;
- (void) showDeleteError;
- (void) showCityError:(NSNotification *) notification;

- (IBAction)cancel:(UIStoryboardSegue *) segue;
- (IBAction)done:(UIStoryboardSegue *) segue;

@end

@implementation MainTableViewController {
    NSMutableDictionary *weatherDict;
    NSMutableArray *weatherArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    weatherArray = [[NSMutableArray alloc] init];
    weatherDict = [[NSMutableDictionary alloc] init];
    
    connectionSuccess = YES;
    updateCounter = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCounter:) name:@"UpdateCounter" object:nil];
    
    NSString *filePath = [self getWeatherPlistFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [self readDictFromPlist];
    } else {
        [self readDefaultWeatherFromPlist];
    }
    [self convertDictToArray];
    [self updateWeatherInformation];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    [refreshControl addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [weatherArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"WeatherCellIdentifier";
    WeatherViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[WeatherViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];
    }
    
    long row = [indexPath row];
    Weather *weather = [[Weather alloc] init];
    weather = [weatherArray objectAtIndex:row];
    
    cell.cityLabel.text = [weather city];
    cell.tempLabel.text = [NSString stringWithFormat:@"%.1f°", [weather currentTempreture]];
    
    return cell;
}


- (IBAction)done:(UIStoryboardSegue *)segue
{
    AddWeatherController *addWeatherController = [segue sourceViewController];
    NSString *city = [addWeatherController city];
    
    updateCounter = (int)[weatherArray count] - 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCounter:) name:@"UpdateCounter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCityError:) name:@"ShowCityError" object:nil];
    [self getWeatherByCity:city];
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    
}

- (void) updateWeatherInformation
{
    for (Weather *weather in weatherArray) {
        if (connectionSuccess) {
            [self getWeatherByCity:[weather city]];
        } else {
            break;
        }
    }
    if (!connectionSuccess) {
        [self showConnectionError];
    }
}

- (void) getWeatherByCity:(NSString *) city
{
    NSString *requestURLText = [NSString stringWithFormat:@"%@?q=%@", BASE_URL, city];
    NSURL *requestURL = [NSURL URLWithString:requestURLText];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        connectionSuccess = YES;
        
        NSDictionary *currentWeather = [[NSDictionary alloc] init];
        currentWeather = (NSDictionary *) responseObject;
        
        if ([currentWeather[@"cod"] integerValue] == SUCCESS_CITY_CODE) {
            
            [weatherDict setObject:currentWeather forKey:currentWeather[@"name"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCounter" object:self];
            
        } else {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowCityError" object:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        connectionSuccess = NO;
        
    }];
    [operation start];
}

- (void) refreshTableView:(UIRefreshControl *) refreshControl
{
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing weather..."];
    
    updateCounter = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCounter:) name:@"UpdateCounter" object:nil];
    [self updateWeatherInformation];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    
    [refreshControl endRefreshing];
}

- (void) convertDictToArray
{
    weatherArray = [[NSMutableArray alloc] init];
    
    Weather *weather;
    for (NSString *key in [weatherDict allKeys]) {
        
        weather = [[Weather alloc] init];
        NSDictionary *currentWeather = [weatherDict valueForKey:key];
        
        weather.city = currentWeather[@"name"];
        weather.country = currentWeather[@"sys"][@"country"];
        
        weather.currentTempreture = [self kelvinToCelcius:[currentWeather[@"main"][@"temp"] doubleValue]];
        weather.minTempreture = [self kelvinToCelcius:[currentWeather[@"main"][@"temp_min"] doubleValue]];
        weather.maxTempreture = [self kelvinToCelcius:[currentWeather[@"main"][@"temp_max"] doubleValue]];
        
        weather.humidity = [currentWeather[@"main"][@"humidity"] integerValue];
        weather.windSpeed = [currentWeather[@"wind"][@"speed"] doubleValue];
        weather.pressure = [currentWeather[@"main"][@"pressure"] integerValue];
        weather.cloudCover = [currentWeather[@"clouds"][@"all"] integerValue];
        
        weather.rain3hours = [currentWeather[@"rain"][@"3h"] integerValue];
        weather.snow3hours = [currentWeather[@"snow"][@"3h"] integerValue];
        
        [weatherArray addObject:weather];
    }
}

- (void) readDefaultWeatherFromPlist
{
    NSString *defaultWeatherFilePath = [[NSBundle mainBundle] pathForResource:DEFAULT_WEATHER_PLIST_NAME ofType:@"plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:defaultWeatherFilePath]) {
        weatherDict = [NSMutableDictionary dictionaryWithContentsOfFile:defaultWeatherFilePath];
    }
}

- (void) saveWeatherDictToPlist
{
    NSString *filePath = [self getWeatherPlistFilePath];
    [weatherDict writeToFile:filePath atomically:YES];
}

- (void) readDictFromPlist
{
    NSString *filePath = [self getWeatherPlistFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        weatherDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    }
}

- (NSString *) getWeatherPlistFilePath
{
    NSArray	*paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *filePath = [documentsDir stringByAppendingPathComponent:WEATHER_PLIST_NAME];
    return filePath;
}

- (void) updateCounter:(NSNotification *)notification
{
    updateCounter++;
    
    if (updateCounter == (int)[weatherArray count]) {
        [self convertDictToArray];
        [self saveWeatherDictToPlist];
        [[self tableView] reloadData];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if ([weatherArray count] > 1) {
            NSInteger selected = [indexPath row];
        
            NSString *selectedCity = [[weatherArray objectAtIndex:selected] city];
            [weatherArray removeObjectAtIndex:selected];
            [weatherDict removeObjectForKey:selectedCity];
            [self saveWeatherDictToPlist];
        
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [self showDeleteError];
        }
    }
}

- (void) showConnectionError
{
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Update error"
                                                             message:@"Please, check your internet connection"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
    [errorAlertView show];
}

- (void) showDeleteError
{
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Delete error"
                                                             message:@"Impossible to delete last city"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
    [errorAlertView show];
}

- (void) showCityError:(NSNotification *) notification
{
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"City error"
                                                             message:@"Please, check name of the city"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
    [errorAlertView show];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (double) kelvinToCelcius:(double) degrees
{
    const double CELSIUS_ZERO_IN_KELVIN = 273.15;
    return degrees - CELSIUS_ZERO_IN_KELVIN;
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"WeatherDetailSegue"]) {
        WeatherDetailController *detailController  = [segue destinationViewController];
        
        NSInteger selected = [[self.tableView indexPathForSelectedRow] row];
        
        detailController.weather = [weatherArray objectAtIndex:selected];
        
        NSString *city = [[weatherArray objectAtIndex:selected] city];
        NSString *country = [[weatherArray objectAtIndex:selected] country];
        NSString *title = [NSString stringWithFormat:@"%@, %@", city, country];
        detailController.navigationItem.title = title;
    }
}

@end
