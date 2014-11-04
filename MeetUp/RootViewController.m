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

#define kMeetUp @"https://api.meetup.com/2/open_events.json?text=mobile&time=,1w&key=4970561d7a144e22212a20546191a45"

@interface RootViewController () <UITableViewDataSource, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *eventTableView;
@property (strong, nonatomic) NSDictionary *jsonDictionary;
@property (strong, nonatomic) NSArray *jsonArray;
@property (strong, nonatomic) NSMutableArray *eventArray;
@property (strong, nonatomic) NSString *api;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.eventArray = [[NSMutableArray alloc]init];

    [self loadAPI:kMeetUp];

}

- (void)loadAPI: (NSString *)theURL
{
    NSURL *url = [NSURL URLWithString:theURL];

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:urlRequest
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



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *urlString = [NSString stringWithFormat:@"https://api.meetup.com/2/open_events.json?text=%@&time=,1w&key=4970561d7a144e22212a20546191a45", self.searchTextField.text];

    [self loadAPI: urlString];

    self.searchTextField.text = [NSString stringWithFormat:@""];

    return YES;
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

    NSString *address = [NSString stringWithFormat:@"%@, %@, %@", street, city, state];

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


