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
#import "PhotoboothViewController2.h"

@interface PhotoboothViewController ()
{
    bool state;
    bool editorOrAdd;
    NSInteger actionSheetNo;
    UIImage *image1;
}

@end

@implementation PhotoboothViewController



- (void)viewDidLoad
{
    [super viewDidLoad];

    /*self.navigationController.navigationBar.barStyle=UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.alpha=1.0;*/
    
    /*self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.alpha = 0.9f;
    self.navigationController.navigationBar.translucent = YES;*/
    
    /*toolbar.tintColor=[UIColor whiteColor];
    toolbar.alpha=0.9f;
    toolbar.translucent=YES;*/
    //[[self navigationController] setNavigationBarHidden:YES animated:NO];
    //[toolbar setBarStyle:UIBarStyleBlackTranslucent];
    //[toolbar setTranslucent:YES];
    
	// Do any additional setup after loading the view, typically from a nib.
    //web.delegate=self;
    //[SVProgressHUD showWithStatus:@"Loading Facebook Page..."];
    //[web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.facebook.com/ssts.1technologydrive"]]];
    state=NO;
    actionSheetNo=0;
}

//This will also get to the editor
-(IBAction)editorPressed:(id)sender
{
    editorOrAdd=FALSE;
    [self performSegueWithIdentifier:@"DefaultToEditor" sender:self];
}

//This will get to the Editor
-(IBAction)newPressed:(id)sender
{
    editorOrAdd=TRUE;
    [self performSegueWithIdentifier:@"DefaultToEditor" sender:self];
}

-(IBAction)sharePressed:(id)sender
{
    UIActionSheet *as_1 = [[UIActionSheet alloc]initWithTitle:@"Share Menu" delegate:nil cancelButtonTitle:@"Back" destructiveButtonTitle:nil otherButtonTitles:@"Share photos to Facebook", @"Share photos to Twitter", nil];
    as_1.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [as_1 setDelegate:self];
    [as_1 showInView:[UIApplication sharedApplication].keyWindow];
    actionSheetNo=0;
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
        [self dismissViewControllerAnimated:YES completion:^(void){
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

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        state=NO;
        
        controller = [[UIImagePickerController alloc]init];
        controller.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing=NO;
        [controller setDelegate:self];
        [self presentViewController:controller animated:YES completion:nil];
    }
    else if (buttonIndex == 1)
    {
        state=YES;
        
        controller = [[UIImagePickerController alloc]init];
        controller.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing=NO;
        [controller setDelegate:self];
        [self presentViewController:controller animated:YES completion:nil];
    }
    else
    {
        return;
    }
    /*else if (buttonIndex==3)
    {
        //forth button, Feedback
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:random.rrr3@gmail.com"]];
    }*/
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"DefaultToEditor"])
    {
        PhotoboothViewController2 *segueController=(PhotoboothViewController2 *)segue.destinationViewController;
        if(editorOrAdd==FALSE) //Means Editor
        {
            segueController.showEditorOrController = false; //Show the Editor
        }
        else if (editorOrAdd==TRUE) //Means Add Photo
        {
            segueController.showEditorOrController = true; //show the Controller
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
