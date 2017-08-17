//
//  QueryURLRequest.m
//  MHNetworkingDemo
//
//  Created by Malcolm Hall on 13/08/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import "QueryURLRequest.h"
#import "QueryRetrieveRequest.h"

@implementation QueryURLRequest // CKDQueryURLRequest

-(instancetype)initWithQuery:(Query *)query
{
    self = [super init];
    if (self) {
        _query = query;
    }
    return self;
}

- (int)operationType{
    return 0xdc;
}

- (NSArray *)requestOperationClasses{
    return @[[QueryRetrieveRequest class]];
}

- (NSArray *)generateRequestOperations{
    id i = [self operationRequestWithType:self.operationType];
    // set something
    return @[i];
}

@end
