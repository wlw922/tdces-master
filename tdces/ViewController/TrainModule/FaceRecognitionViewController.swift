//
//  FaceRecognitionViewController.swift
//  tdces
//
//  Created by Str1ng on 2019/10/12.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import AVFoundation
class FaceRecognitionViewController: UIViewController {
    
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
    
    var getFaceCount:Int=0
    var train:TrainBean?
    var material:MaterialBean?
    @IBOutlet var  customImgView: UIImageView!
    @IBOutlet var faceRecognitionView:UIView!
    @IBOutlet weak var labUserName:UILabel!
    var faceView:UIView?
    var reconType:String?
    var paper:PaperBean?
    var line : UIImageView = UIImageView(image: UIImage(named: "icon_scan_line"))
    var examId:String?
    var subQueue:DispatchQueue?
    /**
     跳转至设置
     */
    func openSettings() {
        let settingsURL:NSURL = NSURL(string:UIApplication.openSettingsURLString)!
        UIApplication.shared.open(settingsURL as URL, options: [UIApplication.OpenExternalURLOptionsKey : Any].init(), completionHandler: nil)
   
    }
    
    /**
     Check video authorization status
     检查视频授权状态
     */
    func checkVideoAuth() {
        weak var weakSelf=self
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        {
        case AVAuthorizationStatus.authorized://已经授权
            
            weakSelf!.cameraAuthStatus = AVAuthorizationStatus.authorized
            break
        case AVAuthorizationStatus.notDetermined:
            
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                
                if(granted){
                    //受限制
                    weakSelf!.cameraAuthStatus = AVAuthorizationStatus.restricted
                    DispatchQueue.main.async {
                        AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: "摄像头权限未开启,点击确认跳转至设置") {
                            weakSelf!.openSettings()
                            exit(0)
                        }
                    }
                    
                }
                
            })
            
            break
        case AVAuthorizationStatus.denied:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                
                if(!granted){
                    //否认
                    weakSelf!.cameraAuthStatus = AVAuthorizationStatus.denied
                    DispatchQueue.main.async {
                        AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: "摄像头权限未开启,点击确认跳转至设置") {
                            weakSelf!.openSettings()
                        }
                    }
                }
                
            })
            break
        default:
            break
        }
    }
    
    /**
     摄像头设置相关
     */
    func setupCamera() {
        
        weak var weakSelf=self
        weakSelf!.session = AVCaptureSession()
        var deviceTypes = [AVCaptureDevice.DeviceType.builtInDualCamera,
                           .builtInMicrophone,
                           .builtInTelephotoCamera,
                           .builtInWideAngleCamera]
        
        if #available(iOS 11.1, *) {
            deviceTypes.append(AVCaptureDevice.DeviceType.builtInTrueDepthCamera)
        }
        let devices =  AVCaptureDevice.DiscoverySession(
            deviceTypes: deviceTypes,
            mediaType: AVMediaType.video,
            position: AVCaptureDevice.Position.front).devices
        
        
        weakSelf!.captureOutput = AVCaptureVideoDataOutput()
        weakSelf!.captureOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as String) : NSNumber(value: kCVPixelFormatType_32BGRA as UInt32)]
        weakSelf!.captureOutput.alwaysDiscardsLateVideoFrames = true
        
        //        self.captureOutput.videoSettings[(kCVPixelBufferPixelFormatTypeKey as String)] = NSNumber(value: kCVPixelFormatType_32BGRA as UInt32)
        for device in devices{
            if (device.hasMediaType(AVMediaType.video)) {
                if (device.position == AVCaptureDevice.Position.front) {
                    do{
                        try weakSelf!.captureInput = AVCaptureDeviceInput(device: device)
                    }catch let error as NSError{
                        print(error)
                    }
                }
            }
        }
        
        
        weakSelf!.session.beginConfiguration()
        //画面质量设置
        weakSelf!.session.sessionPreset = AVCaptureSession.Preset.high
        if(weakSelf!.captureInput != nil){
            if(weakSelf!.session.canAddInput(weakSelf!.captureInput)){
                weakSelf!.session.addInput(weakSelf!.captureInput)
            }
            if(weakSelf!.session.canAddOutput(weakSelf!.captureOutput)){
                subQueue = DispatchQueue.init(label: "subQueue")
                //            captureOutput.sampleBufferDelegate = self
                captureOutput.setSampleBufferDelegate(weakSelf, queue: subQueue)
                
                weakSelf!.session.addOutput(weakSelf!.captureOutput)
            }
            
            //预览Layer设置
            weakSelf!.captureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: weakSelf!.session)
            weakSelf!.captureVideoPreviewLayer.frame = CGRect.init(x: 0, y: 0, width: weakSelf!.customImgView.frame.size.width, height: weakSelf!.customImgView.frame.size.height)
            //            CGRectMake(self.view.frame.size.width/2 - (320/2), 0, 320, 240)
            weakSelf!.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            weakSelf!.customImgView.layer.addSublayer(weakSelf!.captureVideoPreviewLayer)
            weakSelf!.session.commitConfiguration()
        }
    }
    
    
    /**
     数据流BufferRef转Image
     
     - parameter sampleBuffer: 数据流
     
     - returns: UIImage
     */
    func getImageData(sampleBuffer:CMSampleBuffer!)-> UIImage {
        // Get a CMSampleBuffer's Core Video image buffer for the media data
        let  imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        // Lock the base address of the pixel buffer
        CVPixelBufferLockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly);
        
        
        // Get the number of bytes per row for the pixel buffer
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer!);
        
        // Get the number of bytes per row for the pixel buffer
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer!);
        // Get the pixel buffer width and height
        let width = CVPixelBufferGetWidth(imageBuffer!);
        let height = CVPixelBufferGetHeight(imageBuffer!);
        
        // Create a device-dependent RGB color space
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        
        // Create a bitmap graphics context with the sample buffer data
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedFirst.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        //let bitmapInfo: UInt32 = CGBitmapInfo.alphaInfoMask.rawValue
        let context = CGContext.init(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        // Create a Quartz image from the pixel data in the bitmap graphics context
        let quartzImage = context?.makeImage();
        // Unlock the pixel buffer
        CVPixelBufferUnlockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly);
        
        // Create an image object from the Quartz image
        let image = UIImage.init(cgImage: quartzImage!);
        
        return (image);
    }
    
    
    deinit {
        LogUtil.sharedInstance.printLog(message: "faceFeatureView 被销毁！！！！！！！！")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        LogUtil.sharedInstance.printLog(message: "faceFeatureView didReceiveMemoryWarning")
    }
    
}

