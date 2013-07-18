//
//  PhotoboothViewController2.m
//  SST Photobooth
//
//  Created by Pan Ziyue on 4/7/13.
//  Copyright (c) 2013 Pan Ziyue. All rights reserved.
//

#import "PhotoboothViewController2.h"

#import <Social/Social.h>
#import "SVProgressHUD.h"

@interface PhotoboothViewController2 ()
{
    bool state;
    NSData *chosenImage;
    NSInteger actionSheetValue;
}

@end

@implementation PhotoboothViewController2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)save:(id)sender
{
    //Generating the image to be saved
    UIGraphicsBeginImageContextWithOptions(_mainImage.bounds.size, NO,0.0);
    [_mainImage.image drawInRect:CGRectMake(0, 0, _mainImage.frame.size.width, _mainImage.frame.size.height)];
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(SaveImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
}

-(IBAction)reset:(id)sender
{
    [_mainImage setImage:[UIImage imageWithData:chosenImage]];
}

-(IBAction)shareButton:(id)sender
{
    actionSheetValue=0; //Value 0 is for share Actionsheet
    UIActionSheet *as_1 = [[UIActionSheet alloc]initWithTitle:@"Share Menu" delegate:nil cancelButtonTitle:@"Back" destructiveButtonTitle:nil otherButtonTitles:@"Share to Facebook", @"Share to Twitter", nil];
    [as_1 setDelegate:self];
    [as_1 showInView:[UIApplication sharedApplication].keyWindow];
}

-(IBAction)pencilPressed:(id)sender
{
    UIButton * PressedButton = (UIButton*)sender;
    brush = 10.0;
    switch(PressedButton.tag)
    {
        case 0:
            red = 0.0/255.0;
            green = 0.0/255.0;
            blue = 0.0/255.0;
            break;
        case 1:
            red = 105.0/255.0;
            green = 105.0/255.0;
            blue = 105.0/255.0;
            break;
        case 2:
            red = 255.0/255.0;
            green = 0.0/255.0;
            blue = 0.0/255.0;
            break;
        case 3:
            red = 0.0/255.0;
            green = 0.0/255.0;
            blue = 255.0/255.0;
            break;
        case 4:
            red = 102.0/255.0;
            green = 204.0/255.0;
            blue = 0.0/255.0;
            break;
        case 5:
            red = 102.0/255.0;
            green = 255.0/255.0;
            blue = 0.0/255.0;
            break;
        case 6:
            red = 51.0/255.0;
            green = 204.0/255.0;
            blue = 255.0/255.0;
            break;
        case 7:
            red = 160.0/255.0;
            green = 82.0/255.0;
            blue = 45.0/255.0;
            break;
        case 8:
            red = 255.0/255.0;
            green = 102.0/255.0;
            blue = 0.0/255.0;
            break;
        case 9:
            red = 255.0/255.0;
            green = 255.0/255.0;
            blue = 0.0/255.0;
            break;
    }
}

-(IBAction)actionSheet:(id)sender
{
    UIActionSheet *as_1 = [[UIActionSheet alloc]initWithTitle:@"Share Menu" delegate:nil cancelButtonTitle:@"Back" destructiveButtonTitle:@"Reset Drawings" otherButtonTitles:@"Retake Photo", @"Share to Facebook", @"Share to Twitter", @"Open Camera Roll", @"Save", nil];
    [as_1 setDelegate:self];
    [as_1 showInView:[UIApplication sharedApplication].keyWindow];
}

//Main drawing code
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tempDrawImage setAlpha:opacity];
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContext(self.mainImage.frame.size);
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //If it's the share button
    if (actionSheetValue==0) {
        if (buttonIndex == 0)
        {
            NSLog(@"facebook");
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
            {
                SLComposeViewController *fbSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                
                [fbSheet addImage:_mainImage.image]; //This is where I try to add my image
                
                [self presentViewController:fbSheet animated:YES completion:nil];
            }
            else if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
            {
                [self dismissViewControllerAnimated:NO completion:nil];
                [SVProgressHUD showErrorWithStatus:@"Please link your Facebook account"];
            }
        }
        else if (buttonIndex == 1)
        {
            NSLog(@"twitter");
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
                SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                
                [tweetSheet addImage:_mainImage.image]; //This is where I try to add my image
                
                [self presentViewController:tweetSheet animated:YES completion:nil];
            }
            else if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
                [self dismissViewControllerAnimated:NO completion:nil];
                [SVProgressHUD showErrorWithStatus:@"Please link your Twitter account"];
            }
        }
        else
        {
            return;
        }
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        [SVProgressHUD showErrorWithStatus:@"Image could not be saved"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"Image was saved in Camera Roll"];
    }
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    chosenImage = UIImageJPEGRepresentation(image, 1.0);
    
    [_mainImage setImage:[UIImage imageWithData:chosenImage]];
    
    /*//Save the photo
    NSParameterAssert(imageView.image);
    UIImageWriteToSavedPhotosAlbum(imageView.image, nil, nil, nil);*/
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 10.0;
    opacity = 1.0;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    actionSheetValue=0;
}

-(void)viewDidAppear:(BOOL)animated
{
    if (_showEditorOrController==true) {
        controller = [[UIImagePickerController alloc] init];
        if (state==YES)
        {
            return;
        }
        else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]&&state!=YES)
        {
            state=YES;
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            controller.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            controller.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
            [controller takePicture];
            [controller setDelegate:self];
            [self presentViewController:controller animated:YES completion:nil];
        }
        else
        {
            NSLog(@"No camera found");
        }
    }
    else if (_showEditorOrController==false)
    {
        if (state==YES) {
            return;
        }
        else if (state!=NO) {
            state=YES;
            controller.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            [controller setDelegate:self];
            [self presentViewController:controller animated:YES completion:nil];
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
