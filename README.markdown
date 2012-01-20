#### Block-based NSTimer

Uses blocks instead of the old-school target & selector NSTimer.

#### Scheduling a Timer

```

// Can be repeating or single-fire
NSTimer *myTimer = [[ASBlockTimer sharedTimers] scheduleBlockTimerWithTimeInterval:1.0 userInfo:nil repeats:YES completion:^(NSTimer *timer) {
       
        NSLog(@"Repeats...");
}];

```

#### Invalidating a Timer

```
NSTimer* myTimer = ...

[[ASBlockTimer sharedTimers] cancelBlockTimer:myTimer];

```

#### Invalidate all Timers

```
[[ASBlockTimer sharedTimers] cancelAllBlockTimers];
```