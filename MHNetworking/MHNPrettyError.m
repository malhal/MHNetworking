//
//  MHNPrettyError.m
//  MHNetworking
//
//  Created by Malcolm Hall on 12/08/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import "MHNPrettyError.h"

@implementation MHNPrettyError

+ (id)errorWithCode:(NSInteger)arg1 format:(NSString *)format, ...{
    va_list args;
    va_start(args, format);
    NSString *s = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    return nil;
}

@end
