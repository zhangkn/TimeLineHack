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

static WCDataItem *newADData();

static void (*orig_TimeLine_reloadTableView)(id self, SEL _cmd);
static void new_TimeLine_reloadTableView(id self, SEL _cmd) {
    
    orig_TimeLine_reloadTableView(self, _cmd);
    
    MMServiceCenter *serviceCenter = [NSClassFromString(@"MMServiceCenter") defaultCenter];
    
    WCFacade *facade = [serviceCenter getService:NSClassFromString(@"WCFacade")];

    NSMutableArray *timeLineDatas = [facade valueForKey:@"m_timelineWithLocalDatas"];
    
    NSLog(@"timeLineDatas begin %@", timeLineDatas);
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
    
    NSLog(@"new_WCFacade_onTimelineDataChangedWithAdded 1 %@, %@, %@", arg1, arg2, arg3);
    
    WCDataItem *dataItem = newADData();
    
    NSString *tid = dataItem.tid;
    
    BOOL isItemAdded = NO;
    
    for (NSString *itemTid in arg3) {
        
        if ([tid isEqualToString:itemTid]) {
            
            isItemAdded = YES;
            
            break;
        }
    }
    
    if (isItemAdded) {
        
        NSMutableArray *deleteArray = [[NSMutableArray alloc] initWithArray:arg3];
        
        [deleteArray removeObject:tid];
        
        arg3 = deleteArray;
        
        NSMutableArray *addArray = [[NSMutableArray alloc] initWithArray:arg1];
        
        [addArray removeObject:tid];
        
        arg1 = addArray;
    }
    
    NSLog(@"new_WCFacade_onTimelineDataChangedWithAdded 2 %@, %@, %@", arg1, arg2, arg3);
    
    return orig_WCFacade_onTimelineDataChangedWithAdded(self, _cmd, arg1, arg2, arg3);
}

static void (*orig_WCFacade_reloadTimelineDataItems)(id self, SEL _cmd);
static void new_WCFacade_reloadTimelineDataItems(id self, SEL _cmd) {
    
    NSLog(@"new_WCFacade_reloadTimelineDataItems");

    orig_WCFacade_reloadTimelineDataItems(self, _cmd);
}

BOOL hasAddAdItem = NO; //已经添加过朋友圈广告
static void (*orig_WCTimelineMgr_onDataUpdated_andData)(id self, SEL _cmd, id arg1, NSArray *arg2, id arg3, int arg4);
static void new_WCTimelineMgr_onDataUpdated_andData(id self, SEL _cmd, id arg1, NSArray *arg2, id arg3, int arg4) {
    
//    if (!hasAddAdItem) {
    
        if ([arg2 count] > 0) {
    
            WCDataItem *dataItem = newADData();
            
            NSString *tid = dataItem.tid;
            
            BOOL needAdd = YES;
            
            for (WCDataItem *item in arg2) {
                
                if ([tid isEqualToString:item.tid]) {
                    
                    needAdd = NO;
                    
                    break;
                }
            }
            
            if (needAdd) {
                
                NSMutableArray *timeLineData = [[NSMutableArray alloc] initWithArray:arg2];
                
                [timeLineData insertObject:newADData() atIndex:0];
                
                hasAddAdItem = YES;
                
                arg2 = (NSArray *)timeLineData;
            }
        }
//    }
    

    
    //arg2 是朋友圈列表数据，猜想可以在这位置插入数据
    orig_WCTimelineMgr_onDataUpdated_andData(self, _cmd, arg1, arg2, arg3, arg4);
}

