//
//  SKCaptureCodeView.m
//  SKsinaWeibo
//
//  Created by jiasongkai on 14/6/13.
//  Copyright (c) 2014年 jiasongkai. All rights reserved.
//

#import "SKCaptureCodeView.h"

@interface SKCaptureCodeView () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, copy) void(^content)(BOOL *stop,AVMetadataMachineReadableCodeObject *);
@property (nonatomic, strong)  AVCaptureSession *session;
@property (nonatomic, strong) SKCaptureCodeView *view;


@end


@implementation SKCaptureCodeView
//SKCaptureCodeView *view;
+ (void)startCaptureWithPreView:(UIView *)preView Content:(void (^)(BOOL *, AVMetadataMachineReadableCodeObject *))content
{

   SKCaptureCodeView *view = [[SKCaptureCodeView alloc] init];
    //self.view = self;
    view.content = content;
    AVCaptureDevice *cap = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:cap error:NULL];
    
    if (input == nil) {
        return;
    }
    AVCaptureMetadataOutput *ou = [[AVCaptureMetadataOutput alloc] init];
    
    [ou setMetadataObjectsDelegate:view queue:dispatch_get_main_queue()];
    
    AVCaptureSession *session = [[AVCaptureSession  alloc] init];
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    if ([session canAddOutput:ou]) {
        [session addOutput:ou];
    }
    [ou setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code]];
    
    AVCaptureVideoPreviewLayer *layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    layer.frame = [UIScreen mainScreen].bounds;
    [preView insertSubview:view atIndex:0];
    [preView.layer insertSublayer:layer atIndex:0];
    [session startRunning];
    view.session = session;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        
        AVMetadataMachineReadableCodeObject *ou = metadataObjects.lastObject;
        if (self.content) {
            BOOL stop;
            self.content(&stop,ou);
            if (stop == YES) {
            [self.session stopRunning];
            self.session = nil;
                
            }
        }
    }
    
}
@end
