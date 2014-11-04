//
//  DetailViewController.m
//  MeetUp
//
//  Created by Andrew Liu on 11/3/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import "DetailViewController.h"
#import "WebViewController.h"
#import "MemberViewController.h"
#import "Comment.h"

@interface DetailViewController () <UITableViewDataSource, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *RSVPLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;
@property (weak, nonatomic) IBOutlet UIWebView *eventView;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (strong, nonatomic) NSDictionary *jsonCommentDictionary;
@property (strong, nonatomic) NSArray *jsonCommentArray;
@property (strong, nonatomic) NSMutableArray *commentArray;
@property (strong, nonatomic) NSString *commentURL;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.commentArray = [[NSMutableArray alloc]init];

    self.navigationItem.title = self.eventDetail.name;

    self.RSVPLabel.text = [NSString stringWithFormat:@"RSVP counts: %@",[self.eventDetail.count stringValue]];

    self.groupLabel.text = [NSString stringWithFormat:@"Group info: %@", self.eventDetail.groupInfo];

    [self.eventView loadHTMLString:self.eventDetail.eventDescription baseURL:nil];

    self.commentURL = [NSString stringWithFormat:@"https://api.meetup.com/2/event_comments?&sign=true&photo-host=public&group_id=%@&event_id=%@&page=20&key=4970561d7a144e22212a20546191a45", self.eventDetail.groupID,  self.eventDetail.eventID];
    
    [self loadAPI:self.commentURL];

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
                             self.jsonCommentDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                   options:0
                                                                                     error:nil];
                             self.jsonCommentArray = self.jsonCommentDictionary [@"results"];


                             for (NSDictionary *dictionary in self.jsonCommentArray)
                             {
                                 Comment *comment = [[Comment alloc] initWithDictionary:dictionary];
                                 [self.commentArray addObject:comment];
                             }

                             [self.commentTableView reloadData];
                         }
                     }
     ];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];

    NSDictionary *resultDictionary = self.jsonCommentArray [indexPath.row];

    cell.textLabel.text = resultDictionary[@"member_name"];

    cell.detailTextLabel.text = resultDictionary[@"comment"];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.jsonCommentArray.count;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)webSegue
{
    if ([segue.identifier isEqual:@"webSegue"])
    {
        WebViewController *wvc = segue.destinationViewController;
        wvc.eventWebDetail = self.eventDetail;
    }
    else
    {
        MemberViewController *mvc = segue.destinationViewController;
        NSInteger rowNumber = [self.commentTableView indexPathForSelectedRow].row;
        Comment *comment  = [self.commentArray objectAtIndex:rowNumber];
        mvc.commentDetail = comment;
    }
}



@end
