//
//  ASBlockTimer.h
//  ASBlockTimer
//
//  Created by Vinny Coyne on 20/01/2012.
//  Copyright (c) 2012 App Sandwich Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ASBlockTimerHandler)(NSTimer *timer);

@interface ASBlockTimer : NSObject {
    
@private
    NSMutableArray *_timers;
}

+(id)sharedTimers;
-(NSTimer *)scheduleBlockTimerWithTimeInterval:(NSTimeInterval)timeInterval userInfo:(id)userInfo repeats:(BOOL)repeats completion:(ASBlockTimerHandler)completion;
-(void)cancelBlockTimer:(NSTimer *)timer;
-(void)cancelAllBlockTimers;

@end
