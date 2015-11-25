//
//  TPArchiver.h
//  TPArchiverExample
//
//  Created by TangPiece on 15/11/18.
//  Copyright © 2015年 TP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPArchiver : NSObject
/**
 *  调用该类方法将需要归档、解档的类放到数组中传入
 *
 *  @param allArchiverClassArray 所有需要归档、解档功能的类
 */
+ (void)archiverWithAllArchiverClasses:(NSArray<Class> *)allArchiverClassArray;
@end
