//
//  XGraphUtil.h
//  iDocBasedApp
//
//  Created by vivi wu on 2019/8/12.
//  Copyright © 2019 vivi wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>
#import <CoreGraphics/CoreGraphics.h>
// Core Graphics框架基于Quartz高级绘图引擎。它提供低级，轻量级2D渲染，具有无与伦比的输出保真度。



#pragma mar - *** PDF ***
//shows how to create a CGPDFDocument object and obtain the number of pages in the document. A detailed explanation for each numbered line of code appears following the listing.
CGPDFDocumentRef XGetPDFDocumentRef (const char *filename);

void XDrawPDFPageInRect (CGContextRef context,
                         CGPDFPageRef page,
                         CGPDFBox box,
                         CGRect rect,
                         int rotation,
                         bool preserveAspectRatio);

void XDisplayPDFPage (CGContextRef XContext,
                      size_t pageNumber,
                      const char *filename);

void XCreatePDFFile (CGContextRef context , CGRect pageRect, const char *filename);




NS_ASSUME_NONNULL_BEGIN

@interface XGraphUtil : NSObject

@end

NS_ASSUME_NONNULL_END
