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
#import "GPUImage.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoboothViewController2 ()
{
    bool state;
    bool hudOpened;
    bool filterApplied;
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

-(IBAction)filterSelector:(id)sender
{
    UIActionSheet *filter=[[UIActionSheet alloc]initWithTitle:@"Filter Selector (Some effects may not work on certain images)" delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:nil otherButtonTitles:@"Sepia", @"Black & White", @"Invert", @"Pencil Sketch", @"Emboss", @"Vintage", @"Vignett", @"Pixelate", @"Polka Dot", nil];
    filter.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [filter setDelegate:self];
    [filter showInView:[UIApplication sharedApplication].keyWindow];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    GPUImageFilter *imageFilter;
    switch (buttonIndex) {
        case 0:
            imageFilter=[[GPUImageSepiaFilter alloc]init];
            filterApplied=true;
            break;
        
        case 1:
            imageFilter=[[GPUImageGrayscaleFilter alloc]init];
            filterApplied=true;
            break;
            
        case 2:
            imageFilter=[[GPUImageColorInvertFilter alloc]init];
            filterApplied=true;
            break;
        
        case 3:
            imageFilter=[[GPUImageSketchFilter alloc]init];
            filterApplied=true;
            break;
            
        case 4:
            imageFilter=[[GPUImageEmbossFilter alloc]init];
            filterApplied=true;
            break;

        case 5:
            imageFilter=[[GPUImageMonochromeFilter alloc]init];
            filterApplied=true;
            break;
            
        case 6:
            imageFilter=[[GPUImageVignetteFilter alloc]init];
            filterApplied=true;
            break;
            
        case 7:
            imageFilter=[[GPUImagePixellateFilter alloc]init];
            filterApplied=true;
            break;
            
        case 8:
            imageFilter=[[GPUImagePolkaDotFilter alloc]init];
            filterApplied=true;
            break;
            
        default:
            filterApplied=false;
            break;
    }
    if (filterApplied)
    {
        [SVProgressHUD showWithStatus:@"Applying filter, this may take a while..."];
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            UIImage *filteredImage=[imageFilter imageByFilteringImage:_mainImage.image];
            [_mainImage setImage:filteredImage];
            [SVProgressHUD showSuccessWithStatus:@"Filter applied!"];
        });
    }
    else
        return;
}


-(IBAction)save:(id)sender
{
    //Generating the image to be saved
    [SVProgressHUD showWithStatus:@"Saving..."];
    UIGraphicsBeginImageContextWithOptions(_mainImage.bounds.size, NO,0.0);
    [_mainImage.image drawInRect:CGRectMake(0, 0, _mainImage.frame.size.width, _mainImage.frame.size.height)];
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //Writing to Photo Album
    UIImageWriteToSavedPhotosAlbum(SaveImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
    if ([ALAssetsLibrary authorizationStatus]!=ALAuthorizationStatusAuthorized)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Permission Required:" message:@"This app requires access to your Photo Library, please enable it in your Settings/Privacy/Photos." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(IBAction)reset:(id)sender
{
    //[SVProgressHUD showWithStatus:@"Clearing edits..."];
    [_mainImage setImage:[UIImage imageWithData:chosenImage]];
    [segment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [SVProgressHUD showSuccessWithStatus:@"Edits Cleared!"];
}

-(IBAction)shareActivityButton:(id)sender
{
    if (NSClassFromString(@"UIActivityViewController")) {
        if (CGSizeEqualToSize(_mainImage.image.size, CGSizeZero)) {
            [SVProgressHUD showErrorWithStatus:@"No image found in canvas!"];
            return;
        }
        else
        {
            NSArray *dataToShare = @[_mainImage.image];
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
            activityVC.excludedActivityTypes=@[UIActivityTypeSaveToCameraRoll];
            [self presentViewController:activityVC animated:YES completion:nil];
        }
    }
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

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    chosenImage = UIImageJPEGRepresentation(image, 1.0);
    
    //[_mainImage setImage:];
    _mainImage.image=[UIImage imageWithData:chosenImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (_showEditorOrController)
    {
        //Autosave
        UIImageWriteToSavedPhotosAlbum(image, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    //Is there an error?
    if (error != NULL)
    {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"Image could not be saved"];
    } else {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"Image was saved in Camera Roll"];
    }
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

-(void)viewWillAppear:(BOOL)animated
{
    if (!hudOpened) {
        [SVProgressHUD showWithStatus:@"Loading Image Selector..."];
        hudOpened=true;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    if (_showEditorOrController) {
        controller = [[UIImagePickerController alloc] init];
        if (state==YES)
        {
            return;
        }
        else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]&&state!=YES)
        {
            UIDevice *currentDevice = [UIDevice currentDevice];
            while ([currentDevice isGeneratingDeviceOrientationNotifications])
                [currentDevice endGeneratingDeviceOrientationNotifications];
            state=YES;
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
    else
    {
        controller=[[UIImagePickerController alloc]init];
        if (state==YES) {
            return;
        }
        else if (state==NO)
        {
            state=YES;
            controller.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            [controller setDelegate:self];
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
    hudOpened=true;
}

-(void)viewDidDisappear:(BOOL)animated
{
    hudOpened=false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
