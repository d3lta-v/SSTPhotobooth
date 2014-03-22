//
//  PostToBloggerViewController.m
//  SST Lens
//
//  Created by Pan Ziyue on 17/3/14.
//  Copyright (c) 2014 Pan Ziyue. All rights reserved.
//

#import "PostToBloggerViewController.h"
#import "Mailgun/Mailgun.h"
#import "SVProgressHUD.h"

@interface PostToBloggerViewController ()

@end

@implementation PostToBloggerViewController

@synthesize content, title;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)postToBlogger:(id)sender
{
    if (([title.text length] < 1)||([content.text length] < 1)) {
        [SVProgressHUD showErrorWithStatus:@""];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"Posting..."];
        
        Mailgun *mailgun = [Mailgun clientWithDomain:@"statixind.net" apiKey:@"key-381os16rkzrjwpfyu6eyupuvqwf64dz5"];
        MGMessage *message = [[MGMessage alloc]initWithFrom:@"StatiX AEMD Systems <postmaster@statixind.net>" to:@"random.rrr3.testsystem@blogger.com" subject:title.text body:content.text];
        
        NSData *jpgImage = UIImageJPEGRepresentation([UIImage imageNamed:@"iTunesArtwork"], 1.0);
        [message addImage:[UIImage imageWithData:jpgImage] withName:@"image" type:JPEGFileType];
        
        [mailgun sendMessage:message success:^(NSString *success){
            [SVProgressHUD showSuccessWithStatus:@"Posted!"];
        }failure:^(NSError *error){
            [SVProgressHUD showErrorWithStatus:@"Error posting to Blogger, please check your Internet connection"];
        }];
    }
}

-(IBAction)exit:(id)sender
{
    //[self dismissViewControllerAnimated:YES completion:nil];
}


@end
