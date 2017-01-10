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

static int TLHMian() __attribute__ ((constructor)) {
    
    class_swizzleMethodAndStore(NSClassFromString(@"WCTimeLineViewController"), @selector(reloadTableView), (IMP)new_TimeLine_reloadTableView, (IMP *)&orig_TimeLine_reloadTableView);
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
