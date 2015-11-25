//
//  TPArchiver.m
//  TPArchiverExample
//
//  Created by TangPiece on 15/11/18.
//  Copyright © 2015年 TP. All rights reserved.
//

#import "TPArchiver.h"
#import <objc/runtime.h>

@interface TPArchiver ()
@property (nonatomic , copy) NSArray *allEncoderClasses;
@end

@implementation TPArchiver

+ (void)archiverWithAllArchiverClasses:(NSArray<Class> *)allArchiverClassArray{
    [[self alloc] archiverWithAllArchiverClasses:allArchiverClassArray];
}

- (void)archiverWithAllArchiverClasses:(NSArray<Class> *)allArchiverClassArray{
    self.allEncoderClasses = allArchiverClassArray;
}

#pragma mark - private methods

/**
 *  利用Runtime为需要归档的对象动态添加encodeWithCoder:方法
 *
 *  @param obj    调用归档的对象
 *  @param _cmd   归档方法名
 *  @param aCoder 归档参数
 */
void tp_encoderWithCoder(id obj , SEL _cmd , NSCoder *aCoder){
    NSArray *propertyNames = [TPArchiver getAllPropertyNamesWithClass:[obj class]];
    for (NSString *name in propertyNames) {
        [aCoder encodeObject:[obj valueForKey:name] forKey:name];
    }
}

/**
 *  利用Runtime为需要解档的对象动态添加initWithCoder:方法
 *
 *  @param obj    调用解档的对象
 *  @param _cmd   解档方法名
 *  @param aDecoder 解档参数
 */
id tp_initWithCoder(id obj , SEL _cmd , NSCoder *aDecoder) {
    NSArray *propertyNames = [TPArchiver getAllPropertyNamesWithClass:[obj class]];
    obj = [obj init];
    for (NSString *name in propertyNames) {
        id value = [aDecoder decodeObjectForKey:name];
        [obj setValue:value forKey:name];
    }
    return obj;
}

#pragma mark - private methods

/**
 * 使用Runtime获取对象所有属性
 */
+ (NSArray *)getAllPropertyNamesWithClass:(Class)objClass{
    NSMutableArray *tempArray = [NSMutableArray array];
    //存储属性的个数
    unsigned int propertyCount = 0;
    //通过运行时获取当前类的属性
    objc_property_t *propertys = class_copyPropertyList(objClass , &propertyCount);
    for (int i = 0 ; i < propertyCount ; i++ ) {
        objc_property_t property = propertys[i];
        const char *propertyName = property_getName(property);
        [tempArray addObject:[NSString stringWithUTF8String:propertyName]];
    }
    return tempArray;
}

#pragma mark - setter方法

- (void)setAllEncoderClasses:(NSArray<Class> *)allEncoderClasses{
    _allEncoderClasses = [allEncoderClasses copy];
    for (Class encoderClass in _allEncoderClasses) {
        //用runtime给传入的需要归档的类添加归档功能encodeWithCoder:
        class_addMethod(encoderClass ,
                        @selector(encodeWithCoder:),
                        (IMP)tp_encoderWithCoder ,
                        "v@:@");
        
        //用runtime给传入的需要解档的类添加归档功能initWithCoder:
        class_addMethod(encoderClass ,
                        @selector(initWithCoder:),
                        (IMP)tp_initWithCoder,
                        "@@:@");
    }
}

@end
