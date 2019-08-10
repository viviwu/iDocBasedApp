//
//  XDocument.m
//  iDocBasedApp
//
//  Created by vivi wu on 2017/8/10.
//  Copyright © 2017 vivi wu. All rights reserved.
//

#import "XDocument.h"
#import "XDocumentViewController.h"
#import "XDocumentWindowController.h"

NSString * const xDocUTI = @"com.vivi.xdoc";

@interface XDocument ()

@end

@implementation XDocument

- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}


+ (BOOL)autosavesInPlace {
    return YES;
}

/*为此文档创建用户界面，但尚未显示。 此方法的默认实现调用[self windowNibName]，使用生成的nib名称创建一个新的窗口控制器（如果它不是nil），将此文档指定为nib文件的所有者，然后调用[self addWindowController：theNewWindowController]来附加 它。 您可以覆盖此方法以使用NSWindowController的自定义子类或立即创建多个窗口控制器。 NSDocumentController在创建或打开新文档时调用此方法。
*/
- (void)makeWindowControllers {
    // Override to return the Storyboard file name of the document.
    if (!_documentWindowController) {
        _documentWindowController = [[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"XDocumentWindowController"];
    }
    [self addWindowController:_documentWindowController];
    
    if (!_documnetViewController) {
        _documnetViewController = (XDocumentViewController *)_documentWindowController.contentViewController;
    }
}

#pragma mark - Accessors
- (XDocumentWindowController *)documentWindowController
{
    if (!_documentWindowController) {
        _documentWindowController = [[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"XDocumentWindowController"];
    }
    return _documentWindowController;
}
- (XDocumentViewController *)documnetViewController
{
    if (!_documnetViewController) {
        _documnetViewController = (XDocumentViewController *)_documentWindowController.contentViewController;
    }
    return _documnetViewController;
}
// -------------------------------------------------------------------------------
//  updateTextView:textView
//
//  Called by our window controller to update our text view after a read operation.
// -------------------------------------------------------------------------------
- (void)updateTextView:(NSTextView *)inTextView
{
    
    // Take our model data and apply it to the textView.
    if (_text != nil) {
        [inTextView replaceCharactersInRange:[self entireRange] withString:_text];
    }
}
// -------------------------------------------------------------------------------
//  updateTextModel:text
//
//  This is called from our NSWindowController when the text has changed.
// -------------------------------------------------------------------------------
- (void)updateTextModel:(NSString *)text
{
    // Remove the text file wrapper, if it exists.
    _text = text;
    // Auto save this change.
    [self updateChangeCount:NSChangeDone];
}
 

#pragma mark - Model Support
// -------------------------------------------------------------------------------
// entireRange
// -------------------------------------------------------------------------------
- (NSRange)entireRange
{
    NSTextView *targetTextView = [self documnetViewController].textView;
    return NSMakeRange(0, targetTextView.string.length);
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    // typeName-->UTI
    NSAssert([typeName isEqualToString:xDocUTI], @"unsupported file:%@\n %@", typeName, *outError);
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error if you return nil.
    // Alternatively, you could remove this method and override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSData * data = [_text dataUsingEncoding:NSUTF8StringEncoding];
//    [NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    return data;
}


- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    //typeName-->UTI
    NSAssert([typeName isEqualToString:xDocUTI], @"unsupported file:%@\n %@", typeName, *outError);
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error if you return NO.
    // Alternatively, you could remove this method and override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you do, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    _text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    [NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    return YES;
}


@end
