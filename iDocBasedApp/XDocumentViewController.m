//
//  XDocumentViewController.m
//  iDocBasedApp
//
//  Created by vivi wu on 2017/8/10.
//  Copyright © 2017 vivi wu. All rights reserved.
//

#import "XDocumentViewController.h"
#import "XDocumentWindowController.h"
#import "XDocument.h"

@interface XDocumentViewController ()<NSTextViewDelegate>


@end

@implementation XDocumentViewController

- (XDocument *)ourDocument
{
    XDocumentWindowController *windowController = (XDocumentWindowController *)self.view.window.windowController;
    return windowController.document;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.textView.delegate = self;
    [self.textView setAllowsUndo:YES];
}

- (void)viewWillAppear
{
    [super viewWillAppear];
    XDocument *document = [self ourDocument];
    if (document != nil) {
        // Ask our document to update our text view and image view with it's model.
        [document updateTextView:self.textView];
    }
    
    // Initially key focus on the text view.
    [self.view.window makeFirstResponder:self.textView];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


#pragma mark - NSTextDelegate

// -------------------------------------------------------------------------------
//  textDidChange:aNotification
//
//  The text view content had changed, update our data model.
// -------------------------------------------------------------------------------
- (void)textDidChange:(NSNotification *)aNotification
{
    XDocument *document = [self ourDocument];
    NSString *str = self.textView.textStorage.string;
    [document updateTextModel:str];
}

@end
