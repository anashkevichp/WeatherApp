//
//  WeatherDetailController.m
//  WeatherApp
//
//  Created by Pavel Anashkevich on 9/29/14.
//  Copyright (c) 2014 Pavel Anashkevich. All rights reserved.
//

#import "WeatherDetailController.h"
#import "WeatherDetailCell.h"

#define CURRENT_WEATHER_SECTION 0
#define FORECAST_WEATHER_SECTION 1

@interface WeatherDetailController ()

@end

@implementation WeatherDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case CURRENT_WEATHER_SECTION:
            return @"Current weather";
        case FORECAST_WEATHER_SECTION:
            return @"Forecast weather";
        default:
            return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"WeatherDetailCell";
    WeatherDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[WeatherDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    long section = [indexPath section];
    long row = [indexPath row];
    
    switch (section) {
        case CURRENT_WEATHER_SECTION:
            
            switch (row) {
                case 0:
                    cell.nameLabel.text = @"Temreture";
                    cell.valueLabel.text = [NSString stringWithFormat:@"%.1f", [[self weather] currentTempreture]];
                    break;
                case 1:
                    cell.nameLabel.text = @"Temreture";
                    cell.valueLabel.text = [NSString stringWithFormat:@"%.1f", [[self weather] currentTempreture]];
                    break;
                default:
                    break;
            }
            
            
        case FORECAST_WEATHER_SECTION:
            cell.nameLabel.text = @"test2";
            cell.valueLabel.text = @"2";
            break;
    }
    
    cell.nameLabel.text = [[self weather] city];
    // NSLog(@"%@", [[self weather] city]);
    
    cell.valueLabel.text =  [NSString stringWithFormat:@"%.1f", [[self weather] currentTempreture]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
