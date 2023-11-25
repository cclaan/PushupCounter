//
//  DepthChecker.m
//  PushupCounter
//
//  Created by CC Laan on 11/25/23.
//

#import "DepthChecker.h"

@implementation DepthChecker


+ (float) getAverageOfPixelsInRange:(CVPixelBufferRef) depthBuffer
                         minDepth:(float)minDepth
                         maxDepth:(float)maxDepth
                        validPixels:(float*)validPixels
{
    
    CVPixelBufferLockBaseAddress(depthBuffer, kCVPixelBufferLock_ReadOnly);
        
    int w = (int)CVPixelBufferGetWidth(depthBuffer);
    int h = (int)CVPixelBufferGetHeight(depthBuffer);
    
    //printf("w: %5i  h: %5i \n", w, h );
    
    float * depth_in = (float*)CVPixelBufferGetBaseAddress(depthBuffer);
    
    auto num_pixels = w * h;
    
    // w:   640  h:   480
    // Depth: 256 x 192  1024
    
    int pixel_step = 4;
    
    double num_valid = 0;
    
    double avg_depth = 0.0;
    
    //for ( int i = 0; i < num_pixels; i+=pixel_step ) {
    
    int pad_x = w / 3; // just take central window
    int pad_y = h / 3;
    
    for ( int y = pad_y; y < h - pad_y; y ++ ) {
        
        for ( int x = pad_x; x < w - pad_x; x ++ ) {
            
            int ptr = y * h + x;
            float depth = depth_in[ptr];
            
            //float depth = depth_in[i];
            
            if ( depth >= minDepth && depth <= maxDepth ) {
                num_valid += 1.0;
                avg_depth += depth;
            }
            
            
        }
    }
    
    *validPixels = num_valid;
    
    if ( num_valid < 0.001 ) {
        return 0;
    } else {
        return avg_depth / num_valid;
    }
        
}


+ (float) getPercentPixelsInRange:(CVPixelBufferRef) depthBuffer
                         minDepth:(float)minDepth
                         maxDepth:(float)maxDepth
{
    
    CVPixelBufferLockBaseAddress(depthBuffer, kCVPixelBufferLock_ReadOnly);
        
    auto w = CVPixelBufferGetWidth(depthBuffer);
    auto h = CVPixelBufferGetHeight(depthBuffer);
        
    float * depth_in = (float*)CVPixelBufferGetBaseAddress(depthBuffer);
    
    auto num_pixels = w * h;
    
    // Depth: 256 x 192  1024
    
    int pixel_step = 4;
    double pixels_used = 0;
    
    double num_valid = 0;
    
    for ( int i = 0; i < num_pixels; i+=pixel_step ) {
        float depth = depth_in[i];
        if ( depth >= minDepth && depth <= maxDepth ) {
            num_valid += 1.0;
        }
        pixels_used += 1.0;
    }
    
    return num_valid / pixels_used;

    
}


@end
