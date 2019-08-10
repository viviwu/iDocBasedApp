//
//  XDocumentWindowController.m
//  iDocBasedApp
//
//  Created by vivi wu on 2019/8/10.
//  Copyright © 2019 vivi wu. All rights reserved.
//

#import "XDocumentWindowController.h"

@interface XDocumentWindowController () ///</* NSToolbarDelegate */>
@property (weak) IBOutlet NSToolbar *toolbar;

@end

@implementation XDocumentWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    self.shouldCascadeWindows = YES;
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
/*
 可自定义的工具栏（具有代理的工具栏）可以显示一个调色板，允许用户使用单个项目填充工具栏或将工具栏重置为某些默认项目。 调色板中的项目和项目集由委托指定（-toolbarAllowedItemIdentifiers：和-toolbarDefaultItemIdentifiers :)。 当用户完成配置时，他们将关闭调色板。
 */
- (IBAction)menuAction:(NSToolbarItem *)sender {
    NSLog(@"%s", __func__);
    [self.toolbar runCustomizationPalette:sender];
}

@end
