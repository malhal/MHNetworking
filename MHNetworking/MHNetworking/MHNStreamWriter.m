//
//  MHNStreamWriter.m
//  MHNetworking
//
//  Created by Malcolm Hall on 13/08/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//
#import "MHNStreamWriter.h"
#include <zlib.h>
#import "MHNLogFacilityWrapper.h"

@interface MHNStreamWriter()

- (id)_compressBodyData:(id)arg1 shouldFlush:(BOOL)arg2;
- (id)_dataForMessage:(id)arg1;
- (BOOL)_finishStreaming:(id)arg1;
- (id)_prepareMescalSignature:(id)arg1;
- (void)_prepareObjectForStreaming:(id)arg1 shouldSign:(BOOL)arg2;
- (NSInteger)_streamNextObject:(id)arg1;
- (void)_tearDownOutputStream;
- (NSInteger)_writeDataToStream:(id)arg1;

@end

@implementation MHNStreamWriter{
    struct z_stream_s _zlibStream;
    dispatch_queue_t _dispatchQueue;
}

- (instancetype)initWithCompression:(BOOL)shouldCompress
{
    self = [super init];
    if (self) {
        _shouldCompress = shouldCompress;
        if(shouldCompress){
            int result = deflateInit2_(&_zlibStream, Z_DEFAULT_COMPRESSION, Z_DEFLATED, 31, 8, 0, "1.2.11", 112);
            if(result != Z_OK){
                mhn_log_facilities_initailize_static();
                if(os_log_type_enabled(mhn_log_facility_mhn, OS_LOG_TYPE_ERROR)){
                    os_log_error(mhn_log_facility_mhn, "Could not initialize zlib for compression, error %d", result);
                }
            }
            else{
                _hasInitedCompression = YES;
            }
        }
        _bufferSize = 1024;
        _dispatchQueue = dispatch_queue_create([NSStringFromClass([self class]) UTF8String], dispatch_queue_attr_make_with_autorelease_frequency(0, DISPATCH_AUTORELEASE_FREQUENCY_WORK_ITEM));
    }
    return self;
}

@end
