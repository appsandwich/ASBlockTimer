//
//  ASBlockTimer.m
//  ASBlockTimer
//
//  Created by Vinny Coyne on 20/01/2012.
//  Copyright (c) 2012 App Sandwich Limited. All rights reserved.
//

#import "ASBlockTimer.h"

@interface ASBlockTimer (Private)

-(void)blockTimerFired:(NSTimer *)timer;

@end

@implementation ASBlockTimer

-(id)init {
    self = [super init];
    
    if (self) {
        _timers = [NSMutableArray array];
    }
    
    return self;
}

+(id)sharedTimers {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

-(NSTimer *)scheduleBlockTimerWithTimeInterval:(NSTimeInterval)timeInterval userInfo:(id)userInfo repeats:(BOOL)repeats completion:(ASBlockTimerHandler)completion {
    
    if ((completion == NULL) || (completion == nil))
        return nil;
    
    NSTimer *newTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(blockTimerFired:) userInfo:userInfo repeats:repeats];
    
    if (newTimer) {
        
        NSDictionary *timerDictionary = [NSDictionary dictionaryWithObjectsAndKeys:newTimer, @"timer", [NSNumber numberWithBool:repeats], @"repeats", [completion copy], @"completion", nil];
        [_timers addObject:timerDictionary];
    }
    
    return newTimer;
}

-(void)cancelBlockTimer:(NSTimer *)timer {
    if (timer) {
        
        NSDictionary *currentTimerDictionary = nil;
        
        for (NSDictionary *timerDictionary in _timers) {
            if (timer == [timerDictionary objectForKey:@"timer"]) {
                currentTimerDictionary = timerDictionary;
                break;
            }
        }
        
        if (currentTimerDictionary) {
            
            if (![(NSNumber *)[currentTimerDictionary objectForKey:@"repeats"] boolValue]) {
                [_timers removeObject:currentTimerDictionary];
            }
        }
        
        [timer invalidate];
    }
}

-(void)cancelAllBlockTimers {
    
    for (NSDictionary *timerDictionary in _timers) {
        NSTimer *timer = [timerDictionary objectForKey:@"timer"];
        [timer invalidate];
    }
    
    [_timers removeAllObjects];
}

#pragma mark - Private methods

-(void)blockTimerFired:(NSTimer *)timer {
    
    if (timer) {
        
        NSDictionary *currentTimerDictionary = nil;
        
        for (NSDictionary *timerDictionary in _timers) {
            if (timer == [timerDictionary objectForKey:@"timer"]) {
                currentTimerDictionary = timerDictionary;
                break;
            }
        }
        
        if (currentTimerDictionary) {
            
            ASBlockTimerHandler completion = [currentTimerDictionary objectForKey:@"completion"];
            
            if (![(NSNumber *)[currentTimerDictionary objectForKey:@"repeats"] boolValue]) {
                [_timers removeObject:currentTimerDictionary];
            }
            
            if ((completion == NULL) || (completion == nil))
                return;
            
            completion(timer);
        }
        
    }
}

@end
