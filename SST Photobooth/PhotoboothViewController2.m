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
    BOOL state; //This is to check if view is launched from social media
    BOOL filterApplied; //Prevent infinite loop of filter applying
    NSInteger actionSheetNumber;
    NSData *chosenImage;
    
    BOOL saved;
}

@end

@implementation PhotoboothViewController2

@synthesize imageChoosed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(IBAction)filterSelector:(id)sender
{
    UIActionSheet *filter=[[UIActionSheet alloc]initWithTitle:@"Filter Selector (Some effects may not work on certain images)" delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:nil otherButtonTitles:@"Sepia", @"Black & White", @"Invert", @"Emboss", @"Pencil Sketch", @"Vintage", @"Vintage 2", @"Vintage 3", @"Oil Painting", @"Cartoon", @"Vignette", @"Pixelate", @"Center Pixelate", @"Polka Dot", @"Dot Matrix", nil];
    [filter setDelegate:self];
    actionSheetNumber=0;
    [filter showInView:[UIApplication sharedApplication].keyWindow];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheetNumber==0) { //This is for the filters
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];

        if ([buttonTitle isEqualToString:@"Sepia"]) {
            [SVProgressHUD showWithStatus:@"Applying filter..."];
            GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init];
            
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                _mainImage.image=[sepiaFilter imageByFilteringImage:_mainImage.image];
                [SVProgressHUD showSuccessWithStatus:@"Filter applied!"];
            });
            saved=FALSE;
        }
        else if ([buttonTitle isEqualToString:@"Black & White"]) {
            [SVProgressHUD showWithStatus:@"Applying filter..."];
            GPUImageGrayscaleFilter *greyScale = [[GPUImageGrayscaleFilter alloc] init];
            
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                _mainImage.image=[greyScale imageByFilteringImage:_mainImage.image];
                [SVProgressHUD showSuccessWithStatus:@"Filter applied!"];
            });
        }
        else if ([buttonTitle isEqualToString:@"Invert"]) {
            [SVProgressHUD showWithStatus:@"Applying filter..."];
            GPUImageColorInvertFilter *filter = [[GPUImageColorInvertFilter alloc] init];
            
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                _mainImage.image=[filter imageByFilteringImage:_mainImage.image];
                [SVProgressHUD showSuccessWithStatus:@"Filter applied!"];
            });
            saved=FALSE;
        }
        else if ([buttonTitle isEqualToString:@"Emboss"]) {
            [SVProgressHUD showWithStatus:@"Applying filter..."];
            GPUImageEmbossFilter *filter = [[GPUImageEmbossFilter alloc] init];
            
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                _mainImage.image=[filter imageByFilteringImage:_mainImage.image];
                [SVProgressHUD showSuccessWithStatus:@"Filter applied!"];
            });
            saved=FALSE;
        }
        else if ([buttonTitle isEqualToString:@"Vintage"]) {
            [SVProgressHUD showWithStatus:@"Applying filter..."];
            GPUImageAmatorkaFilter *filter = [[GPUImageAmatorkaFilter alloc] init];
            
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                _mainImage.image=[filter imageByFilteringImage:_mainImage.image];
                [SVProgressHUD showSuccessWithStatus:@"Filter applied!"];
            });
            saved=FALSE;
        }
        else if ([buttonTitle isEqualToString:@"Vintage 2"]) {
            [SVProgressHUD showWithStatus:@"Applying filter..."];
            GPUImageMissEtikateFilter *filter = [[GPUImageMissEtikateFilter alloc] init];
            
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                _mainImage.image=[filter imageByFilteringImage:_mainImage.image];
                [SVProgressHUD showSuccessWithStatus:@"Filter applied!"];
            });
            saved=FALSE;
        }
        else if ([buttonTitle isEqualToString:@"Vignette"]) {
            [SVProgressHUD showWithStatus:@"Applying filter..."];
            GPUImageVignetteFilter *filter = [[GPUImageVignetteFilter alloc] init];
            
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                _mainImage.image=[filter imageByFilteringImage:_mainImage.image];
                [SVProgressHUD showSuccessWithStatus:@"Filter applied!"];
            });
            saved=FALSE;
        }
        else if ([buttonTitle isEqualToString:@"Pixelate"]) {
            [SVProgressHUD showWithStatus:@"Applying filter..."];
            GPUImagePixellateFilter *filter = [[GPUImagePixellateFilter alloc] init];
            
            [filter setFractionalWidthOfAPixel:0.02];
            
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                _mainImage.image=[filter imageByFilteringImage:_mainImage.image];
                [SVProgressHUD showSuccessWithStatus:@"Filter applied!"];
            });
            saved=FALSE;
        }
        else if ([buttonTitle isEqualToString:@"Center Pixelate"]) {
            [SVProgressHUD showWithStatus:@"Applying filter..."];
            GPUImagePolarPixellateFilter *filter = [[GPUImagePolarPixellateFilter alloc] init];
            
            [filter setPixelSize:CGSizeMake(0.03, 0.03)];
            
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                _mainImage.image=[filter imageByFilteringImage:_mainImage.image];
                [SVProgressHUD showSuccessWithStatus:@"Filter applied!"];
            });
            saved=FALSE;
        }
        else if ([buttonTitle isEqualToString:@"Polka Dot"]) {
            [SVProgressHUD showWithStatus:@"Applying filter..."];
            GPUImagePolkaDotFilter *filter = [[GPUImagePolkaDotFilter alloc] init];
            
            [filter setFractionalWidthOfAPixel:0.02];
            
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                _mainImage.image=[filter imageByFilteringImage:_mainImage.image];
                [SVProgressHUD showSuccessWithStatus:@"Filter applied!"];
            });
            saved=FALSE;
        }
        else if ([buttonTitle isEqualToString:@"Cartoon"]) {
            [SVProgressHUD showWithStatus:@"Applying filter..."];
            GPUImageSmoothToonFilter *filter = [[GPUImageSmoothToonFilter alloc] init];
            
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                _mainImage.image=[filter imageByFilteringImage:_mainImage.image];
                [SVProgressHUD showSuccessWithStatus:@"Filter applied!"];
            });
            saved=FALSE;
        }
        else if ([buttonTitle isEqualToString:@"Oil Painting"]) {
            [SVProgressHUD showWithStatus:@"Applying filter..."];
            GPUImageKuwaharaRadius3Filter *filter = [[GPUImageKuwaharaRadius3Filter alloc] init];
            
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                _mainImage.image=[filter imageByFilteringImage:_mainImage.image];
                [SVProgressHUD showSuccessWithStatus:@"Filter applied!"];
            });
            saved=FALSE;
        }
        else if ([buttonTitle isEqualToString:@"Dot Matrix"]) {
            [SVProgressHUD showWithStatus:@"Applying filter..."];
            GPUImageHalftoneFilter *filter = [[GPUImageHalftoneFilter alloc] init];
            [filter setFractionalWidthOfAPixel:0.007];
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                _mainImage.image=[filter imageByFilteringImage:_mainImage.image];
                [SVProgressHUD showSuccessWithStatus:@"Filter applied!"];
            });
            saved=FALSE;
        }
        else if ([buttonTitle isEqualToString:@"Vintage 3"]) {
            [SVProgressHUD showWithStatus:@"Applying filter..."];
            GPUImageSoftEleganceFilter *filter = [[GPUImageSoftEleganceFilter alloc] init];
            
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                _mainImage.image=[filter imageByFilteringImage:_mainImage.image];
                [SVProgressHUD showSuccessWithStatus:@"Filter applied!"];
            });
            saved=FALSE;
        }
        else if ([buttonTitle isEqualToString:@"Pencil Sketch"]) {
            [SVProgressHUD showWithStatus:@"Applying filter..."];
            GPUImageSketchFilter *filter = [[GPUImageSketchFilter alloc] init];
            
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                _mainImage.image=[filter imageByFilteringImage:_mainImage.image];
                [SVProgressHUD showSuccessWithStatus:@"Filter applied!"];
            });
            saved=FALSE;
        }
    }
    else if (actionSheetNumber==1) //This is for the watermarks
    {
        switch (buttonIndex) {
            case 0:
                [self clearWatermark];
                _watermark.image=[self generateWatermarkForImage:_watermark.image :[UIImage imageNamed:@"Design-Cluster.png"]];
                saved=FALSE;
                break;
                
            case 1:
                [self clearWatermark];
                _watermark.image=[self generateWatermarkForImage:_watermark.image :[UIImage imageNamed:@"SSTFullLogo.png"]];
                saved=FALSE;
                break;
            case 2:
                [self clearWatermark];
                _watermark.image=[self generateWatermarkForImage:_watermark.image :[UIImage imageNamed:@"SSTVertLogo.png"]];
                saved=FALSE;
                break;
            case 3:
                [self clearWatermark];
                saved=FALSE;
                break;
            default:
                break;
        }
    }
    else if (actionSheetNumber==2)
    {
        switch (buttonIndex) {
            case 0:
                [_mainImage setImage:imageChoosed];
                [self clearWatermark];
                [SVProgressHUD showSuccessWithStatus:@"Edits Cleared!"];
                saved=TRUE;
                break;
                
            default:
                break;
        }
    }
}

