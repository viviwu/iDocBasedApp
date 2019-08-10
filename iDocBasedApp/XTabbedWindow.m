//
//  XTabbedWindow.m
//  iDocBasedApp
//
//  Created by vivi wu on 2017/8/10.
//  Copyright © 2017 vivi wu. All rights reserved.
//

#import "XTabbedWindow.h"
#import "XDocumentWindowController.h"
#import "XDocument.h"

@implementation XTabbedWindow

BOOL didAddMenuItem;

- (void)awakeFromNib
{
    [self toggleTabBar:self];
    
    self.title = [[NSUUID UUID] UUIDString];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidStartTracking:) name:@"NSMenuDidBeginTrackingNotification" object:nil];
}

- (IBAction)newWindowForTab:(id)sender
{
    NSDocumentController * documentController = NSDocumentController.sharedDocumentController;
    NSLog(@"documents.count == %lu", (unsigned long)documentController.documents.count);
    NSError * error = nil;
    XDocument * newdoc = [documentController makeUntitledDocumentOfType:xDocUTI error: &error];
    if (error) {
        NSLog(@"error: %@", error); return;
    }
    [documentController addDocument:newdoc];
    
    XDocumentWindowController* tabbedWindowController = [[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"XDocumentWindowController"];
    newdoc.documentWindowController = tabbedWindowController;
    //[newdoc setWindow:tabbedWindowController.window];
    tabbedWindowController.document = newdoc;
    [newdoc makeWindowControllers];
    
    [self addTabbedWindow:tabbedWindowController.window ordered:NSWindowAbove];
    
    [tabbedWindowController.window makeKeyAndOrderFront:nil];
}

- (void)menuDidStartTracking:(NSNotification*)sender
{
    if(didAddMenuItem)
        return;
    
    NSMenu *tabMenu = (NSMenu *)sender.object;
    
    NSMenuItem *myMenuItem = [[NSMenuItem alloc] initWithTitle:@"My cool item" action:@selector(MenuItemAction:) keyEquivalent:@""];
    
    NSMenuItem *anotherItem = [tabMenu itemAtIndex:0];
    myMenuItem.target = anotherItem.target;
    
    [tabMenu addItem:myMenuItem];
    
    didAddMenuItem = YES;
}

- (void)MenuItemAction:(id)sender
{
    NSLog(@"You clicked on the tab for: %@", self.title);
}




@end
