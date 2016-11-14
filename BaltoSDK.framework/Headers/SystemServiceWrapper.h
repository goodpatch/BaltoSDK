//
//  SystemServiceWrapper.h
//  BaltoSDK
//
//  Created by h.terashima on 2016/10/13.
//  Copyright © 2016年 goodpatch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemServiceWrapper : NSObject
+ (unsigned) getFreeMemory;
+ (unsigned) getUsedMemory;
+ (unsigned) getUserCPUTime;
+ (unsigned) getSystemCPUTime;
+ (float) getCPUUsage;
@end
