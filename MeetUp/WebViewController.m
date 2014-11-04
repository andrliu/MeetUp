//
//  WebViewController.m
//  MeetUp
//
//  Created by Andrew Liu on 11/3/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *networkActivityIndicator;
@property (weak, nonatomic) IBOutlet UIWebView *eventPageWebView;
@property (weak, nonatomic) IBOutlet UIButton *backwardButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString :self.eventWebDetail.url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL : url];
    [self.eventPageWebView loadRequest : urlRequest];
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

- (IBAction)backwardButton:(UIButton *)sender
{
    [self.eventPageWebView goBack];
}

- (IBAction)forwardButton:(UIButton *)sender
{
    [self.eventPageWebView goForward];
}

- (void)webViewDidFinishLoad : (UIWebView *)webView
{
    [self.networkActivityIndicator stopAnimating];
    self.backwardButton.enabled = self.eventPageWebView.canGoBack;
    self.forwardButton.enabled = self.eventPageWebView.canGoForward;
}

@end
