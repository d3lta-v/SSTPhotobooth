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

-(void)viewWillAppear:(BOOL)animated
{
    controller = [[UIImagePickerController alloc] init];
    if (state==YES)
    {
        return;
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]&&state!=YES)
    {
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        controller.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        [controller takePicture];
        [controller setDelegate:self];
        [self presentViewController:controller animated:YES completion:nil];
    }
    else if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]&&state!=YES) {
        state=YES;
        controller.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [controller setDelegate:self];
        [self presentViewController:controller animated:YES completion:nil];
    }
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
    
    //Setting the tint colors of left/right bar buttons
    //self.navigationItem.backBarButtonItem.tintColor = [UIColor colorWithRed:112.0/255.0 green:138.0/255.0 blue:144.0/255.0 alpha:0.7];
    //self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:112.0/255.0 green:138.0/255.0 blue:144.0/255.0 alpha:0.7];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],UITextAttributeTextColor,nil];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.navigationItem.backBarButtonItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
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
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if  ([buttonTitle isEqualToString:@"Retake Photo"]) {
        controller = [[UIImagePickerController alloc] init];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            controller.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            controller.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
            [controller takePicture];
            [controller setDelegate:self];
            [self presentViewController:controller animated:YES completion:nil];
        }
        else {
            controller.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            [controller setDelegate:self];
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
    if ([buttonTitle isEqualToString:@"Share to Facebook"]) {
        NSLog(@"facebook");
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        {
            UIGraphicsBeginImageContext(self.backgroundImg.frame.size);
            [self.backgroundImg.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
            [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
            self.backgroundImg.image = UIGraphicsGetImageFromCurrentImageContext();
            self.mainImage.image = nil;
            UIGraphicsEndImageContext();
            SLComposeViewController *fbSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [fbSheet addImage:_backgroundImg.image]; //This is where I try to add my image
            
            [self presentViewController:fbSheet animated:YES completion:nil];
        }
        else if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        {
            [self dismissViewControllerAnimated:NO completion:nil];
            [SVProgressHUD showErrorWithStatus:@"Please link your Facebook account"];
        }
    }
    if ([buttonTitle isEqualToString:@"Share to Twitter"]) {
        NSLog(@"twitter");
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            UIGraphicsBeginImageContext(self.backgroundImg.frame.size);
            [self.backgroundImg.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
            [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
            self.backgroundImg.image = UIGraphicsGetImageFromCurrentImageContext();
            self.mainImage.image = nil;
            UIGraphicsEndImageContext();
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            [tweetSheet addImage:_backgroundImg.image]; //This is where I try to add my image
            
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
        else if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            [self dismissViewControllerAnimated:NO completion:nil];
            [SVProgressHUD showErrorWithStatus:@"Please link your Twitter account"];
        }
    }
    if ([buttonTitle isEqualToString:@"Open Camera Roll"])
    {
        state=YES;
        controller = [[UIImagePickerController alloc]init];
        controller.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing=NO;
        [controller setDelegate:self];
        [self presentViewController:controller animated:YES completion:nil];
    }
    if ([buttonTitle isEqualToString:@"Save"])
    {
        //Making mainImage and backgroundImg the same thing...
        UIGraphicsBeginImageContext(self.backgroundImg.frame.size);
        [self.backgroundImg.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
        [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
        self.backgroundImg.image = UIGraphicsGetImageFromCurrentImageContext();
        self.mainImage.image = nil;
        UIGraphicsEndImageContext();
        
        //Generating the image to be saved
        UIGraphicsBeginImageContextWithOptions(_backgroundImg.bounds.size, NO,0.0);
        [_backgroundImg.image drawInRect:CGRectMake(0, 0, _backgroundImg.frame.size.width, _backgroundImg.frame.size.height)];
        UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(SaveImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    if ([buttonTitle isEqualToString:@"Reset Drawings"])
    {
        [_backgroundImg setImage:[UIImage imageWithData:chosenImage]];
        self.mainImage.image = nil;
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
    
    [_backgroundImg setImage:[UIImage imageWithData:chosenImage]];
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
