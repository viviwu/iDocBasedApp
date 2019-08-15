//
//  XAppDelegate.m
//  iDocBasedApp
//
//  Created by vivi wu on 2017/8/10.
//  Copyright © 2017 vivi wu. All rights reserved.
//

#import "XAppDelegate.h"

@interface XAppDelegate ()

@end

@implementation XAppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    if (@available(macOS 10.12.2, *)) {
        NSApplication.sharedApplication.automaticCustomizeTouchBarMenuItemEnabled = YES;
    } else {
        // Fallback on earlier versions
    }
    [self performSelector:@selector(checkOpenDocument) withObject:nil afterDelay:1];
}

- (void)checkOpenDocument{
    // Insert code here to initialize your application
    if ([[NSDocumentController sharedDocumentController] documents].count == 0)
    {
        // open a new document window if there are none open
        [[NSDocumentController sharedDocumentController] newDocument:self];
    }
}
#pragma mark *** Document Creation ***
/*基于文档的应用程序中“文件”菜单的“新建”项的操作。 此方法的默认实现调用-openUntitledDocumentAndDisplay：error：并且，如果返回nil，则在应用程序模式面板中显示错误。
*/
//- (IBAction)newDocument:(nullable id)sender;

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
