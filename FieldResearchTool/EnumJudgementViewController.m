//
//  EnumJudgementViewController.m
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/25/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "EnumJudgementViewController.h"
#import "iCarousel.h"
#import "ProjectComponentPossibility.h"
#import "AppModel.h"
#import "SaveObservationAndJudgementDelegate.h"

@interface EnumJudgementViewController () <iCarouselDataSource, iCarouselDelegate, UIActionSheetDelegate, SaveJudgementDelegate>{
    ProjectComponentPossibility *chosenPossibility;
}

@property (nonatomic, retain) iCarousel *carousel;
@property (nonatomic, assign) BOOL wrap;
@property (nonatomic, strong) NSArray *possibilities;

@end

@implementation EnumJudgementViewController

@synthesize carousel;
@synthesize wrap;
@synthesize possibilities;
@synthesize projectComponent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	carousel.delegate = nil;
	carousel.dataSource = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    wrap = YES;

    //create carousel
    carousel = [[iCarousel alloc] initWithFrame:self.view.bounds];
	carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    carousel.type = iCarouselTypeLinear;
	carousel.delegate = self;
	carousel.dataSource = self;
    
	//add carousel to view
	[self.view addSubview:carousel];
    
    chosenPossibility = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    [attributes setObject:projectComponent.title forKey:@"projectComponent.title"];
    [[AppModel sharedAppModel] getProjectComponentPossibilitiesWithAttributes:attributes withHandler:@selector(handlePossibilityResponse:) target:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [possibilities count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150.0f, 200.0f)];
        //((UIImageView *)view).image = [UIImage imageNamed:@"35-circle-stop.png"];
        view.contentMode = UIViewContentModeCenter;
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
        label.textColor = [UIColor blackColor];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    ProjectComponentPossibility *componentPossibility = [possibilities objectAtIndex:index];
    label.text = componentPossibility.enumValue;
    
    if(chosenPossibility){
        if([componentPossibility.enumValue isEqualToString:chosenPossibility.enumValue]){
            label.textColor = [UIColor redColor];
        }
    }
    
    return view;
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1f;
    }
    return value;
}

#pragma mark - iCarousel taps

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    chosenPossibility = [possibilities objectAtIndex:index];
    [self.carousel reloadData];
}

#pragma mark handle possibility response
-(void)handlePossibilityResponse:(NSArray *)componentPossibilities{
    possibilities = componentPossibilities;
    [carousel reloadData];
}

#pragma mark save observation and judgement delegates

-(UserObservationComponentDataJudgement *)saveJudgementData:(UserObservationComponentData *)userData{
    if(!userData){
        NSLog(@"ERROR: Observation data passed in was nil");
        return nil;
    }
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    [attributes setObject:[NSDate date] forKey:@"created"];
    [attributes setObject:[NSDate date] forKey:@"updated"];
    
    if(chosenPossibility){
        [attributes setObject:chosenPossibility.enumValue forKey:@"enumValue"];
        UserObservationComponentDataJudgement *judgement = [[AppModel sharedAppModel] createNewJudgementWithData:userData withProjectComponentPossibility:[NSArray arrayWithObject:chosenPossibility] withAttributes:attributes];
        return judgement;
    }
    
    NSLog(@"No Possibility was chosen. No Judgement was made.");
    
    return nil;
}


@end
