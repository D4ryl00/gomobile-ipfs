// +build darwin
//
//  CountDownLatch.m
//  ble
//
//  Created by sacha on 22/11/2018.
//  Copyright © 2018 berty. All rights reserved.
//

#import "CountDownLatch_darwin.h"

@implementation CountDownLatch

- (instancetype)initCount:(NSInteger)count {
    if (count < 0) {
        return nil;
    }

    self = [super self];

    if (self) {
        _count = count;
        _semaphore = dispatch_semaphore_create(0);
        _dispatch_queue = dispatch_queue_create("CountDownLatchQueue", DISPATCH_QUEUE_SERIAL);
    }

    return self;
}

- (void)dealloc {
    _semaphore = nil;
    dispatch_release(_dispatch_queue);
    _dispatch_queue = nil;

    [super dealloc];
}

- (void)incrementCount {
    dispatch_async(self.dispatch_queue, ^{
        self.count++;
    });
}

- (void)countDown {
    dispatch_async(self.dispatch_queue, ^{
        self.count--;
        if (self.count == 0) {
            dispatch_semaphore_signal(self.semaphore);
        }
    });
}

- (void)await {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
}

@end
