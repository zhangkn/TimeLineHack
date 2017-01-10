//
//  TimeLineHack.m
//  TimeLineHack
//
//  Created by Jay on 2017/1/10.
//  Copyright (c) 2017年 __MyCompanyName__. All rights reserved.
//

#import "TimeLineHack.h"
#import "TLHSwizzle.h"

static void (*orig_TimeLine_reloadTableView)(id self, SEL _cmd);
static void new_TimeLine_reloadTableView(id self, SEL _cmd) {
    
    NSLog(@"new_TimeLine_reloadTableView");
    
    orig_TimeLine_reloadTableView(self, _cmd);
}

static id (*orig_TimeLineView_cellForRowAtIndexPath)(id self, SEL _cmd, id arg1, id arg2);
static id new_TimeLineView_cellForRowAtIndexPath(id self, SEL _cmd, id arg1, id arg2) {
    
    NSLog(@"new_TimeLineView_cellForRowAtIndexPath");
    
    orig_TimeLineView_cellForRowAtIndexPath(self, _cmd, arg1, arg2);
}

static int TLHMian() __attribute__ ((constructor)) {
    
    class_swizzleMethodAndStore(NSClassFromString(@"WCTimeLineViewController"), @selector(reloadTableView), (IMP)new_TimeLine_reloadTableView, (IMP *)&orig_TimeLine_reloadTableView);

    class_swizzleMethodAndStore(NSClassFromString(@"WCTimeLineViewController"), @selector(tableView:cellForRowAtIndexPath:), (IMP)new_TimeLineView_cellForRowAtIndexPath, (IMP*)&orig_TimeLineView_cellForRowAtIndexPath);
}

@implementation TimeLineHack

+ (id)shareInstance {
    
    static TimeLineHack *instacne = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instacne = [[TimeLineHack alloc] init];
    });
    
    return instacne;
}

-(id)init
{
	if ((self = [super init]))
	{
	}
    
	return self;
}

@end
