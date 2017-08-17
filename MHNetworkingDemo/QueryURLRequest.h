//
//  QueryURLRequest.h
//  MHNetworkingDemo
//
//  Created by Malcolm Hall on 13/08/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import <MHNetworking/MHNetworking.h>

@class Query;

@interface QueryURLRequest : MHNURLRequest

@property (strong, nonatomic) Query *query;

-(instancetype)initWithQuery:(Query *)query;

@end
