//
//  MemberViewController.m
//  MeetUp
//
//  Created by Andrew Liu on 11/3/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import "MemberViewController.h"

@interface MemberViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *memberWebView;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *networkActivityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *backwardButton;
@property NSString *memberURL;

@end

@implementation MemberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.commentDetail.memberName;
    self.memberURL = [NSString stringWithFormat:@"http://www.meetup.com/members/%@/", self.commentDetail.memberID];
    NSURL *url = [NSURL URLWithString :self.memberURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL : url];
    [self.memberWebView loadRequest : urlRequest];
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
     }
     ];
}

- (IBAction)forwardButton:(UIButton *)sender
{
    [self.memberWebView goForward];
}

- (IBAction)backwardButton:(UIButton *)sender
{
    [self.memberWebView goBack];
}

- (void)webViewDidFinishLoad : (UIWebView *)webView
{
    [self.networkActivityIndicator stopAnimating];
    self.backwardButton.enabled = self.memberWebView.canGoBack;
    self.forwardButton.enabled = self.memberWebView.canGoForward;
}


@end
