typedef void (^CDUnknownBlockType) ();
//
//  MHNStreamWriter.h
//  MHNetworking
//
//  Created by Malcolm Hall on 13/08/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHNStreamWriter : NSObject<NSStreamDelegate>

@property (strong, nonatomic) NSFileHandle *binaryLogFileHandle; // @synthesize binaryLogFileHandle=_binaryLogFileHandle;
@property (nonatomic) NSUInteger bufferSize; // @synthesize bufferSize=_bufferSize;
@property (nonatomic) BOOL hasInitedCompression; // @synthesize hasInitedCompression=_hasInitedCompression;
@property (nonatomic) BOOL haveFinishedCompression; // @synthesize haveFinishedCompression=_haveFinishedCompression;
@property BOOL haveFinishedStreaming; // @synthesize haveFinishedStreaming=_haveFinishedStreaming;
@property (copy, nonatomic) CDUnknownBlockType logRequestObjectBlock; // @synthesize logRequestObjectBlock=_logRequestObjectBlock;
@property (nonatomic) BOOL shouldCompress; // @synthesize shouldCompress=_shouldCompress;
//@property (weak, nonatomic) id<CKDProtobufMessageSigningDelegate> signingDelegate; // @synthesize signingDelegate=_signingDelegate;

- (void)dealloc;
- (instancetype)initWithCompression:(BOOL)shouldCompress;
- (id)open;
- (void)setStreamedObjects:(id)arg1;
- (void)stream:(id)arg1 handleEvent:(NSUInteger)arg2;
- (void)tearDown;

@end
