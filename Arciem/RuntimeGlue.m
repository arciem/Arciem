//
//  RuntimeGlue.m
//  Arciem
//
//  Created by Robert McNally on 8/18/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

#import "RuntimeGlue.h"
#import <objc/runtime.h>

void setAssociatedObject_glue(NSObject *object, const NSString *key, NSObject *value) {
    objc_setAssociatedObject(object, (__bridge const void *)(key), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

NSObject *getAssociatedObject_glue(NSObject *object, const NSString* key) {
    return objc_getAssociatedObject(object, (__bridge const void *)(key));
}
