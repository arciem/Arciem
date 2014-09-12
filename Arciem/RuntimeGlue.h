//
//  RuntimeGlue.h
//  Arciem
//
//  Created by Robert McNally on 8/18/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

@import Foundation;

void setAssociatedObject_glue(NSObject *object, const NSString *key, NSObject *value);
NSObject *getAssociatedObject_glue(NSObject *object, const NSString* key);
