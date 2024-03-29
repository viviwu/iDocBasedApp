//
//  XDocument.h
//  iDocBasedApp
//
//  Created by vivi wu on 2017/8/10.
//  Copyright © 2017 vivi wu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString * const xDocUTI;

@class XDocumentViewController;
@class XDocumentWindowController;

@interface XDocument : NSDocument

@property (nonatomic, copy) NSString * text;
@property (nonatomic) XDocumentWindowController * documentWindowController;
@property (nonatomic) XDocumentViewController * documnetViewController;

- (void)updateTextView:(NSTextView *)inTextView;

- (void)updateTextModel:(NSString *)text;

- (NSURL *) generatePDF;

@end

