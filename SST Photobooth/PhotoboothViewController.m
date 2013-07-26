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
    UIImage *image1;
}

@end

@implementation PhotoboothViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    state=NO;
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

-(IBAction)shareAction:(id)sender
{
    [self showImageController];
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


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    image1 = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:^(void){
        if (NSClassFromString(@"UIActivityViewController")) {
            NSArray *dataToShare = @[image1];
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:dataToShare
                                                                                     applicationActivities:nil];
            [self presentViewController:activityVC animated:YES completion:nil];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // Dismiss Image Picker Controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        state=NO;
        
        [self showImageController];
    }
    else if (buttonIndex == 1)
    {
        state=YES;
        
        [self showImageController];
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

-(void)showImageController
{
    controller = [[UIImagePickerController alloc]init];
    controller.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    controller.allowsEditing=NO;
    [controller setDelegate:self];
    [self presentViewController:controller animated:YES completion:nil];
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
