//
//  Swizzle.h
//  ChangeWeiXin
//
//  Created by Jay on 16/8/23.
//
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef IMP *IMPPointer;

@interface TLHSwizzle : NSObject

@end

BOOL class_swizzleMethodAndStore(Class class, SEL original, IMP replacement, IMPPointer store);

BOOL class_addSwizzleMethod(Class origClass, SEL origMethod, Class newClass, SEL newMethod);//实例方法

BOOL class_addSwizzleMethod2(Class origClass, SEL origMethod, Class newClass, SEL newMethod);//静态方法
