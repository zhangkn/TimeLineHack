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
#import "WCMediaItem.h"
#import "WCUrl.h"
#import "WCAdvertiseInfo.h"
#import "WCObjectOperation.h"
#import "WCADCanvasInfo.h"
#import "WCMultiLanguageItem.h"

static void (*orig_TimeLine_reloadTableView)(id self, SEL _cmd);
static void new_TimeLine_reloadTableView(id self, SEL _cmd) {
    
    orig_TimeLine_reloadTableView(self, _cmd);
    
    MMServiceCenter *serviceCenter = [NSClassFromString(@"MMServiceCenter") defaultCenter];
    
    WCFacade *facade = [serviceCenter getService:NSClassFromString(@"WCFacade")];

    NSMutableArray *timeLineDatas = [facade valueForKey:@"m_timelineWithLocalDatas"];
    
    NSLog(@"timeLineDatas begin %@", timeLineDatas);

    WCDataItem *dataItem = [[NSClassFromString(@"WCDataItem") alloc] init];
    
    [dataItem setUsername:@"gh_08a102eb8dfb"];
    
    [dataItem setNickname:@""];
    
    [dataItem setFlag:0];
    
    [dataItem setType:0];
    
    [dataItem setCid:0];
    
    [dataItem setContentDesc:@"只是个测试"];
    
    [dataItem setSightFolded:0];
    
    [dataItem setStatExtStr:@"CncIARIUMTI0NDkxMzI0MDczMjUwNzExODIaKTE2MDAwMDYzMTJ8d3gweTdlazIyenFoN2JvaXx8MXwxNDg0NjE0Njk0IAAqMHNuc0lkPTEyNDQ5MTMyNDA3MzI1MDcxMTgyJmFkZ3JvdXBfaWQ9MTYwMDAwNjMxMg=="];
    
    [dataItem setSelfCommentCount:0];
    
    [dataItem setSelfLikeCount:0];
    
    [dataItem setRealLikeCount:0];
    
    [dataItem setRealCommentCount:0];
    
    [dataItem setIsLikeUsersUnsafe:0];
    
    [dataItem setIsContentUnsafe:0];
    
    [dataItem setCpKeyForLikeUsers:@"wctlls|gh_08a102eb8dfb|12449132407325071182"];
    
    
    
    WCObjectOperation *objectOperation = [[NSClassFromString(@"WCObjectOperation") alloc] init];
    
    [objectOperation setSnsOperateFlag:2];
    
    [dataItem setObjOperation:objectOperation];
    
    [dataItem setExtFlag:1];
    
    
    //广告信息
    WCAdvertiseInfo *advertiseInfo = [[NSClassFromString(@"WCAdvertiseInfo") alloc] init];
    
    [advertiseInfo setSessionAid:@"1600006312"];
    
    [advertiseInfo setTraceId:@"wx0y7ek22zqh7boi"];
    
    //广告画布
    WCADCanvasInfo *canvasInfo = [[NSClassFromString(@"WCADCanvasInfo") alloc] init];
    
    [advertiseInfo setAdCanvasInfo:canvasInfo];
    
    
    
    [advertiseInfo setAdActionAppStoreType:0];
    
    [advertiseInfo setAdActionLinkWithTraceId:@"http://www.baidu.com"];
    
    
    NSMutableDictionary *adArgsDic = [[NSMutableDictionary alloc] initWithDictionary:@{@"classify_en" : @"appliance",
                             @"classify_zh_TW" : @"\xe9\x9b\xbb\xe5\x99\xa8",
                             @"classify_zh_CN" : @"\xe7\x94\xb5\xe5\x99\xa8"                                                        }];
    
    [advertiseInfo setAdArgsDic:adArgsDic];
    
    [advertiseInfo setUxInfo:@"1600006312|wx0y7ek22zqh7boi||1|1484614694"];
    
    WCMultiLanguageItem *languageInItme = [[NSClassFromString(@"WCMultiLanguageItem") alloc] init];
    
    [languageInItme setEn:@"Sponsored story"];
    
    [languageInItme setZh:@"赞助商提供的广告信息"];
    
    [languageInItme setTw:@"赞助商提供的广告信息"];
    
    [advertiseInfo setExpandInsideTitle:languageInItme];
    
    WCMultiLanguageItem *languageOutItem = [[NSClassFromString(@"WCMultiLanguageItem") alloc] init];
    
    [languageOutItem setEn:@"Sponsored"];
    
    [languageOutItem setZh:@"广告"];
    
    [languageOutItem setTw:@"广告"];
    
    [advertiseInfo setExpandOutsideTitle:languageOutItem];
    
    [advertiseInfo setAdActionLinkHidden:NO]; //是否隐藏链接
    
    
    [advertiseInfo setAdUserNickName:@"瞎鸡巴写"];
    
    [advertiseInfo setWebviewRightBarShow:YES];
    
    [advertiseInfo setExposureNoActionExpireTime:660];
    
    [advertiseInfo setNoExposureExpireTime:660];
    
    [advertiseInfo setBExposured:YES];
    
    [advertiseInfo setAdPosition:4];
    
    [advertiseInfo setAdViewId:@"6X9Bvd1FVd7vP1aQCItCC/6UEmDQEcGfnpZZDAqsfMBSU9Xa2Xwm2K0C45/haYeeVNwfIHT7uQ/PCfJDFJ5YDxbmH0Jjxwn74H9Tkq0Kl5EqhxgOod/RLWyxSUd6gA9bvQUpO47JodAuU8QevhN6QhJfh9k/v4f6P0GAo3e4jD%2BaOvNb%2BW3pHoN/Ye9D1tWFVm0pESIMHpcuFgdVSJXPv/wSzdXT9AS6WMB7ENaU7TMa4sp7FK1xmqDhWp3L9M0K3FGlXFAUx%2B8ZXC9wIK66maJjdHdBsgyRfJs87%2BII7gE3ZMs9QJ6VYXxhbWl7Sh8PjuPkm2EN%2B53fAQhvRsFMjjFAl6Sw8FoQ3ymgz7s22S3bMyhqex%2B5VhfSMjNes9dOO1XNOhYzP74tI2iF111%2BE3S6VdsBsOJSfdtvu33B%2B2ZAv5dliviVcI/Lbo24OwGFYUeue3GwzR%2BqrI4dx3DzjiKb7XqevpLALGEf%2B8tgRPpyNmkRjPSgTTJyOpCCN49LvfAyLI2Y%2BueBRlS2zDrYytXV%2BLELiYDydHBVXlr12oPU4ABG1CqnrkIBFZE67RDICjGAcxmsmFlZeCZ2zEQi4Fpysfb6p/swj769ysRGKN56lPem8pW/hLMEAwKUkNmEa//Qa/%2BZNmHMTphH8a7Rgj0TKiEv7T1IEEU2dqsqxlebpXdCplKEhbNFPecQpXjFeQ/0uCM/kqdRehbRIRrZTfxOCIupdv7NR2/rb1we7z2UOSgQlWW4W73jVoDeiJtaWVXNvhgWscmaSVK9B6wKlr97YzVBBGzk"];
    
    [advertiseInfo setAdActionType:0];
    
    [advertiseInfo setAdActionLink:@"https://www.baidu.com"];
    
    [advertiseInfo setAdDescription:@"这又是啥"];
    
    
    [dataItem setAdvertiseInfo:advertiseInfo];
    
    [dataItem setContentDescPattern:@"<parser><type>1</type><range>{0, 12}</range></parser>"];
    
    NSMutableDictionary *extDataDic = [[NSMutableDictionary alloc] initWithDictionary:@{@"contentDescPattern" : [dataItem contentDescPattern]}];
    
    [dataItem setExtData:extDataDic];
    
    NSMutableArray *shareGroupArray = [[NSMutableArray alloc] init];
    
    [dataItem setSharedGroupIDs:shareGroupArray];
    
    [dataItem setContentDescScene:3];
    
    [dataItem setContentDescShowType:0];
    


    MMNewSessionMgr *newSessionMgr = [serviceCenter getService:objc_getClass("MMNewSessionMgr")];
    
    unsigned int time = [newSessionMgr GenSendMsgTime];

    [dataItem setCreateTime:time];
    
    [dataItem setTid:@"12451152990729023630"];
    
    
    WCContentItem *contentItem = [[NSClassFromString(@"WCContentItem") alloc] init];
    
    [contentItem setUsername:@"gh_4b7111318206"];
    
    [contentItem setType:1];
    
    [contentItem setCreatetime:time];
    
    
    
    WCMediaItem *mediaItem = [[NSClassFromString(@"WCMediaItem") alloc] init];
    
    [mediaItem setType:1];
    
    [mediaItem setCreateTime:time];
    
    [mediaItem setSubType:0];
    
    
    WCUrl *url = [NSClassFromString(@"WCUrl") UrlWithUrl:@"http://mmsns.qpic.cn/mmsns/bs7qzvQlecibalsmURObdlHE7ozTEHGhKyoOmCE7FiclkZh2WOcfkVYw/0" type:1];
    
//    [url setType:1];
//    
//    [url setUrl:@"http://mmsns.qpic.cn/mmsns/bs7qzvQlecibalsmURObdlHE7ozTEHGhKyoOmCE7FiclkZh2WOcfkVYw/0"];
//    
//    [url setEnckey:0];
    
//    [url setEncIdx:-1];
    
//    [url setToken:@""];
    
    [mediaItem setDataUrl:url];
    
    
    NSMutableArray *mediaArray = [[NSMutableArray alloc] init];
    
    [mediaArray addObject:mediaItem];
    
    [contentItem setMediaList:mediaArray];
    
    [dataItem setContentObj:contentItem];
    
    
    [timeLineDatas insertObject:dataItem atIndex:0];
    
    NSLog(@"timeLineDatas end %@", timeLineDatas);
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

static void (*orig_WCTimelineMgr_onDataUpdated_andData)(id self, SEL _cmd, id arg1, NSArray *arg2, id arg3, int arg4);
static void new_WCTimelineMgr_onDataUpdated_andData(id self, SEL _cmd, id arg1, NSArray *arg2, id arg3, int arg4) {
    
    //arg2 是朋友圈列表数据，猜想可以在这位置插入数据
    orig_WCTimelineMgr_onDataUpdated_andData(self, _cmd, arg1, arg2, arg3, arg4);
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
    
    TLH_class_swizzleMethodAndStore(NSClassFromString(@"WCTimelineMgr"), @selector(onDataUpdated:andData:andAdData:withChangedTime:), (IMP)new_WCTimelineMgr_onDataUpdated_andData, (IMP *)&orig_WCTimelineMgr_onDataUpdated_andData);
    
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
