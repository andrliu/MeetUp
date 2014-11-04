//
//  ViewController.m
//  MeetUp
//
//  Created by Andrew Liu on 11/3/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "Event.h"

#define kMeetUp @"https://api.meetup.com/2/open_events.json?zip=60604&text=mobile&time=,1w&key=4970561d7a144e22212a20546191a45"

@interface RootViewController () <UITableViewDataSource, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *eventTableView;
@property (strong, nonatomic) NSDictionary *jsonDictionary;
@property (strong, nonatomic) NSArray *jsonArray;
@property (strong, nonatomic) NSDictionary *eventDictionary;
@property (strong, nonatomic) NSMutableArray *eventArray;
@property (strong, nonatomic) NSString *api;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.eventArray = [[NSMutableArray alloc]init];

    NSURL *url = [NSURL URLWithString:kMeetUp];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
                        {
                               if (connectionError)
                               {

                                   UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Error"
                                                                                                  message:connectionError.localizedDescription
                                                                                           preferredStyle:UIAlertControllerStyleAlert];

                                   UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel"
                                                                                    style:UIAlertActionStyleDefault
                                                                                  handler:nil];
                                   [alert addAction:action];

                                   [self presentViewController:alert animated:YES completion:nil];
                               }
                               else
                               {
                                   self.jsonDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                      options:0
                                                                                        error:nil];
                                   self.jsonArray = self.jsonDictionary [@"results"];


                                   for (NSDictionary *dictionary in self.jsonArray)
                                   {
                                       Event *event = [[Event alloc] initWithDictionary:dictionary];
                                       [self.eventArray addObject:event];
                                   }

                                   [self.eventTableView reloadData];
                               }
                        }
    ];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell" forIndexPath:indexPath];

    NSDictionary *resultDictionary = self.jsonArray [indexPath.row];

    cell.textLabel.text = resultDictionary[@"name"];

    NSDictionary *venueDictionary = resultDictionary[@"venue"];

    NSString *street = venueDictionary[@"address_1"];

    NSString *city = venueDictionary[@"city"];

    NSString *state = venueDictionary[@"state"];

    NSString *address = [NSString stringWithFormat:@"%@, %@, %@ 60604", street, city, state];

    cell.detailTextLabel.text = address;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.jsonArray.count;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailViewController *dvc = segue.destinationViewController;
    NSInteger rowNumber = [self.eventTableView indexPathForSelectedRow].row;
    Event *event  = [self.eventArray objectAtIndex:rowNumber];
    dvc.eventDetail = event;
}

@end