// MARK: - IBAction
extension FaceRecognitionViewController{
    @IBAction func btnBack(){
        weak var weakSelf=self
        weakSelf!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startScanFace(){
        
        weak var weakSelf=self
        if(weakSelf!.captureInput != nil){
            weakSelf!.session.startRunning()
        }else{
            AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: "未找到摄像头\n请检查是否打开摄像头权限！") {
                
            }
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension FaceRecognitionViewController:AVCaptureVideoDataOutputSampleBufferDelegate{
    //AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        weak var weakSelf=self
        if(weakSelf!.faceView != nil){
            DispatchQueue.main.async {
                weakSelf!.faceView?.removeFromSuperview()
            }
        }
        var resultImage = weakSelf!.getImageData(sampleBuffer: sampleBuffer)
        resultImage = UIImage.fixOrientation(image: resultImage)
        let context = CIContext.init(options: [CIContextOption.useSoftwareRenderer:true])
        let detecotr = CIDetector.init(ofType: CIDetectorTypeFace, context: context, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
        let ciImage = CIImage(image: resultImage)
        let faceFeatures:[CIFaceFeature] = detecotr?.features(in: ciImage!) as! [CIFaceFeature]
        let inputImageSize = ciImage!.extent.size
        var transform = CGAffineTransform.identity
        transform = transform.scaledBy(x: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -inputImageSize.height)
        for faceFeature in faceFeatures {
            if(faceFeature.hasLeftEyePosition && faceFeature.hasRightEyePosition && faceFeature.hasMouthPosition){
                if(weakSelf!.getFaceCount == 10){
                    weakSelf!.getFaceCount += 1
                    DispatchQueue.main.async {
                        AlertUtil.sharedInstance.showWaitDialog(message: "正在进行人脸对比，请稍等...")
                    }
                    
                    CommonBiz.sharedInstance.uploadBase64Img(imgStr: (UIImage.fixOrientation(image: resultImage).jpegData(compressionQuality: 0.3)?.base64EncodedString())!) { (responseBean) in
                        if(responseBean.success!){
                            let loginId:String=(staff?.user?.loginId)!
                            let regId:String=String((weakSelf!.train?.id)!)
                            let orgId:String=String((staff?.user?.org?.id)!)
                            let areaId:String=String((staff?.user?.area?.id)!)
                            var relatedId:String=""
                            if(weakSelf!.reconType == "0"){
                                relatedId=String((weakSelf!.material?.id)!)
                            }else if(weakSelf!.reconType == "2"){
                                relatedId=weakSelf!.examId!
                            }
                            let reconType:String=weakSelf!.reconType!
                            let fileUrl:String =   (responseBean.result as! String)
                            var photo:String=""
                            let attachment = weakSelf!.train?.attachments?.first(where: { (attachmentBean) -> Bool in
                                if(attachmentBean.category == 2){
                                    return true
                                }else{
                                    return false
                                }
                            })
                            photo =   (attachment?.fileUrl)!
                            UserBiz.sharedInstance.videoFaceVerification(loginId: loginId, regId: regId, orgId: orgId, areaId: areaId, relatedId: relatedId, reconType: reconType, fileUrl: fileUrl, photo: photo) { (videoFaceVerificationResult) in
//                                if(videoFaceVerificationResult.success!){
                                    DispatchQueue.main.async {
                                        
                                        AlertUtil.sharedInstance.closeWaitDialog()
                                        AlertUtil.sharedInstance.showAutoDismissSuccessDialog(title: "", message: videoFaceVerificationResult.message!, timeout: 2) {
                                            weakSelf!.dismiss(animated: true) {
                                                LogUtil.sharedInstance.printLog(message: "Send NotifyFaceRecognitionSuccess")
                                                NotificationCenter.default.post(name: NotifyFaceRecognitionSuccess, object: nil)
                                            }
                                        }
                                        
                                    }
//                                }else{
//                                    DispatchQueue.main.async {
//                                        AlertUtil.sharedInstance.closeWaitDialog()
//                                        AlertUtil.sharedInstance.showWarningAutoDismissDialog(message: videoFaceVerificationResult.message!) {
//                                            weakSelf!.getFaceCount = 0
//                                        }
//                                    }
//                                }
                            }
                        }else{
                            weakSelf!.getFaceCount = 0
                        }
                    }
                }else{
                    weakSelf!.getFaceCount += 1
                }
            }
        }
    }
}

// MARK: - ViewController Life
extension FaceRecognitionViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weak var weakSelf=self
        weakSelf!.checkVideoAuth()
        weakSelf!.setupCamera()
        weakSelf!.labUserName.text = staff?.user?.userName!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        weak var weakSelf=self
        captureVideoPreviewLayer.removeFromSuperlayer()
        captureVideoPreviewLayer = nil
        if(weakSelf!.session != nil){
            weakSelf!.session.stopRunning()
            weakSelf!.session = nil
        }
        captureOutput.setSampleBufferDelegate(nil, queue: nil)
        subQueue=nil
        captureOutput = nil
        captureInput = nil
        LogUtil.sharedInstance.printLog(message: "FaceRecognitionView viewWillDisappear")
        super.viewWillDisappear(animated)
    }
}