//This function is to get rid of the watermark (set the image to a transparent image that fits the screen)
-(void)clearWatermark
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f) {
            _watermark.image=[UIImage imageNamed:@"iPhone5Transparent.png"];
        } else {
            _watermark.image=[UIImage imageNamed:@"TransparentiPhone.png"];
        }
    } else {
        _watermark.image=[UIImage imageNamed:@"TransparentiPhone.png"];
    }
}

-(IBAction)save:(id)sender
{
    //Generating the image to be saved
    [SVProgressHUD showWithStatus:@"Saving..."];
    UIGraphicsBeginImageContextWithOptions(_mainImage.bounds.size, NO,0.0);
    [_mainImage.image drawInRect:CGRectMake(0, 0, _mainImage.frame.size.width, _mainImage.frame.size.height)];
    [_watermark.image drawInRect:CGRectMake(0, 0, _watermark.frame.size.width, _watermark.frame.size.height)];
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //Writing to Photo Album
    UIImageWriteToSavedPhotosAlbum(SaveImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
    if ([ALAssetsLibrary authorizationStatus]!=ALAuthorizationStatusAuthorized)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Permission Required:" message:@"This app requires access to your Photo Library, please enable it in your Settings/Privacy/Photos" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(IBAction)reset:(id)sender
{
    UIActionSheet *resetActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:@"Clear all edits" otherButtonTitles:nil, nil];
    [resetActionSheet setDelegate:self];
    actionSheetNumber=2;
    [resetActionSheet showInView:[UIApplication sharedApplication].keyWindow];
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
            //Combining the watermark layer and the main image layer
            UIGraphicsBeginImageContextWithOptions(_mainImage.bounds.size, NO,0.0);
            [_mainImage.image drawInRect:CGRectMake(0, 0, _mainImage.frame.size.width, _mainImage.frame.size.height)];
            [_watermark.image drawInRect:CGRectMake(0, 0, _watermark.frame.size.width, _watermark.frame.size.height)];
            UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            NSArray *dataToShare = @[SaveImage];
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
    saved=FALSE;
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

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    //Is there an error?
    if (error != NULL)
    {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"Image could not be saved"];
        if ([ALAssetsLibrary authorizationStatus]==ALAuthorizationStatusDenied)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Permission Required:" message:@"This app requires access to your Photo Library, please enable it in your Settings/Privacy/Photos." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
            [alert show];
        }
    } else {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"Image was saved in Camera Roll"];
        saved=TRUE;
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
    
    if (_showEditorOrController) {
        UIImageWriteToSavedPhotosAlbum(_mainImage.image, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    saved=TRUE;
}

-(void)viewWillAppear:(BOOL)animated
{
    _mainImage.image=imageChoosed;
}

//This is to make a watermarked image
-(UIImage *) generateWatermarkForImage:(UIImage *)mainImg :(UIImage *)transparentImg{
    UIImage *backgroundImage = mainImg;
    UIImage *watermarkImage = transparentImg;
    
    UIGraphicsBeginImageContext(backgroundImage.size);
    [backgroundImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
    [watermarkImage drawInRect:CGRectMake(backgroundImage.size.width - watermarkImage.size.width, backgroundImage.size.height - watermarkImage.size.height, watermarkImage.size.width, watermarkImage.size.height)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return result;
}

-(IBAction)watermarkSelector:(id)sender
{
    UIActionSheet *watermarkSelector=[[UIActionSheet alloc]initWithTitle:@"Watermark Type Selector" delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:nil otherButtonTitles:@"SST Hexagon", @"Full SST Logo (Horizontal)", @"Full SST Logo (Vertical)", @"None", nil];
    [watermarkSelector setDelegate:self];
    actionSheetNumber=1;
    [watermarkSelector showInView:[UIApplication sharedApplication].keyWindow];
}

-(IBAction)goBack:(id)sender
{
    if (!saved) {
        UIAlertView *backAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"All unsaved changes will be lost!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
        [backAlert setDelegate:self];
        [backAlert show];
    }
    else
        [self performSegueWithIdentifier:@"goBack" sender:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            [self performSegueWithIdentifier:@"goBack" sender:self];
            break;
            
        default:
            break;
    }
}

-(void)willPresentAlertView:(UIAlertView *)alertView{
    UILabel *theBody = [alertView valueForKey:@"_bodyTextLabel"];
    [theBody setTextColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
