//
//  DepthChecker.h
//  PushupCounter
//
//  Created by CC Laan on 11/25/23.
//


#import <Foundation/Foundation.h>
#include <AVFoundation/AVFoundation.h>
#import <CoreVideo/CoreVideo.h>
#import <Accelerate/Accelerate.h>


NS_ASSUME_NONNULL_BEGIN

@interface DepthChecker : NSObject

+ (float) getAverageOfPixelsInRange:(CVPixelBufferRef) depthData
                         minDepth:(float)minDepth
                         maxDepth:(float)maxDepth
                        validPixels:(float*)validPixels;


+ (float) getPercentPixelsInRange:(CVPixelBufferRef) depthData
                         minDepth:(float)minDepth
                         maxDepth:(float)maxDepth;

@end

NS_ASSUME_NONNULL_END
