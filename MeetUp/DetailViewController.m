//
//  DetailViewController.m
//  MeetUp
//
//  Created by Andrew Liu on 11/3/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import "DetailViewController.h"
#import "WebViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *RSVPLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;
@property (weak, nonatomic) IBOutlet UIWebView *eventView;


@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = self.eventDetail.name;

    self.RSVPLabel.text = [NSString stringWithFormat:@"RSVP counts: %@",[self.eventDetail.count stringValue]];

    self.groupLabel.text = [NSString stringWithFormat:@"Group info: %@", self.eventDetail.groupInfo];

    [self.eventView loadHTMLString:self.eventDetail.eventDescription baseURL:nil];

}

- (IBAction)eventPageOnButtonPressed:(UIButton *)sender
{
    
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WebViewController *wvc = segue.destinationViewController;
    wvc.eventWebDetail = self.eventDetail;

}

@end
