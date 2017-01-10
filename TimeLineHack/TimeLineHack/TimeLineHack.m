//
//  TimeLineHack.m
//  TimeLineHack
//
//  Created by Jay on 2017/1/10.
//  Copyright (c) 2017年 __MyCompanyName__. All rights reserved.
//

#import "TimeLineHack.h"
#import "TLHSwizzle.h"

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
