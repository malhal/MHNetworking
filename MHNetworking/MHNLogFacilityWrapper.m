//
//  MHNLogFacilityWrapper.m
//  MHNetworking
//
//  Created by Malcolm Hall on 13/08/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//
#import "MHNLogFacilityWrapper.h"

os_log_t mhn_log_facility_mhn;
os_log_t mhn_log_facility_pool;

extern void mhn_log_facilities_initailize_static(){
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mhn_log_facility_mhn = os_log_create("com.malhal.MHNetworking", "LogFacilityMHN");
        mhn_log_facility_mhn = os_log_create("com.malhal.MHNetworking", "LogFacilityPool");
    });
}

@implementation MHNLogFacilityWrapper

@end
