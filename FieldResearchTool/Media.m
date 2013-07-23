//
//  Media.m
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/23/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "Media.h"
#import "Project.h"
#import "ProjectComponent.h"
#import "ProjectComponentPossibility.h"
#import "ProjectIdentification.h"
#import "User.h"
#import "UserObservationComponentData.h"


@implementation Media

@dynamic created;
@dynamic updated;
@dynamic media_url;
@dynamic type;
@dynamic project;
@dynamic projectComponent;
@dynamic projectComponentPossibility;
@dynamic projectIdentification;
@dynamic user;
@dynamic userObservationComponentData;
@synthesize mediaManager;

-(NSURL *)getMedia{
    if(mediaManager == nil){
        mediaManager = [[MediaManager alloc]init];
    }
    NSURL *mediaURL = [mediaManager getMediaContentsForPath:self.media_url];
    self.media_url = [mediaURL path];
    return mediaURL;
}

@end
