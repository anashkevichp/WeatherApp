//
//  MainTableViewController.m
//  WeatherApp
//
//  Created by Pavel on 9/27/14.
//  Copyright (c) 2014 Pavel Anashkevich. All rights reserved.
//

#import "MainTableViewController.h"
#import "WeatherDetailController.h"
#import "WeatherViewCell.h"
#import "AFNetworking.h"
#import "Weather.h"

#define BASE_URL @"http://api.openweathermap.org/data/2.5/weather"
#define DEFAULT_WEATHER_PLIST_NAME @"defaultWeather"
#define WEATHER_PLIST_NAME @"weather.plist"

@interface MainTableViewController ()
{
    int updateCounter;
}

- (void) updateCounter:(NSNotification *) notification;

@end

@implementation MainTableViewController {
    NSMutableDictionary *weatherDict;
    NSMutableArray *weatherArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    weatherArray = [[NSMutableArray alloc] init];
    weatherDict = [[NSMutableDictionary alloc] init];
    
    updateCounter = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCounter:) name:@"UpdateCounter" object:nil];
    
    NSString *filePath = [self getWeatherPlistFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSLog(@"file exists");
        [self readDictFromPlist];
    } else {
        NSLog(@"first run!");
        [self readDefaultWeatherFromPlist];
    }
    [self convertDictToArray];
    [self updateWeatherInformation];
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

- (void) getWeatherByCity:(NSString *) city
{
    NSString *requestURLText = [NSString stringWithFormat:@"%@?q=%@", BASE_URL, city];
    NSURL *requestURL = [NSURL URLWithString:requestURLText];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *currentWeather = [[NSDictionary alloc] init];
        currentWeather = (NSDictionary *) responseObject;
        [weatherDict setObject:currentWeather forKey:city];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCounter" object:self];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"connection fail");
    }];
    
    [operation start];
}

- (void) updateWeatherInformation
{
    for (Weather *weather in weatherArray) {
        [self getWeatherByCity:[weather city]];
    }
}

- (void) convertDictToArray
{
    weatherArray = [[NSMutableArray alloc] init];
    
    Weather *weather;
    for (NSString *key in [weatherDict allKeys]) {
        
        weather = [[Weather alloc] init];
        NSDictionary *currentWeather = [weatherDict valueForKey:key];
        
        weather.city = currentWeather[@"name"];
        weather.currentTempreture = [self kelvinToCelcius:[currentWeather[@"main"][@"temp"] doubleValue]];
        
        [weatherArray addObject:weather];
    }
}

- (double) kelvinToCelcius:(double) degrees
{
    const double CELSIUS_ZERO_IN_KELVIN = 273.15;
    return degrees - CELSIUS_ZERO_IN_KELVIN;
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        NSInteger selected = [[self.tableView indexPathForSelectedRow] row];
        [weatherArray removeObjectAtIndex:selected];
        
        // remove data from plist / dictionary
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        NSLog(@"adding item");
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"WeatherDetailSegue"]) {
        WeatherDetailController *detailController  = [segue destinationViewController];
        
        NSInteger selected = [[self.tableView indexPathForSelectedRow] row];
        
        detailController.weather = [weatherArray objectAtIndex:selected];
        
        NSString *city = [[weatherArray objectAtIndex:selected] city];
        detailController.navigationItem.title = city;
    }
}

@end
