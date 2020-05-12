//
//  FaceRecognitionView.swift
//  tdces
//
//  Created by Str1ng on 2019/10/22.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

@IBDesignable
class FaceRecognitionView: UIView {
    /// 摄像头授权状态
    var cameraAuthStatus: AVAuthorizationStatus!
    /// 预览Layer
    var captureVideoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    /// Session
    var session: AVCaptureSession!
    
    /// 硬件Input
    var captureInput:AVCaptureDeviceInput!
    
    /// 数据Output
    var captureOutput:AVCaptureVideoDataOutput!
    
    @IBOutlet weak var  customImgView: UIImageView!
    @IBOutlet weak var labUserName:UILabel!
    
    @IBOutlet weak var btnStartRecognition:UIButton!
    var btnStartRecognitionCallBack:(()->())?
    //初始化默认属性配置
    func initialSetup(){
        checkVideoAuth()
        labUserName.text = staff?.name!
    }
    var contentView:UIView!
    
    //初始化时将xib中的view添加进来
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = loadViewFromNib()
        addSubview(contentView)
        addConstraints()
        //初始化属性配置
        initialSetup()
    }
    
    @IBAction func btnStartRecognitionAction(_ sender: UIButton) {
        if btnStartRecognition != nil {
            btnStartRecognitionCallBack!()
        }
    }
    
    //初始化时将xib中的view添加进来
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView = loadViewFromNib()
        addSubview(contentView)
        addConstraints()
        //初始化属性配置
        initialSetup()
    }
    //加载xib
    func loadViewFromNib() -> UIView {
        let className = type(of: self)
        let bundle = Bundle.init(for: className)
        let name =  NSStringFromClass(className).components(separatedBy: ".").last
        let nib = UINib(nibName: name!, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }

    
    //设置好xib视图约束
    func addConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        var constraint = NSLayoutConstraint(item: contentView as Any, attribute: .leading,
                                            relatedBy: .equal, toItem: self, attribute: .leading,
                                            multiplier: 1, constant: 0)
        addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView as Any, attribute: .trailing,
                                        relatedBy: .equal, toItem: self, attribute: .trailing,
                                        multiplier: 1, constant: 0)
        addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView as Any, attribute: .top, relatedBy: .equal,
                                        toItem: self, attribute: .top, multiplier: 1, constant: 0)
        addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView as Any, attribute: .bottom,
                                        relatedBy: .equal, toItem: self, attribute: .bottom,
                                        multiplier: 1, constant: 0)
        addConstraint(constraint)
    }
}

extension FaceRecognitionView{
    /**
     数据流BufferRef转Image
     
     - parameter sampleBuffer: 数据流
     
     - returns: UIImage
     */
    func getImageData(sampleBuffer:CMSampleBuffer!)-> UIImage {
        
        let imageBuffer:CVImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        CVPixelBufferLockBaseAddress(imageBuffer, [])
        
        let bytesPerRow:size_t = CVPixelBufferGetBytesPerRow(imageBuffer)
        let width:size_t  = CVPixelBufferGetWidth(imageBuffer)
        let height:size_t = CVPixelBufferGetHeight(imageBuffer)
        
        
        let safepoint:UnsafeMutableRawPointer = CVPixelBufferGetBaseAddress(imageBuffer)!
        
        let bitMapInfo:UInt32 = CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue
        
        //RGB
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let context:CGContext = CGContext(data: safepoint, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitMapInfo)!
        
        let quartImage: CGImage = context.makeImage()!
        CVPixelBufferUnlockBaseAddress(imageBuffer, [])
        
        return UIImage(cgImage: quartImage, scale: 1, orientation: UIImage.Orientation.right)
    }
    
    /**
     跳转至设置
     */
    func openSettings() {
        DispatchQueue.main.async {
            let settingsURL:NSURL = NSURL(string:UIApplication.openSettingsURLString)!
            UIApplication.shared.open(settingsURL as URL, options: [UIApplication.OpenExternalURLOptionsKey : Any].init(), completionHandler: nil)
        }
        
    }
    
    /**
     Check video authorization status
     */
    func checkVideoAuth() {
        
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        {
        case AVAuthorizationStatus.authorized://已经授权
            self.cameraAuthStatus = AVAuthorizationStatus.authorized
            break
        case AVAuthorizationStatus.notDetermined:
            
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                
                if(granted){
                    //受限制
                    self.cameraAuthStatus = AVAuthorizationStatus.restricted
                    exit(0)
                }
                
            })
            
            break
        case AVAuthorizationStatus.denied:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                
                if(!granted){
                    //否认
                    self.cameraAuthStatus = AVAuthorizationStatus.denied
//                    AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: "摄像头权限未开启,点击确认跳转至设置") {
//                    }
                    AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: "摄像头权限未开启,点击确认跳转至设置") {
                        self.openSettings()
                    }
                }
                
            })
            break
        default:
            break
        }
    }
}
