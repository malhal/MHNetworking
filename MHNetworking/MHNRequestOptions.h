//
//  MHNRequestOptions.h
//  MHNetworking
//
//  Created by Malcolm Hall on 16/08/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHNRequestOptions : NSObject

@property (copy, nonatomic) NSString *identifier;
@property (copy, nonatomic) NSString *_sourceApplicationBundleIdentifier;
@property (nonatomic) NSInteger qualityOfService;
@property (nonatomic) double _timeoutIntervalForRequest;
@property (nonatomic) BOOL tlsPinning;
@property (nonatomic) BOOL outOfProcess;
@property (nonatomic) BOOL outOfProcessDiscretionary;

- (MHNRequestOptions *)copyAndDecorateRequest:(NSURLRequest *)request;
- (NSURLSessionConfiguration *)sessionConfiguration;
- (NSString *)sessionConfigurationName;
- (NSURLSessionConfiguration *)defaultSessionConfiguration;

@end
