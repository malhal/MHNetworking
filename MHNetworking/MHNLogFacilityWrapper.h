//
//  MHNLogFacilityWrapper.h
//  MHNetworking
//
//  Created by Malcolm Hall on 13/08/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
@import os.log;

extern void mhn_log_facilities_initailize_static();
extern os_log_t mhn_log_facility_mhn;
extern os_log_t mhn_log_facility_pool;

#define mhn_log_with_type(log, type, format, ...) mhn_log_facilities_initailize_static(); \
    os_log_with_type(log, type, format, ## __VA_ARGS__)

@interface MHNLogFacilityWrapper : NSObject

@property(readonly, nonatomic) NSString *facilityName; // @synthesize facilityName=_facilityName;
//@property(readonly, nonatomic) NSObject<OS_os_log> *facility; // @synthesize facility=_facility;

- (id)initWithFacility:(id)arg1 facilityName:(id)arg2;

@end
