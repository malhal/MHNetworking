//
//  MHNRequestManager.h
//  MHNetworking
//
//  Created by Malcolm Hall on 16/08/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MHNSessionPool, MHNRequestOptions;
@protocol MHNRequestDelegate;

@interface MHNRequestManager : NSObject

@property (class, readonly, strong) MHNRequestManager *sharedManager;

@property (readonly, nonatomic) MHNSessionPool *sessionPool;

- (id)createDataTaskWithRequest:(NSURLRequest *)request options:(MHNRequestOptions *)options delegate:(id<MHNRequestDelegate>)delegate;
- (id)createDataTaskWithRequest:(NSURLRequest *)request options:(MHNRequestOptions *)options delegate:(id<MHNRequestDelegate>)delegate sessionHandle:(NSURLSession **)sessionHandle;

@end
