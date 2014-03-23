//
//  BloggerShare.m
//  SST Lens
//
//  Created by Pan Ziyue on 19/3/14.
//  Copyright (c) 2014 Pan Ziyue. All rights reserved.
//

#import "BloggerShare.h"
#import "Mailgun.h"
#import "MGMessage.h"
#import "SVProgressHUD.h"
#import "REComposeViewController.h"

@implementation BloggerShare
{
    bool acceptOrConfigure; //accept configuration request=0, configure=1
    UIImage *_image;
}

/*- (NSString *)activityType
{
    return @"yourappname.Review.App";
}

- (NSString *)activityTitle
{
    return @"Review App";
}

- (UIImage *)activityImage
{
    // Note: These images need to have a transparent background and I recommend these sizes:
    // iPadShare@2x should be 126 px, iPadShare should be 53 px, iPhoneShare@2x should be 100
    // px, and iPhoneShare should be 50 px. I found these sizes to work for what I was making.
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return [UIImage imageNamed:@"BloggeriPad.png"];
    }
    else
    {
        return [UIImage imageNamed:@"Blogger.png"];
    }
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    NSLog(@"%s", __FUNCTION__);
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    NSLog(@"%s",__FUNCTION__);
}

- (UIViewController *)activityViewController
{
    PostToBloggerViewController *controller = [[PostToBloggerViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    controller.activity=self;
    return navController;
}

- (void)performActivity
{
    // This is where you can do anything you want, and is the whole reason for creating a custom
    // UIActivity
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=yourappid"]];
    [self activityDidFinish:YES];
}

@end*/

- (NSString *)activityType
{
    //return NSStringFromClass([self class]);
    return @"sg.edu.sst.SSTLens";
}

- (NSString *)activityTitle
{
    return @"Blogger";
}

- (UIImage *)activityImage
{
    // Note: These images need to have a transparent background and I recommend these sizes:
    // iPadShare@2x should be 126 px, iPadShare should be 53 px, iPhoneShare@2x should be 100
    // px, and iPhoneShare should be 50 px. I found these sizes to work for what I was making.
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return [UIImage imageNamed:@"BloggeriPad"];
    }
    else
    {
        return [UIImage imageNamed:@"Blogger"];
    }
}

// Check for activity items, just in case
- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    for (id obj in activityItems) {
        if ([obj isKindOfClass:[UIImage class]]) {
            return YES;
        }
    }
    return NO;
}

//Set the images as the activity item
- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:true forKey:@"bloggerOrNot"];
    for (id activityItem in activityItems) {
		if ([activityItem isKindOfClass:[UIImage class]]) {
			_image = activityItem;
		}
	}
    [self activityDidFinish:YES];
}
/*
- (UIViewController *)activityViewController
{
    return nil;
}
*/
- (void)performActivity
{
    // This is where you can do anything you want, and is the whole reason for creating a custom
    // UIActivity
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSString *object = [pref stringForKey:@"bloggerEmail"];
    
    if (object!=nil||[object isEqual:@""]) {
        REComposeViewController *composeViewController = [[REComposeViewController alloc] init];
        composeViewController.hasAttachment = YES;
        composeViewController.attachmentImage = [self imageByScalingAndCroppingForSize:CGSizeMake(300, 300) withImage:_image];
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blogger-logo"]];
        titleImageView.frame = CGRectMake(0, 0, 110, 30);
        composeViewController.navigationItem.titleView = titleImageView;
        composeViewController.placeholderText = @"Title Here";
        
        // UIApperance setup
        //
        composeViewController.navigationBar.tintColor = [UIColor colorWithRed:27/255.0 green:108/255.0 blue:181/255.0 alpha:1.0];
        
        // Alternative use with REComposeViewControllerCompletionHandler
        //
        composeViewController.completionHandler = ^(REComposeViewController *composeViewController, REComposeResult result) {
            [composeViewController dismissViewControllerAnimated:YES completion:nil];
            
            if (result == REComposeResultPosted) {
                [SVProgressHUD showWithStatus:@"Posting to Blogger..."];
                Mailgun *mailgun = [Mailgun clientWithDomain:@"statixind.net" apiKey:@"key-381os16rkzrjwpfyu6eyupuvqwf64dz5"];
                MGMessage *message = [[MGMessage alloc]initWithFrom:@"StatiX AEMD Systems <postmaster@statixind.net>" to:[pref stringForKey:@"bloggerEmail"] subject:composeViewController.text body:@"\n"];
                
                NSData *jpgImage = UIImageJPEGRepresentation(_image, 1.0);
                [message addImage:[UIImage imageWithData:jpgImage] withName:@"image" type:JPEGFileType];
                
                [mailgun sendMessage:message success:^(NSString *success){
                    [SVProgressHUD showSuccessWithStatus:@"Posted!"];
                }failure:^(NSError *error){
                    [SVProgressHUD showErrorWithStatus:@"Error posting to Blogger, please check your Internet connection"];
                    NSLog(@"Error: %@", error);
                }];

            }
        };
        //[composeViewController presentFromRootViewController];
        [composeViewController presentFromViewController:[self topViewController]];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Blogger Account Configured" message:@"Do you want to configure a Blogger Account now?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        acceptOrConfigure=false;
        [alert show];
    }
    
    [self activityDidFinish:YES];
}

- (UIViewController *)topViewController{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}

-(void)activityDidFinish:(BOOL)completed
{
    [SVProgressHUD dismiss];
}

//Autocrop image to fit screen size
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withImage:(UIImage*)imageInput
{
    UIImage *sourceImage = imageInput;
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

#pragma mark alertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d", (int)buttonIndex);
    if (acceptOrConfigure) {
        // configure dialog
        if (([[alertView textFieldAtIndex:0].text isEqualToString:@""]||![self NSStringIsValidEmail:[alertView textFieldAtIndex:0].text])&&buttonIndex==1) {
            //error with input, abort
            UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Please enter a valid Blogger email address" message:nil delegate:nil cancelButtonTitle:@"Exit" otherButtonTitles:nil, nil];
            [error show];
        }
        else if (buttonIndex==1)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[alertView textFieldAtIndex:0].text forKey:@"bloggerEmail"];
            [SVProgressHUD showSuccessWithStatus:@"Successfully configured Blogger email!"];
        }
        else if (buttonIndex==2)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://support.google.com/blogger/answer/41452?hl=en"]];
        }
        else
        {
            return;
        }
    }
    else {
        if (buttonIndex==0) {
            return;
        }
        else
        {
            // accept dialog
            UIAlertView *config = [[UIAlertView alloc] initWithTitle:@"Configure Blogger Email" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Accept", @"Help", nil];
            config.alertViewStyle=UIAlertViewStylePlainTextInput;
            acceptOrConfigure=true;
            [config show];
        }
    }
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

@end
