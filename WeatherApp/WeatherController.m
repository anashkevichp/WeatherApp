//
//  MainTableViewController.m
//  WeatherApp
//
//  Created by Pavel on 9/27/14.
//  Copyright (c) 2014 Pavel Anashkevich. All rights reserved.
//

#import "AFNetworking.h"
#import "WeatherController.h"
#import "Weather.h"

#define BASE_URL @"http://api.openweathermap.org/data/2.5/weather"

@implementation WeatherController {
    NSDictionary *weatherServiceResponse;
}

- (id) init {
    self = [super init];
    
    weatherServiceResponse = @{};
    
    return self;
}

- (void) getCurrentWeather:(NSString *)query {
    
    NSString *requestURLText = [NSString stringWithFormat:@"%@?q=%@", BASE_URL, query];
    NSURL *requestURL = [NSURL URLWithString:requestURLText];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        weatherServiceResponse = (NSDictionary *) responseObject;
        [self parseWeatherResponse];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"connection fail");
    }];
    
    [operation start];
}

- (void) parseWeatherResponse
{
    Weather *weather = [[Weather alloc] init];
    
    weather.city = weatherServiceResponse[@"name"];
    weather.tempCurrent = [WeatherController kelvinToCelcius:[weatherServiceResponse[@"main"][@"temp"] doubleValue]];
    
    NSLog(@"%f", weather.tempCurrent);
}

+ (double) kelvinToCelcius:(double)degrees {
    const double CELSIUS_ZERO_IN_KELVIN = 273.15;
    return degrees - CELSIUS_ZERO_IN_KELVIN;
}

@end
