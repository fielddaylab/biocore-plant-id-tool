//
//  APIClient.h
//  FieldResearchTool
//
//  Created by Phil Dougherty on 7/11/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "AFRESTClient.h"
#import "AFIncrementalStore.h"

@interface APIClient : AFRESTClient <AFIncrementalStoreHTTPClient>

+ (APIClient *)sharedClient;

@end
