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
    CGRect viewRect;
}

@property (nonatomic, retain) iCarousel *carousel;
@property (nonatomic, assign) BOOL wrap;
@property (nonatomic, strong) NSMutableArray *possibilities;

@end

@implementation EnumJudgementViewController

@synthesize carousel;
@synthesize wrap;
@synthesize possibilities;
@synthesize prevData;
@synthesize projectComponent;


- (void)dealloc
{
	carousel.delegate = nil;
	carousel.dataSource = nil;
}

- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super init];
    viewRect = frame;
    wrap = YES;
    return self;
}

-(void)loadView{
    [super loadView];
    //create carousel
    carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];//44 navbar height.
    
    carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    carousel.type = iCarouselTypeLinear;
    carousel.delegate = self;
    carousel.dataSource = self;
    
    //add carousel to view
    [self.view addSubview:carousel];
    chosenPossibility = nil;
}


-(void)viewWillAppear:(BOOL)animated{
    self.view.frame = viewRect;
    self.view.backgroundColor = [UIColor orangeColor];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height * .04, self.view.bounds.size.width, 22)];
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.font = [descriptionLabel.font fontWithSize:20];
    descriptionLabel.text = @"Choose an option";
    descriptionLabel.tag = 2;
    [self.view addSubview:descriptionLabel];
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    [attributes setObject:projectComponent.title forKey:@"projectComponent.title"];
    [[AppModel sharedAppModel] getProjectComponentPossibilitiesWithAttributes:attributes withHandler:@selector(handlePossibilityResponse:) target:self];
    
    if(prevData){
        if([prevData.wasJudged boolValue]){
            NSArray *judgementSet = [prevData.userObservationComponentDataJudgement allObjects];
            if(!judgementSet || judgementSet.count < 1){
                NSLog(@"ERROR: Judgement set was nil or had 0 data members");
            }
            UserObservationComponentDataJudgement *judgement = [judgementSet objectAtIndex:0];
            if(!judgement){
                NSLog(@"ERROR: judgement was nil");
            }
            NSArray *prevPossibilities = [judgement.projectComponentPossibilities allObjects];
            if(!prevPossibilities){
                NSLog(@"ERROR: There were no possibilities, even though it was judged.");
            }
            ProjectComponentPossibility *prevPossibility = [prevPossibilities objectAtIndex:0];
            chosenPossibility = prevPossibility;
        }
    }
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
        
        
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width *.6, self.view.bounds.size.height *.6)];
        
        view.contentMode = UIViewContentModeCenter;
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height * .4, self.view.bounds.size.width *.6, self.view.bounds.size.height *.6)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:20];
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
    
    
    
    //Probably should make a class that handles all of these
    NSString *projectComponentTitleString = projectComponent.title;
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@" "];
    projectComponentTitleString = [[projectComponentTitleString componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @"_"];
    ProjectComponentPossibility *pos = possibilities[index];
    projectComponentTitleString = [projectComponentTitleString stringByAppendingFormat:@"-%@.png", pos.enumValue];
    
    ((UIImageView *)view).image = [self imageWithImage:[UIImage imageNamed:projectComponentTitleString] scaledToSize:CGRectMake(0, 0, self.view.bounds.size.height *.6, self.view.bounds.size.height *.6).size];
    //[self imageWithImage:[UIImage imageNamed:@"page.png"] scaledToSize:CGRectMake(0, 0, 60, 95).size];
    //[UIImage imageNamed:@"35-circle-stop.png"];
    
    
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
    possibilities = [NSMutableArray arrayWithArray:componentPossibilities];
    //remove the nil value if it has one
    for (int i = 0; i < possibilities.count; i++) {
        ProjectComponentPossibility *possibility = [possibilities objectAtIndex:i];
        if ([possibility.enumValue isEqualToString:@""]) {
            [possibilities removeObject:possibility];
        }
    }
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
