//
//  SKCaptureCodeView.h
//  SKsinaWeibo
//
//  Created by jiasongkai on 14/6/13.
//  Copyright (c) 2014年 jiasongkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface SKCaptureCodeView : UIView

+ (void)startCaptureWithPreView:(UIView *)preView Content:(void(^)(BOOL *stop,AVMetadataMachineReadableCodeObject *content))content;


@end
