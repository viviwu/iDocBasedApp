//
//  XGraphUtil.m
//  iDocBasedApp
//
//  Created by vivi wu on 2019/8/12.
//  Copyright © 2019 vivi wu. All rights reserved.
//

#import "XGraphUtil.h"

@implementation XGraphUtil

@end


#pragma mar - *** PDF ***

CGPDFDocumentRef XGetPDFDocumentRef (const char *filename)
{
    CFStringRef path;
    CFURLRef url;
    CGPDFDocumentRef document;
    size_t count;
    
    path = CFStringCreateWithCString (NULL, filename,
                                      kCFStringEncodingUTF8);
    url = CFURLCreateWithFileSystemPath (NULL, path, // 1
                                         kCFURLPOSIXPathStyle, 0);
    CFRelease (path);
    document = CGPDFDocumentCreateWithURL (url);// 2
    CFRelease(url);
    count = CGPDFDocumentGetNumberOfPages (document);// 3
    if (count == 0) {
        printf("`%s' needs at least one page!", filename);
        return NULL;
    }
    return document;
}

void XDrawPDFPageInRect (CGContextRef context,
                         CGPDFPageRef page,
                         CGPDFBox box,
                         CGRect rect,
                         int rotation,
                         bool preserveAspectRatio)
{
    CGAffineTransform m;
    
    m = CGPDFPageGetDrawingTransform (page, box, rect, rotation,// 1
                                      preserveAspectRatio);
    CGContextSaveGState (context);// 2
    CGContextConcatCTM (context, m);// 3
    CGContextClipToRect (context,CGPDFPageGetBoxRect (page, box));// 4
    CGContextDrawPDFPage (context, page);// 5
    CGContextRestoreGState (context);// 6
}

void XDisplayPDFPage (CGContextRef XContext,
                      size_t pageNumber,
                      const char *filename)
{
    CGPDFDocumentRef document;
    CGPDFPageRef page;
    
    document = XGetPDFDocumentRef (filename);// 1
    page = CGPDFDocumentGetPage (document, pageNumber);// 2
    CGContextDrawPDFPage (XContext, page);// 3
    CGPDFDocumentRelease (document);// 4
}



void XCreatePDFFile (CGContextRef context , CGRect pageRect, const char *filename)// 1
{
    CGContextRef pdfContext;
    CFStringRef path;
    CFURLRef url;
    CFDataRef boxData = NULL;
    CFMutableDictionaryRef auxiliaryInfo = NULL;
    CFMutableDictionaryRef pageDictionary = NULL;
    
    path = CFStringCreateWithCString (NULL, filename, kCFStringEncodingUTF8);
    url = CFURLCreateWithFileSystemPath (NULL, path, kCFURLPOSIXPathStyle, 0);
    CFRelease (path);
    auxiliaryInfo = CFDictionaryCreateMutable(NULL, 0,
                                            &kCFTypeDictionaryKeyCallBacks,
                                            &kCFTypeDictionaryValueCallBacks); // 4
    CFDictionarySetValue(auxiliaryInfo, kCGPDFContextTitle, CFSTR("X PDF File"));
    CFDictionarySetValue(auxiliaryInfo, kCGPDFContextCreator, CFSTR("X Name"));
    pdfContext = CGPDFContextCreateWithURL (url, &pageRect, auxiliaryInfo); // 5
    CFRelease(auxiliaryInfo);
    CFRelease(url);
    pageDictionary = CFDictionaryCreateMutable(NULL, 0,
                                               &kCFTypeDictionaryKeyCallBacks,
                                               &kCFTypeDictionaryValueCallBacks); // 6
    boxData = CFDataCreate(NULL,(const UInt8 *)&pageRect, sizeof (CGRect));
    CFDictionarySetValue(pageDictionary, kCGPDFContextMediaBox, boxData);
    CGPDFContextBeginPage (pdfContext, pageDictionary); // 7
    //    XDrawContent (pdfContext);// 8
    CGPDFContextEndPage (pdfContext);// 9
    CGContextRelease (pdfContext);// 10
    CFRelease(pageDictionary); // 11
    CFRelease(boxData);
}

