//
//  HpsUpaAPI.h
//  Heartland-iOS-SDK
//
//  Created by Desimini, Wilson on 7/1/22.
//

#import <Foundation/Foundation.h>
#import "UpaEnums.h"

@protocol IHPSDeviceMessage;

NS_ASSUME_NONNULL_BEGIN

@interface HpsUpaAPI : NSObject

+ (NSData *)dataFromUPARaw:(NSData *)data;
+ (NSDictionary *)jsonfromUPARaw:(NSData *)data;
+ (UPA_MSG_TYPE)messageTypeFromUPARaw:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
