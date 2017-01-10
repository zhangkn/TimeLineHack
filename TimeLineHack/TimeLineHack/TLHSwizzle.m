//
//  Swizzle.m
//  ChangeWeiXin
//
//  Created by Jay on 16/8/23.
//
//

#import "TLHSwizzle.h"

typedef IMP *IMPPointer;

@implementation TLHSwizzle

@end

BOOL class_swizzleMethodAndStore(Class class, SEL original, IMP replacement, IMPPointer store) {
    IMP imp = NULL;
    Method method = class_getInstanceMethod(class, original);
    if (method) {
        const char *type = method_getTypeEncoding(method);
        imp = class_replaceMethod(class, original, replacement, type);
        if (!imp) {
            imp = method_getImplementation(method);
        }
    }
    if (imp && store) { *store = imp; }
    return (imp != NULL);
    
} //http://blog.csdn.net/yiyaaixuexi/article/details/9374411 比较完美方法

BOOL class_addSwizzleMethod(Class origClass, SEL origMethod, Class newClass, SEL newMethod) {
    
    //实例方法
    Method ori_Method =  class_getInstanceMethod(origClass, origMethod);
    Method my_Method = class_getInstanceMethod(newClass, newMethod);
    
    if(class_addMethod(origClass, origMethod, method_getImplementation(my_Method),
                       method_getTypeEncoding(my_Method)))
    {

        
        class_replaceMethod(newClass, newMethod, method_getImplementation(ori_Method), method_getTypeEncoding(ori_Method));
        
        //为什么要调用两次
//        objc_getClass
//        
//        object_getClass
        
    } else {
        
        
        
        method_exchangeImplementations(ori_Method, my_Method);
        
    } //非完美方法
}

BOOL class_addSwizzleMethod2(Class origClass, SEL origMethod, Class newClass, SEL newMethod) {
    
    //静态方法
    Method ori_Method =  class_getClassMethod(origClass, origMethod);
    Method my_Method = class_getInstanceMethod(newClass, newMethod);
    
    if(class_addMethod(origClass, origMethod, method_getImplementation(my_Method),
                       method_getTypeEncoding(my_Method)))
    {
        
        class_replaceMethod(newClass, newMethod, method_getImplementation(ori_Method), method_getTypeEncoding(ori_Method));
        
    } else {
        
        method_exchangeImplementations(ori_Method, my_Method);
        
    } //非完美方法
}
