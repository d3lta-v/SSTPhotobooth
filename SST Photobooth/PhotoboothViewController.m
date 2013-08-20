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
    bool editorOrAdd;
    bool socialOrNot; //Social is 1, image is 2
    UIImage *image1;
}

@end

@implementation PhotoboothViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if (! [defaults boolForKey:@"notFirstRun"]) {
        
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self performSegueWithIdentifier:@"DefaultToHelp" sender:self];
        });
        [defaults setBool:YES forKey:@"notFirstRun"];
    }
    else
    {
        return;
    }
}

//This will also get to the editor
-(IBAction)editorPressed:(id)sender
{
    editorOrAdd=FALSE;
    socialOrNot=FALSE;
    controller = [[UIImagePickerController alloc]init];
    controller.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    controller.allowsEditing=NO;
    [controller setDelegate:self];
    [self presentViewController:controller animated:YES completion:nil];
}

//This will get to the Editor
-(IBAction)newPressed:(id)sender
{
    editorOrAdd=TRUE;
    
    socialOrNot=FALSE;
    
    controller=[[UIImagePickerController alloc]init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIDevice *currentDevice = [UIDevice currentDevice];
        while ([currentDevice isGeneratingDeviceOrientationNotifications])
            [currentDevice endGeneratingDeviceOrientationNotifications];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        [controller takePicture];
        [controller setDelegate:self];
        [self presentViewController:controller animated:YES completion:nil];
        
        while ([currentDevice isGeneratingDeviceOrientationNotifications])
            [currentDevice endGeneratingDeviceOrientationNotifications];
    }
    else
    {
        NSLog(@"No camera found");
    }
}

-(IBAction)shareAction:(id)sender
{
    socialOrNot=TRUE;
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (socialOrNot) {
        [self dismissViewControllerAnimated:YES completion:nil];
        image1 = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self dismissViewControllerAnimated:YES completion:^(void){
            if (NSClassFromString(@"UIActivityViewController")) {
                NSArray *dataToShare = @[image1];
                UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
                activityVC.excludedActivityTypes=@[UIActivityTypeSaveToCameraRoll];
                [self presentViewController:activityVC animated:YES completion:nil];
            }
        }];
    }
    else
    {
        image1 = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self dismissViewControllerAnimated:YES completion:^(void){
            [self performSegueWithIdentifier:@"DefaultToEditor" sender:self];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // Dismiss Image Picker Controller
    [self dismissViewControllerAnimated:YES completion:nil];
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
            segueController.imageChoosed=image1;
        }
        else if (editorOrAdd==TRUE) //Means Add Photo
        {
            segueController.imageChoosed=image1;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
