//
//  XDocumentWindowController.h
//  iDocBasedApp
//
//  Created by vivi wu on 2017/8/10.
//  Copyright © 2017 vivi wu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDocumentWindowController : NSWindowController

@end



@interface NSSharingService (ActivityType)

@property (readonly, nonatomic, retain) NSString *activityType;

@end



NS_ASSUME_NONNULL_END
