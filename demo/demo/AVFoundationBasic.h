//
//  AVFoundationBasic.h
//  demo
//
//  Created by lw on 2017/8/12.
//  Copyright © 2017年 lee. All rights reserved.
/*
 1.1.1 捕捉会话
 AV Foundation捕捉栈核心类是AVCaptureSession。一个捕捉会话相当于一个虚拟的“插线板”。用于连接输入和输出的资源
 1.1.2 捕捉设备
 AVCaptureDevice为摄像头、麦克风等物理设备提供接口
 1.1.3 捕捉设备的输入
 注意：为捕捉设备添加输入，不能添加到AVCaptureSession 中，必须通过将它封装到一个AVCaptureDeviceInputs实例中。这个对象在设备输出数据和捕捉会话间扮演接线板的作用
 1.1.4 捕捉的输出
 AVCaptureOutput 是一个抽象类。用于为捕捉会话得到的数据寻找输出的目的地。框架定义了一些抽象类的高级扩展类。例如 AVCaptureStillImageOutput 和 AVCaptureMovieFileOutput类。使用它们来捕捉静态照片、视频。例如 AVCaptureAudioDataOutput 和 AVCaptureVideoDataOutput ,使用它们来直接访问硬件捕捉到的数字样本。
 1.1.5 捕捉连接
 AVCaptureConnection类.捕捉会话先确定由给定捕捉设备输入渲染的媒体类型，并自动建立其到能够接收该媒体类型的捕捉输出端的连接
 1.1.6捕捉预览
 AVCaptureVideoPreviewLayer 可以对捕捉的数据进行实时预览。

 */

#import <Foundation/Foundation.h>

@interface AVFoundationBasic : NSObject

@end
