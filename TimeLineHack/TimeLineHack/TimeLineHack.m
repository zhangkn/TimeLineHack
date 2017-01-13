//
//  TimeLineHack.m
//  TimeLineHack
//
//  Created by Jay on 2017/1/10.
//  Copyright (c) 2017年 __MyCompanyName__. All rights reserved.
//

#import "TimeLineHack.h"
#import "TLHSwizzle.h"
#import <UIKit/UIKit.h>
#import "WCTimeLineViewController.h"
#import "WCContentItem.h"
#import "MMServiceCenter.h"
#import "WCFacade.h"
#import "WCDataItem.h"
#import "MMNewSessionMgr.h"

static void (*orig_TimeLine_reloadTableView)(id self, SEL _cmd);
static void new_TimeLine_reloadTableView(id self, SEL _cmd) {
    
    NSLog(@"朋友圈刷新列表");
    
    orig_TimeLine_reloadTableView(self, _cmd);
    
    MMServiceCenter *serviceCenter = [NSClassFromString(@"MMServiceCenter") defaultCenter];
    
    WCFacade *facade = [serviceCenter getService:NSClassFromString(@"WCFacade")];

    NSMutableArray *timeLineDatas = [facade valueForKey:@"m_timelineWithLocalDatas"];
    
    NSLog(@"timeLineDatas %@", timeLineDatas);

    WCDataItem *dataItem = [[NSClassFromString(@"WCDataItem") alloc] init];
    
    [dataItem setUsername:@"martin028174"];
    
    [dataItem setContentDesc:@"只是个测试"];

    MMNewSessionMgr *newSessionMgr = [serviceCenter getService:objc_getClass("MMNewSessionMgr")];
    
    unsigned int time = [newSessionMgr GenSendMsgTime];

    [dataItem setCreateTime:time];
    
    [dataItem setType:1];
    
    [timeLineDatas insertObject:dataItem atIndex:0];
}

static id (*orig_TimeLineView_cellForRowAtIndexPath)(id self, SEL _cmd, UITableView *arg1, id arg2);
static id new_TimeLineView_cellForRowAtIndexPath(id self, SEL _cmd, UITableView *arg1, id arg2) {
    
    NSLog(@"朋友圈获取CELL");

    return orig_TimeLineView_cellForRowAtIndexPath(self, _cmd, arg1, arg2);
}

static id (*orig_WCContentItem_init)(WCContentItem *self, SEL _cmd);
static id new_WCContentItem_init(WCContentItem *self, SEL _cmd) {
    
    NSLog(@"朋友圈CELL 数据");
    
    WCContentItem *orig_item = orig_WCContentItem_init(self, _cmd);
    
    NSLog(@"原来的内容, %@", orig_item.desc);
    
    return orig_WCContentItem_init(self, _cmd);
}

static id (*orig_WCContentItem_initWithCoder)(WCContentItem *self, SEL _cmd, id arg1);
static id new_WCContentItem_initWithCoder(WCContentItem *self, SEL _cmd, id arg1) {
    
    NSLog(@"朋友圈CELL 数据2");
    
    WCContentItem *orig_item = orig_WCContentItem_initWithCoder(self, _cmd, arg1);
    
    NSLog(@"原来的内容 2, title: %@, desc: %@, nickname :%@", orig_item.title, orig_item.mediaList, orig_item.username);
    
    return orig_item;
}

static id (*orig_WCFacade_onTimelineDataChangedWithAdded)(id self, SEL _cmd, id arg1, id arg2, id arg3);
static id new_WCFacade_onTimelineDataChangedWithAdded(id self, SEL _cmd, id arg1, id arg2, id arg3) {
    
    NSLog(@"new_WCFacade_onTimelineDataChangedWithAdded %@, %@, %@", arg1, arg2, arg3);
    
    return orig_WCFacade_onTimelineDataChangedWithAdded(self, _cmd, arg1, arg2, arg3);
}

static void (*orig_WCFacade_reloadTimelineDataItems)(id self, SEL _cmd);
static void new_WCFacade_reloadTimelineDataItems(id self, SEL _cmd) {
    
    NSLog(@"new_WCFacade_reloadTimelineDataItems");

    orig_WCFacade_reloadTimelineDataItems(self, _cmd);
}

static int TLHMian() __attribute__ ((constructor)) {
    
    TLH_class_swizzleMethodAndStore(NSClassFromString(@"WCTimeLineViewController"), @selector(reloadTableView), (IMP)new_TimeLine_reloadTableView, (IMP *)&orig_TimeLine_reloadTableView);
/*
    TLH_class_swizzleMethodAndStore(NSClassFromString(@"WCTimeLineViewController"), @selector(tableView:cellForRowAtIndexPath:), (IMP)new_TimeLineView_cellForRowAtIndexPath, (IMP*)&orig_TimeLineView_cellForRowAtIndexPath);
    
    TLH_class_swizzleMethodAndStore(NSClassFromString(@"WCContentItem"), @selector(init), (IMP)new_WCContentItem_init, (IMP*)&orig_WCContentItem_init);
    
    TLH_class_swizzleMethodAndStore(NSClassFromString(@"WCContentItem"), @selector(initWithCoder:), (IMP)new_WCContentItem_initWithCoder, (IMP *)&orig_WCContentItem_initWithCoder);
    */
    
    /*
    WCTimelineDataProvider MessageReturn:Event: //朋友圈请求回调
    
    -[WCTimelineMgr onDataUpdated:andData:andAdData:withChangedTime:]
    
    WCFacade onTimelineDataChangedWithAdded:andChanged:andDeleted:   //增删查改
    */
    TLH_class_swizzleMethodAndStore(NSClassFromString(@"WCFacade"), @selector(onTimelineDataChangedWithAdded:andChanged:andDeleted:), (IMP)new_WCFacade_onTimelineDataChangedWithAdded, (IMP*)&orig_WCFacade_onTimelineDataChangedWithAdded);
    
    TLH_class_swizzleMethodAndStore(NSClassFromString(@"WCFacade"), @selector(reloadTimelineDataItems), (IMP)new_WCFacade_reloadTimelineDataItems, (IMP*)&orig_WCFacade_reloadTimelineDataItems);
    
//    onTimelineDataChangedWithAdded:(id)arg1 andChanged:(id)arg2 andDeleted:(id)arg3;

    [TimeLineHack shareInstance];
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
