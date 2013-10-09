//
//  FilterViewController.m
//  SST Lens
//
//  Created by Pan Ziyue on 7/10/13.
//  Copyright (c) 2013 Pan Ziyue. All rights reserved.
//

#import "FilterViewController.h"
#import "GPUImage.h"
#import "SVProgressHUD.h"

#import "PhotoboothViewController2.h"

@interface FilterViewController (){
    CGFloat senderValue;
}

@end

@implementation FilterViewController

@synthesize mainImageView, receivedImage, filterSlider, filterType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [mainImageView setImage:receivedImage];
    
    senderValue=0.0;
    if ([filterType isEqualToString:@"Sepia"]) {
        filterSlider.maximumValue=1.0;
    }
    else if ([filterType isEqualToString:@"Emboss"]) {
        filterSlider.maximumValue=4.0;
    }
    else if ([filterType isEqualToString:@"Pixellate"]) {
        filterSlider.maximumValue=0.1;
    }
    else if ([filterType isEqualToString:@"Center Pixelate"]) {
        filterSlider.maximumValue=0.07;
    }
    else if ([filterType isEqualToString:@"Polka Dot"]) {
        filterSlider.maximumValue=0.08;
    }
    else if ([filterType isEqualToString:@"Cartoon"]) {
        filterSlider.maximumValue=0.002;
        //filterSlider.maximumValue=0.5;
    }
    else if ([filterType isEqualToString:@"Oil Painting"]) {
        filterSlider.maximumValue=4.0;
    }
    else if ([filterType isEqualToString:@"Dot Matrix"]) {
        filterSlider.maximumValue=0.05;
    }
    else if ([filterType isEqualToString:@"Pencil Sketch"]) {
        //filterSlider.maximumValue=0.01;
        filterSlider.maximumValue=1;
    }
    filterSlider.value=0.0f;
}

-(IBAction)returnWithFilter:(id)sender
{
    UIViewController* presentingVC = self.presentingViewController;
    [SVProgressHUD showWithStatus:@"Applying filter..."];
    [presentingVC dismissViewControllerAnimated:YES completion:^(void){
        [presentingVC performSelector:@selector(updateImageWithFilter:) withObject:mainImageView.image];
    }];
}

-(IBAction)returnWithoutFilter:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction) sliderValueChanged:(UISlider *)sender {
    senderValue = [sender value];

    if ([filterType isEqualToString:@"Sepia"]) {
        [self sepiaFilter];
    }
    else if ([filterType isEqualToString:@"Emboss"]) {
        [self embossFilter];
    }
    else if ([filterType isEqualToString:@"Pixellate"]) {
        [self pixellateFilter];
    }
    else if ([filterType isEqualToString:@"Center Pixelate"]) {
        [self polarPixellate];
    }
    else if ([filterType isEqualToString:@"Polka Dot"]) {
        [self polkaDot];
    }
    else if ([filterType isEqualToString:@"Cartoon"]) {
        [self toonFilter];
    }
    else if ([filterType isEqualToString:@"Oil Painting"]) {
        [self oilPainting];
    }
    else if ([filterType isEqualToString:@"Dot Matrix"]) {
        [self dotMatrix];
    }
    else if ([filterType isEqualToString:@"Pencil Sketch"]) {
        [self pencilSketch];
    }
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)sepiaFilter
{
    [SVProgressHUD showWithStatus:@"Applying filter..."];
    GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc]init];
    [sepiaFilter setIntensity:senderValue];
    mainImageView.image=[sepiaFilter imageByFilteringImage:receivedImage];
    [SVProgressHUD dismiss];
}

-(void)embossFilter
{
    [SVProgressHUD showWithStatus:@"Applying filter..."];
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        GPUImageEmbossFilter *embossFilter =[[GPUImageEmbossFilter alloc]init];
        [embossFilter setIntensity:senderValue];
        mainImageView.image=[embossFilter imageByFilteringImage:receivedImage];
        [SVProgressHUD dismiss];
    });
}

-(void)pixellateFilter
{
    [SVProgressHUD showWithStatus:@"Applying filter..."];
    GPUImagePixellateFilter *pixellateFilter = [[GPUImagePixellateFilter alloc]init];
    [pixellateFilter setFractionalWidthOfAPixel:senderValue];
    mainImageView.image=[pixellateFilter imageByFilteringImage:receivedImage];
    [SVProgressHUD dismiss];
}

-(void)polarPixellate
{
    [SVProgressHUD showWithStatus:@"Applying filter..."];
    GPUImagePolarPixellateFilter *polarPix = [[GPUImagePolarPixellateFilter alloc]init];
    if (senderValue>0) {
        [polarPix setPixelSize:CGSizeMake(senderValue, senderValue)];
    }
    else
    {
        [polarPix setPixelSize:CGSizeMake(0.0005, 0.0005)];
    }
    mainImageView.image=[polarPix imageByFilteringImage:receivedImage];
    [SVProgressHUD dismiss];
}

-(void)polkaDot
{
    [SVProgressHUD showWithStatus:@"Applying filter..."];
    GPUImagePolkaDotFilter *polkaFilter = [[GPUImagePolkaDotFilter alloc]init];
    [polkaFilter setFractionalWidthOfAPixel:senderValue];
    mainImageView.image=[polkaFilter imageByFilteringImage:receivedImage];
    [SVProgressHUD dismiss];
}

-(void)toonFilter
{
    [SVProgressHUD showWithStatus:@"Applying filter..."];
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        GPUImageToonFilter *toonFilter = [[GPUImageToonFilter alloc]init];
        [toonFilter setTexelHeight:senderValue];
        [toonFilter setTexelWidth:senderValue];
        //[toonFilter setThreshold:senderValue];
        mainImageView.image=[toonFilter imageByFilteringImage:receivedImage];
        [SVProgressHUD dismiss];
    });
}

-(void)oilPainting
{
    [SVProgressHUD showWithStatus:@"Applying filter..."];
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        GPUImageKuwaharaFilter *oilFilter = [[GPUImageKuwaharaFilter alloc]init];
        [oilFilter setRadius:senderValue];
        mainImageView.image=[oilFilter imageByFilteringImage:receivedImage];
        [SVProgressHUD dismiss];
    });
}

-(void)dotMatrix
{
    [SVProgressHUD showWithStatus:@"Applying filter..."];
    GPUImageHalftoneFilter *dotFilter = [[GPUImageHalftoneFilter alloc]init];
    [dotFilter setFractionalWidthOfAPixel:senderValue];
    mainImageView.image=[dotFilter imageByFilteringImage:receivedImage];
    [SVProgressHUD dismiss];
}

-(void)pencilSketch
{
    [SVProgressHUD showWithStatus:@"Applying filter..."];
    GPUImageSketchFilter *sketch = [[GPUImageSketchFilter alloc]init];
    if (senderValue>0.1) {
        //[sketch setTexelWidth:senderValue];
        //[sketch setTexelHeight:senderValue];
        [sketch setEdgeStrength:senderValue];
    }
    else
    {
        [sketch setEdgeStrength:0.1];
        //[sketch setTexelWidth:0.0001];
        //[sketch setTexelHeight:0.0001];
    }
    mainImageView.image=[sketch imageByFilteringImage:receivedImage];
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