static WCDataItem *newADData() {
    
    MMServiceCenter *serviceCenter = [NSClassFromString(@"MMServiceCenter") defaultCenter];
    
    WCFacade *facade = [serviceCenter getService:NSClassFromString(@"WCFacade")];

    WCDataItem *dataItem = [[NSClassFromString(@"WCDataItem") alloc] init];
    
    //广告信息
    WCAdvertiseInfo *advertiseInfo = [[NSClassFromString(@"WCAdvertiseInfo") alloc] init];
    
        [advertiseInfo setAdActionLinkHidden:NO]; //是否隐藏链接
    
        [advertiseInfo setAttachShareLinkHidden:NO];
    
    [advertiseInfo setSessionAid:@"1600006312"];
    
    [advertiseInfo setTraceId:@"wx0y7ek22zqh7boi"];
    
    //广告画布
    //    WCADCanvasInfo *canvasInfo = [[NSClassFromString(@"WCADCanvasInfo") alloc] init];
    //
    //    [advertiseInfo setAdCanvasInfo:canvasInfo];
    
    
    
    [advertiseInfo setAdActionAppStoreType:0];
    
    [advertiseInfo setAdActionLinkWithTraceId:@"http://www.baidu.com"];
    
    
    NSMutableDictionary *adArgsDic = [[NSMutableDictionary alloc] initWithDictionary:@{@"classify_en" : @"appliance",
                                                                                       @"classify_zh_TW" : @"下载游戏",
                                                                                       @"classify_zh_CN" : @"下载游戏"                                                        }];
    
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
    
    
    
    //    adActionLinkName 链接字样
    
    [advertiseInfo setAdUserNickName:@"瞎鸡巴写"]; //链接标题
    
    [advertiseInfo setWebviewRightBarShow:YES];
    
    [advertiseInfo setExposureNoActionExpireTime:660];
    
    [advertiseInfo setNoExposureExpireTime:660];
    
    [advertiseInfo setBExposured:YES];
    
    [advertiseInfo setAdPosition:4];
    
    [advertiseInfo setAdViewId:@"6X9Bvd1FVd7vP1aQCItCC/6UEmDQEcGfnpZZDAqsfMBSU9Xa2Xwm2K0C45/haYeeVNwfIHT7uQ/PCfJDFJ5YDxbmH0Jjxwn74H9Tkq0Kl5EqhxgOod/RLWyxSUd6gA9bvQUpO47JodAuU8QevhN6QhJfh9k/v4f6P0GAo3e4jD%2BaOvNb%2BW3pHoN/Ye9D1tWFVm0pESIMHpcuFgdVSJXPv/wSzdXT9AS6WMB7ENaU7TMa4sp7FK1xmqDhWp3L9M0K3FGlXFAUx%2B8ZXC9wIK66maJjdHdBsgyRfJs87%2BII7gE3ZMs9QJ6VYXxhbWl7Sh8PjuPkm2EN%2B53fAQhvRsFMjjFAl6Sw8FoQ3ymgz7s22S3bMyhqex%2B5VhfSMjNes9dOO1XNOhYzP74tI2iF111%2BE3S6VdsBsOJSfdtvu33B%2B2ZAv5dliviVcI/Lbo24OwGFYUeue3GwzR%2BqrI4dx3DzjiKb7XqevpLALGEf%2B8tgRPpyNmkRjPSgTTJyOpCCN49LvfAyLI2Y%2BueBRlS2zDrYytXV%2BLELiYDydHBVXlr12oPU4ABG1CqnrkIBFZE67RDICjGAcxmsmFlZeCZ2zEQi4Fpysfb6p/swj769ysRGKN56lPem8pW/hLMEAwKUkNmEa//Qa/%2BZNmHMTphH8a7Rgj0TKiEv7T1IEEU2dqsqxlebpXdCplKEhbNFPecQpXjFeQ/0uCM/kqdRehbRIRrZTfxOCIupdv7NR2/rb1we7z2UOSgQlWW4W73jVoDeiJtaWVXNvhgWscmaSVK9B6wKlr97YzVBBGzk"];
    
    [advertiseInfo setAdActionType:0];
    
    [advertiseInfo setAdActionLink:@"https://www.baidu.com"];
    
    [advertiseInfo setAdDescription:@"这又是啥"];
    
    [advertiseInfo setAdType:0];
    
    [dataItem setAdvertiseInfo:advertiseInfo];
    
    
    
    [dataItem setUsername:@"gh_69738dd30c9f"];
    
    [dataItem setNickname:@""];
    
    [dataItem setFlag:0];
    
    [dataItem setType:0];
    
    [dataItem setCid:0];
    
    [dataItem setContentDesc:@"只是个测试\n测测测测测"];
    
    [dataItem setSightFolded:0];
    
    [dataItem setStatExtStr:@"CncIARIUMTI0NDkxMzI0MDczMjUwNzExODIaKTE2MDAwMDYzMTJ8d3gweTdlazIyenFoN2JvaXx8MXwxNDg0NjE0Njk0IAAqMHNuc0lkPTEyNDQ5MTMyNDA3MzI1MDcxMTgyJmFkZ3JvdXBfaWQ9MTYwMDAwNjMxMg=="];
    
    [dataItem setSelfCommentCount:0];
    
    [dataItem setSelfLikeCount:0];
    
    [dataItem setRealLikeCount:0];
    
    [dataItem setRealCommentCount:0];
    
    [dataItem setIsLikeUsersUnsafe:0];
    
    [dataItem setIsContentUnsafe:0];
    
    [dataItem setCpKeyForLikeUsers:@"wctlls|gh_69738dd30c9f|12449132407325071182"];
    
    
    
    WCObjectOperation *objectOperation = [[NSClassFromString(@"WCObjectOperation") alloc] init];
    
    [objectOperation setSnsOperateFlag:2];
    
    [dataItem setObjOperation:objectOperation];
    
    [dataItem setExtFlag:1];

    [dataItem setContentDescPattern:@"<parser><type>1</type><range>{0, 12}</range></parser>"];
    
    NSMutableDictionary *extDataDic = [[NSMutableDictionary alloc] initWithDictionary:@{@"contentDescPattern" : [dataItem contentDescPattern]}];
    
    [dataItem setExtData:extDataDic];
    
    NSMutableArray *shareGroupArray = [[NSMutableArray alloc] init];
    
    [dataItem setSharedGroupIDs:shareGroupArray];
    
    [dataItem setContentDescScene:3];
    
    [dataItem setContentDescShowType:0];
    
    
    
    MMNewSessionMgr *newSessionMgr = [serviceCenter getService:objc_getClass("MMNewSessionMgr")];
    
    unsigned int time = [newSessionMgr GenSendMsgTime];
    
    NSLog(@"GenSendMsgTime %d", time);
    
    [dataItem setCreateTime:1486536809];
    
    [dataItem setTid:@"12451152990729023630"];
    
    WCContentItem *contentItem = [[NSClassFromString(@"WCContentItem") alloc] init];
    
    [contentItem setUsername:@"gh_69738dd30c9f"];
    
    [contentItem setType:1];  //1为图  15为小视频
    
    [contentItem setFlag:0];
    
    [contentItem setCreatetime:time];
    
    [contentItem setDesc:@""];
    
    [contentItem setTitle:@""];
    
    
    
    WCMediaItem *mediaItem = [[NSClassFromString(@"WCMediaItem") alloc] init];
    
    [mediaItem setType:1];
    
    [mediaItem setCreateTime:time];
    
    [mediaItem setSubType:0];
    
    [mediaItem setEntrance:1];
    
    [mediaItem setIsAd:YES];
    
    [mediaItem setXorEncrpyKey:0];
    
    [mediaItem setBUseXorEncrypt:NO];
    
    [mediaItem setBSupoortValidateMd5:NO];
    
    [mediaItem setBSnsScene:YES];
    
    [mediaItem setAttachVideoTotalTime:34];// 视频时长？
    
    [mediaItem setImgSize:CGSizeMake(640, 480)];
    
    [mediaItem setAttachShareTitle:@"什么鬼"];
    
    
    
    WCUrl *url = [NSClassFromString(@"WCUrl") UrlWithUrl:@"http://mmsns.qpic.cn/mmsns/bs7qzvQlecibalsmURObdlHE7ozTEHGhKyoOmCE7FiclkZh2WOcfkVYw/0" type:1];
    
    //    [url setType:1];
    //
    //    [url setUrl:@"http://mmsns.qpic.cn/mmsns/bs7qzvQlecibalsmURObdlHE7ozTEHGhKyoOmCE7FiclkZh2WOcfkVYw/0"];
    //
    //    [url setEnckey:0];
    
    //    [url setEncIdx:-1];
    
    //    [url setToken:@""];
    
    [mediaItem setDataUrl:url];
    
    //    attachThumbUrl   attachUrl 视频时需要用到
    
    NSMutableArray *previewUrls = [[NSMutableArray alloc] initWithObjects:url, nil];
    
    [mediaItem setPreviewUrls:previewUrls];
    
    [mediaItem setUserData:@""];
    
    [mediaItem setTitle:@""];
    
    [mediaItem setDesc:@""];
    
    [mediaItem setSubType:0];
    
    //    [mediaItem setType:5];
    
    [mediaItem setMid:@"12454827411965613937"];
    
    [mediaItem setTid:@"12451152990729023630"];

    NSMutableArray *mediaArray = [[NSMutableArray alloc] init];
    
    [mediaArray addObject:mediaItem];
    
    [contentItem setMediaList:mediaArray];
    
    [dataItem setContentObj:contentItem];

    
    return dataItem;
}

static int TLHMian() __attribute__ ((constructor)) {
    /*
     **  刷新时插入
     */
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
