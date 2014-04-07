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
#import "BloggerShare/BloggerShare.h"
#import "UIImage-Extensions.h"

#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

@interface PhotoboothViewController ()
{
    bool editorOrAdd;
    bool socialOrNot; //Social is 1, image is 2
    bool bloggerShouldActivate;
    bool potraitOrLandscape; //Potrait==false Landscape==true
    UIImage *image1;
}

@end

@implementation PhotoboothViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"notFirstRun"]) {
        bloggerShouldActivate=false;
        double delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self performSegueWithIdentifier:@"DefaultToHelp" sender:self];
        });
        [defaults setBool:YES forKey:@"notFirstRun"];
    }
    else
        return;
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
        controller.allowsEditing=NO;
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

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

//Autocrop image to fit screen size
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withImage:(UIImage*)imageInput
{
    UIImage *sourceImage=imageInput;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) //If user is using an iPad
    {
        if (editorOrAdd==TRUE) {
            if (imageInput.imageOrientation != UIImageOrientationLeft || imageInput.imageOrientation != UIImageOrientationRight) {
                sourceImage = [imageInput imageRotatedByDegrees:90];
                potraitOrLandscape=true;
            }
            else {
                sourceImage=imageInput;
                potraitOrLandscape=false;
            }
        }
        else
        {
            if (imageInput.imageOrientation != UIImageOrientationDown || imageInput.imageOrientation != UIImageOrientationUp) {
                sourceImage = [imageInput imageRotatedByDegrees:90];
                potraitOrLandscape=true;
            }
            else {
                sourceImage=imageInput;
                potraitOrLandscape=false;
            }
        }
    }
    else // else if the user uses a phone
    {
        if (imageInput.imageOrientation != UIImageOrientationUp || imageInput.imageOrientation != UIImageOrientationDown) {
            sourceImage = [imageInput imageRotatedByDegrees:90];
            potraitOrLandscape=true;
        }
        else {
            sourceImage=imageInput;
            potraitOrLandscape=false;
        }
    }
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
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
    if (socialOrNot) //Checking if it is initiating from the Social function or the Add Photo function
    {
        bloggerShouldActivate=true;
        image1 = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self dismissViewControllerAnimated:YES completion:^(void) //Dismiss the VC with an action on dismiss
        {
            if (NSClassFromString(@"UIActivityViewController"))
            {
                BloggerShare *activity = [[BloggerShare alloc] init];
                NSArray *dataToShare = @[image1];
                UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:@[activity]];
                activityVC.excludedActivityTypes=@[UIActivityTypeSaveToCameraRoll];
                [self presentViewController:activityVC animated:YES completion:nil];
            }
        }];
    }
    else //If the user wasn't using the share function
    {
         //Here are some methods for detecting image orientation, developer only
         
        /*if (((UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage]).imageOrientation==UIImageOrientationLeft)
            NSLog(@"image left");
        else if (((UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage]).imageOrientation==UIImageOrientationRight)
            NSLog(@"image right");
        else if (((UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage]).imageOrientation==UIImageOrientationUp)
            NSLog(@"image up");
        else if (((UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage]).imageOrientation==UIImageOrientationDown)
            NSLog(@"image down");
        else
            NSLog(@"unknown orient");*/
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        {
            CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
            
            if (iOSDeviceScreenSize.height == 480)
            {
                image1 = [self imageByScalingAndCroppingForSize:CGSizeMake(640.0, 960.0) withImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
            }
            
            if (iOSDeviceScreenSize.height == 568)
            {
                image1 = [self imageByScalingAndCroppingForSize:CGSizeMake(640.0, 1136.0) withImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
            }
            
        }
        else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            // Detecting if device is retina to properly crop the image to screen size
            if (IS_RETINA) {
                image1 = [self imageByScalingAndCroppingForSize:CGSizeMake(1536.0, 2048.0) withImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
            }
            else {
                image1 = [self imageByScalingAndCroppingForSize:CGSizeMake(768.0, 1024.0) withImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
            }
        }
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

-(void)showImageController //Just a method to show the Image Ctrl pointed to the photo library
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
            segueController.showEditorOrController=false;
            segueController.imageChoosed=image1;
            segueController.potraitOrLandscape=potraitOrLandscape;
        }
        else if (editorOrAdd==TRUE) //Means Add Photo
        {
            segueController.showEditorOrController=true;
            segueController.imageChoosed=image1;
            segueController.potraitOrLandscape=potraitOrLandscape;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
