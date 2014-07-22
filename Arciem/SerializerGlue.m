//
//  SerializerGlue.m
//  Arciem
//
//  Created by Robert McNally on 7/22/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

#import "SerializerGlue.h"

void dispatch_queue_set_specific_glue(dispatch_queue_t queue, NSString *key, NSNumber *context) {
    dispatch_queue_set_specific(queue, (__bridge const void *)(key), (__bridge void *)(context), nil);
}

NSNumber *dispatch_get_specific_glue(NSString *key) {
    return (__bridge NSNumber *)(dispatch_get_specific((__bridge const void *)(key)));
}