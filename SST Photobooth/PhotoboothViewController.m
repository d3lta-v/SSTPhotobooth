//
//  PhotoboothViewController.m
//  SST Photobooth
//
//  Created by Pan Ziyue on 2/7/13.
//  Copyright (c) 2013 Pan Ziyue. All rights reserved.
//

#import "PhotoboothViewController.h"
#import "SVProgressHUD.h"
#import <Social/Social.h>

@interface PhotoboothViewController ()
{
    bool state;
    UIImage *image1;
}

@end

@implementation PhotoboothViewController

@synthesize web, toolbar;

-(void)viewWillAppear:(BOOL)animated
{
    //Setting title attributes
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:49.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1.0];
    label.text = self.navigationItem.title;
    [label setShadowColor:[UIColor whiteColor]];
    [label setShadowOffset:CGSizeMake(0, -0.5)];
    self.navigationItem.titleView = label;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    /*self.navigationController.navigationBar.barStyle=UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.alpha=1.0;*/
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.alpha = 0.9f;
    self.navigationController.navigationBar.translucent = YES;
    
    toolbar.tintColor=[UIColor whiteColor];
    toolbar.alpha=0.9f;
    toolbar.translucent=YES;
    //[toolbar setBarStyle:UIBarStyleBlackTranslucent];
    //[toolbar setTranslucent:YES];
    
	// Do any additional setup after loading the view, typically from a nib.
    web.delegate=self;
    [SVProgressHUD showWithStatus:@"Loading Facebook Page..."];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.facebook.com/ssts.1technologydrive"]]];
    state=NO;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([error code] != NSURLErrorCancelled)
    {
        [SVProgressHUD dismiss];
        NSLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:@"Please check your Internet connection"];
    }
}


-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    image1 = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (state==NO)
    {
        [self dismissViewControllerAnimated:YES completion:^(void){ //Yes this is how you declare methods!
            //write code here
            
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
            {
                SLComposeViewController *fbSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                
                [fbSheet addImage:image1]; //This is where I try to add my image
                
                [self presentViewController:fbSheet animated:YES completion:nil];
            }
            else if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
            {
                [self dismissViewControllerAnimated:NO completion:nil];
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Sorry"
                                          message:@"You can't post to Facebook right now, make sure your device has an internet connection and you have at least one Facebook account setup"
                                          delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
            }
        }];
    }
    else if (state==YES)
    {
        [self dismissViewControllerAnimated:YES completion:^(void){
            //write code here
            
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
                SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                
                [tweetSheet addImage:image1]; //This is where I try to add my image
                
                [self presentViewController:tweetSheet animated:YES completion:nil];
            }
            else if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
                [self dismissViewControllerAnimated:NO completion:nil];
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Sorry"
                                          message:@"You can't post to Twitter right now, make sure your device has an internet connection and you have at least one Facebook account setup"
                                          delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
            }
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    // Dismiss Image Picker Controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)openActionsheet:(id)sender
{
    UIActionSheet *as_1 = [[UIActionSheet alloc]initWithTitle:@"What do you want to do?" delegate:nil cancelButtonTitle:@"Back" destructiveButtonTitle:@"Take a photo" otherButtonTitles:@"Share photos to Facebook", @"Share photos to Twitter", @"Feedback", nil];
    as_1.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [as_1 setDelegate:self];
    [as_1 showInView:[UIApplication sharedApplication].keyWindow];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //BTW, index 0 is the top button (the red one), same as arrays
    if (buttonIndex == 0)
    {
        //first button, take a photo
        [self performSegueWithIdentifier:@"DefaultToEditor" sender:nil]; //WOHOO IT WORKS LOL
    }
    else if (buttonIndex == 1)
    {
        //second button, share to FB
        state=NO;
        
        controller = [[UIImagePickerController alloc]init];
        controller.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing=NO;
        [controller setDelegate:self];
        [self presentViewController:controller animated:YES completion:nil];
    }
    else if (buttonIndex == 2)
    {
        //third button, share to Twitter
        state=YES;
        
        controller = [[UIImagePickerController alloc]init];
        controller.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing=NO;
        [controller setDelegate:self];
        [self presentViewController:controller animated:YES completion:nil];
    }
    else if (buttonIndex==3)
    {
        //forth button, Feedback
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:random.rrr3@gmail.com"]];
    }
    else
    {
        return;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
