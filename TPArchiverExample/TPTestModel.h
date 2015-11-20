//
//  TPTestModel.h
//  TPArchiverExample
//
//  Created by abc on 15/11/18.
//  Copyright © 2015年 TP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPTestModel : NSObject
@property (nonatomic , copy) NSString *title;
@property (nonatomic , copy) NSString *overView;
@property (nonatomic , copy) NSString *author;
@property (nonatomic , assign) NSInteger time;
@property (nonatomic , assign) BOOL success;
@end
