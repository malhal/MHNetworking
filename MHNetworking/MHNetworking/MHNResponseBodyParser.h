typedef void (^CDUnknownBlockType) ();
//
//  MHNResponseBodyParser.h
//  MHNetworking
//
//  Created by Malcolm Hall on 12/08/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHNResponseBodyParser : NSObject

@property (copy, nonatomic) void (^objectParsedBlock)(id object, NSError *error);
@property (readonly, nonatomic) NSObject<OS_dispatch_queue> *parseQueue;
@property (strong, nonatomic) NSMutableData *parserData;
@property (strong, nonatomic) NSError *parserError; // @synthesize parserError=_parserError;
@property (nonatomic) NSInteger qualityOfService; // @synthesize qualityOfService=_qualityOfService;

- (void)finishWithCompletion:(CDUnknownBlockType)arg1;
- (id)initWithQoS:(NSInteger)arg1;
- (void)processData:(id)arg1;

@end
