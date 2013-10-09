//
//  FilterViewController.h
//  SST Lens
//
//  Created by Pan Ziyue on 7/10/13.
//  Copyright (c) 2013 Pan Ziyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

@interface FilterViewController : UIViewController
{
    UIImage *receivedImage;
    IBOutlet UIImageView *mainImageView;
    IBOutlet UISlider *filterSlider;
    
    NSString *filterType;
}

@property (strong,nonatomic) IBOutlet UIImageView *mainImageView;
@property (strong,nonatomic) UIImage *receivedImage;
@property (strong,nonatomic) UISlider *filterSlider;

@property (strong,nonatomic) NSString *filterType;
@property (strong,nonatomic) GPUImagePicture *sourceImage;

-(IBAction)returnWithoutFilter:(id)sender;
-(IBAction)returnWithFilter:(id)sender;

- (IBAction) sliderValueChanged:(id)sender;

@end
