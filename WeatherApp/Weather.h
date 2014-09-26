//
//  Weather.h
//  WeatherApp
//
//  Created by Pavel on 9/27/14.
//  Copyright (c) 2014 Pavel Anashkevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject

@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *country;

@property (nonatomic, copy) NSDate *reportTime;
@property (nonatomic, copy) NSDate *sunrise;
@property (nonatomic, copy) NSDate *sunset;

@property (nonatomic, copy) NSArray *conditions;

@property (nonatomic) NSInteger cloudCover;
@property (nonatomic) NSInteger humidity;
@property (nonatomic) NSInteger pressure;
@property (nonatomic) NSInteger rain3hours;
@property (nonatomic) NSInteger show3hours;

@property (nonatomic) float tempCurrent;

@property (nonatomic) NSInteger windDirection;

@end
