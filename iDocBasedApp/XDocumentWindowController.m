//
//  XDocumentWindowController.m
//  iDocBasedApp
//
//  Created by vivi wu on 2017/8/10.
//  Copyright © 2017 vivi wu. All rights reserved.
//

#import "XDocumentWindowController.h"
#import "XDocumentViewController.h"
#import <Quartz/Quartz.h>       // PDF
#import "XDocument.h"

#define  TouchBarItemID_popover         @"com.vivi.TouchBarItem.popover"
#define  TouchBarItemID_fontStyle       @"com.vivi.TouchBarItem.fontStyle"
#define  TouchBarItemID_popoverSlider   @"com.vivi.popoverBar.slider"
#define  TouchBarItemID_menu            @"com.vivi.ToolBarItem.menu"
#define  TouchBarItemID_export          @"com.vivi.ToolBarItem.export"

@interface XDocumentWindowController () <NSTouchBarDelegate , NSToolbarDelegate , NSSharingServicePickerDelegate, NSSharingServiceDelegate>

@property (weak) IBOutlet NSToolbar *toolbar;

@property PDFDocument        *pdfDoc;

@end

@implementation XDocumentWindowController

- (nullable instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        NSLog(@"%s", __func__);
    }
    return self;
}


- (void)windowDidLoad {
    [super windowDidLoad];
    self.shouldCascadeWindows = YES;
    
    self.toolbar.allowsUserCustomization = true;
    self.toolbar.autosavesConfiguration = true;
    self.toolbar.displayMode = NSToolbarDisplayModeIconOnly;
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    NSLog(@"%s", __func__);
    if (_pdfDoc) {
        // Create PDFDocument.
        _pdfDoc = [[PDFDocument alloc] initWithURL:[[self document] fileURL]];
    }
}

- (XDocumentViewController *)viewController{
    return (XDocumentViewController *)self.contentViewController;
}

- (void) printDocument: (id) sender
{
    NSPrintOperation * printOperation = [NSPrintOperation printOperationWithView:self.viewController.textView];
    [printOperation runOperationModalForWindow:self.window delegate:nil didRunSelector:nil contextInfo:nil];
}


- (nullable NSTouchBar *)makeTouchBar NS_AVAILABLE_MAC(10_12_2)
{
    NSTouchBar * touchBar = [[NSTouchBar alloc]init];
    touchBar.delegate = self;
    touchBar.customizationIdentifier = TouchBarItemID_popover;
    touchBar.defaultItemIdentifiers = @[TouchBarItemID_fontStyle, TouchBarItemID_popover, NSTouchBarItemIdentifierOtherItemsProxy];
    touchBar.customizationAllowedItemIdentifiers = @[TouchBarItemID_fontStyle, TouchBarItemID_popover];
    return touchBar;
}

#pragma mark -- NSTouchBarDelegate
/*
 When constructing the items array, this delegate method will be invoked to construct an NSTouchBarItem if that item cannot be found in the `templateItems` set.
 */
- (nullable NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier
API_AVAILABLE(macos(10.12.2)){
    NSLog(@"makeItemForIdentifier: %@", identifier);
    if ([identifier isEqualToString:TouchBarItemID_popover]) {
        NSPopoverTouchBarItem * popoverItem = [[NSPopoverTouchBarItem alloc]initWithIdentifier:identifier];
        return popoverItem;
    }else if ([identifier isEqualToString:TouchBarItemID_fontStyle]) {
//        NSTouchBarItem
    }else if ([identifier isEqualToString:TouchBarItemID_popoverSlider]) {
        //        NSTouchBarItem
    }else if ([identifier isEqualToString:TouchBarItemID_menu]) {
        
    }else if ([identifier isEqualToString:TouchBarItemID_export]) {
        
    }else {
        return nil;
    }//
    return nil;
}


/*
 可自定义的工具栏（具有代理的工具栏）可以显示一个调色板，允许用户使用单个项目填充工具栏或将工具栏重置为某些默认项目。 调色板中的项目和项目集由委托指定（-toolbarAllowedItemIdentifiers：和-toolbarDefaultItemIdentifiers :)。 当用户完成配置时，他们将关闭调色板。
 */
- (IBAction)menuAction:(NSToolbarItem *)sender {
    NSLog(@"%s", __func__);
    //    [self.toolbar runCustomizationPalette:sender];
}

- (IBAction)exportAction:(NSToolbarItem *)sender {

    NSURL * pdfUrl = ((XDocument *)self.document).generatePDF;
    if (!pdfUrl)  return;
    
    NSSharingServicePicker *sharingServicePicker = [[NSSharingServicePicker alloc] initWithItems:@[pdfUrl]];
    sharingServicePicker.delegate = self;
    
    CGFloat pickerW = 150;
    CGFloat pickerH = 250;
    
    NSWindow * logicalWindow = [sender.toolbar valueForKey:@"logicalWindow"];
    NSView * toolbarView = [sender.toolbar valueForKey:@"toolbarView"];
    CGFloat toolbarH = toolbarView ? toolbarView.superview.frame.size.height : 120;
    
    CGRect rect = logicalWindow ? logicalWindow.frame :CGRectZero;
    rect.origin = NSMakePoint(rect.size.width-pickerW, rect.size.height-pickerH - toolbarH);
    rect.size = NSMakeSize(pickerW, pickerH);
    
    [sharingServicePicker showRelativeToRect:rect
                                      ofView:logicalWindow.contentView
                               preferredEdge:NSMinXEdge];
}


#pragma mark - NSSharingServicePickerDelegate

- (id <NSSharingServiceDelegate>)sharingServicePicker:(NSSharingServicePicker *)sharingServicePicker delegateForSharingService:(NSSharingService *)sharingService
{
    return self;
}

#pragma mark - NSSharingServiceDelegate


- (void)sharingService:(NSSharingService *)sharingService didFailToShareItems:(NSArray *)items error:(NSError *)error
{
    [NSAlert alertWithError:error];
}

- (void)sharingService:(NSSharingService *)sharingService didShareItems:(NSArray *)items
{
    BOOL isReadingList = [sharingService.description rangeOfString:NSSharingServiceNameAddToSafariReadingList].location != NSNotFound;
    NSLog(@"isReadingList range: %d", isReadingList);
    NSLog(@"act: %@", [sharingService activityType]);
    isReadingList = [[sharingService activityType] isEqualToString:NSSharingServiceNameAddToSafariReadingList];
    NSLog(@"isReadingList iequa: %d", isReadingList);
    isReadingList = [@[NSSharingServiceNameAddToSafariReadingList, NSSharingServiceNameAddToIPhoto] containsObject:[sharingService activityType]];
    NSLog(@"isReadingList conta: %d", isReadingList);
}
@end

@implementation NSSharingService (ActivityType)

- (NSString*)activityType
{
    NSRange range = [self.description rangeOfString:@"\\[com.apple.share.*\\]" options:NSRegularExpressionSearch];
    range.location++; // Start after [
    range.length -= 2; // Remove both [ and ]
    return [self.description substringWithRange:range];
}

@end
