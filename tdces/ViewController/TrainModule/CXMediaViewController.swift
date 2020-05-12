//
//  CXMediaViewController.swift
//  tdces
//
//  Created by Str1ng on 2019/10/15.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import AVFoundation

class CXMediaViewController: UIViewController {
    
    var material:MaterialBean?
    var train:TrainBean?
    var isFaceVerifySuccess:Bool=false
    //播放器容器
    @IBOutlet var containerView: UIView!
    //播放/暂停按钮
    var playOrPauseButton: UIButton!
    //播放进度
    var progress: UIProgressView!
    //显示播放时间
    var timeLabel: UILabel!
    
    //播放器对象
    var player: AVPlayer?
    //播放资源对象
    var playerItem: AVPlayerItem?
    //时间观察者
    var timeObserver: Any!
    var VerifyPeriodGcdTimerName:String = "VerifyPeriod"
    var PeriodGcdTimerName:String = "Period"
    var VerifyPeriod:Double = 0
    var UpdatePeriod:Double = 0
    var isFirstLoad:Bool = true
    var isGoFaceRecognitionView:Bool=false
    var periodicTimeObserver:Any!
    var totalDuration:String=""
    var currentPos:String=""
    var studyPeriodBean:StudyPeriodBean?
    var planPeriodBean:PlanPeriodBean?
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
        initNotification()
        
    }
    
    func initNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(getNotification(noti:)), name: NotifyFaceRecognitionSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getNotification(noti:)), name: NotifyCloseMediaView, object: nil)
    }
    
    @objc func getNotification(noti:Notification){
        switch noti.name {
        case NotifyFaceRecognitionSuccess:
            self.toPlay()
            if(train!.plan?.hourVerifyMode == "3" || train!.plan?.hourVerifyMode == "2"){
                VerifyPeriod = train!.plan!.verifyPeriod!*60
                if(!GCDTimerManager.shared.isExistTimer(WithTimerName: VerifyPeriodGcdTimerName)){
                    GCDTimerManager.shared.scheduledDispatchTimer(WithTimerName: VerifyPeriodGcdTimerName, timeInterval: 1, queue: DispatchQueue.init(label: "VerifyPeriod"), repeats: true) {
                        if(self.VerifyPeriod == 0){

                            self.toPause()
                            GCDTimerManager.shared.cancleTimer(WithTimerName: self.VerifyPeriodGcdTimerName)
                            self.goFaceRecognitionView()
                        }
                        else {
                            

                            self.VerifyPeriod -= 1
                        }
                    }
                }
            }
            break
        case NotifyCloseMediaView:
            if(player != nil){
                player = nil
            }
            if(playerItem != nil){
                playerItem = nil
            }
            break
        default:
            break
        }
    }
    
    func goFaceRecognitionView(){
        self.isGoFaceRecognitionView = true
        DispatchQueue.main.async {
            let faceRecognitionView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FaceRecognitionViewController") as! FaceRecognitionViewController
            faceRecognitionView.train=self.train
            faceRecognitionView.material=self.material
            faceRecognitionView.reconType = "0"
            self.present(faceRecognitionView, animated: true) {
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(isFirstLoad){
            isFirstLoad=false
            addPlayerToAVPlayerLayer()
            if(train!.plan?.hourVerifyMode != nil){
                if(train!.plan?.hourVerifyMode == "1"){//视频开始播放时识别
                    
                    self.goFaceRecognitionView()
                }else if(train!.plan?.hourVerifyMode == "2"){//视频播放第x分钟识别
                    self.toPlay()
                    VerifyPeriod = train!.plan!.verifyPeriod!*60
                    if(!GCDTimerManager.shared.isExistTimer(WithTimerName: VerifyPeriodGcdTimerName)){
                        GCDTimerManager.shared.scheduledDispatchTimer(WithTimerName: VerifyPeriodGcdTimerName, timeInterval: 1, queue: DispatchQueue.init(label: "VerifyPeriod"), repeats: true) {
                            if(self.VerifyPeriod == 0){
                                self.toPause()
                                GCDTimerManager.shared.cancleTimer(WithTimerName: self.VerifyPeriodGcdTimerName)
                                self.goFaceRecognitionView()
                            }
                            else {
                                self.VerifyPeriod -= 1
                            }
                        }
                    }
                }else if(train!.plan?.hourVerifyMode == "3"){//视频播放开始和播放第x分钟识别
                    self.goFaceRecognitionView()
                }
            }else{
                self.toPlay()
            }
            if(planPeriodBean?.materiaPeriodList != nil){
                let materialPeriodBean = (planPeriodBean?.materiaPeriodList?.first(where: { (materiaPeriodBean) -> Bool in
                    if(materiaPeriodBean.materialId == self.material?.id){
                        return true
                    }else {
                        return false
                    }
                }))
                if(materialPeriodBean != nil){
                    self.player?.seek(to: CMTimeMake(value: Int64((materialPeriodBean!.watchDuration)!), timescale: 1), completionHandler: { (result) in
                    
                })
                }
                
            }
        }
        isGoFaceRecognitionView = false
    }
    

    
    // 当接收到内存警告时会执行这个方法
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        LogUtil.sharedInstance.printLog(message: "CXMediaViewController is didReceiveMemoryWarning")
    }
    
    deinit {
        LogUtil.sharedInstance.printLog(message: "CXMediaViewController 被销毁！！！！！！！！")
        
    }
    
    func addPlayerToAVPlayerLayer(){
        
        //播放本地视频
        //        let url = NSURL(fileURLWithPath: "http://383-cn-north-4.cdn-vod.huaweicloud.com/asset/631b36180bc479215a7373166e6f3f3d/play_video/67b87fdf8d20abaa477b09723176584b_2.m3u8")
        let urlString:String = (material?.medium?.first!.url)!
        let url = URL.init(string: urlString)
        //播放网络视频
        // let url = NSURL(string: path)!
        playerItem = AVPlayerItem(url: url! )
        player = AVPlayer(playerItem: self.playerItem)
        player?.volume = 1.0
        //创建视频播放器图层对象
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect //视频填充模式
        self.containerView.layer.addSublayer(playerLayer)
        player?.isMuted = false

        
        
        
    }
    
    func toUploadStudyPeriod(){
        let regId:String = String((self.train?.id)!)
        let materialId:String = String((self.material?.id)!)
        var periodId:String = ""
        var id:String = ""
        let loginId:String = (staff?.user!.loginId)!
        if(studyPeriodBean != nil){
            id = String((studyPeriodBean?.id)!)
            periodId = String((studyPeriodBean?.periodId)!)
        }
        TrainBiz.sharedInstance.UploadStudyPeriod(regId: regId, materialId: materialId, currentPos: currentPos, totalDuration: totalDuration, id: id, periodId: periodId, loginId: loginId) { (responseBean) in
            if(responseBean.success!){
                weak var weakSelf=self
                weakSelf!.studyPeriodBean = responseBean.result as? StudyPeriodBean
            }
        }
    }
    
    func toPlay() {
        player?.play()
        periodicTimeObserver = self.player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: DispatchQueue.main, using: {(time) in
            let loadTime = CMTimeGetSeconds(time)
            let currentPosInt:Int = Int(loadTime)
            self.currentPos = String(currentPosInt)
//            print("!!!\(self.playerItem!.duration.value==0)")
            if(self.playerItem!.duration.value==0){
                self.totalDuration = "0"
            }else{
            self.totalDuration = String(Int(CMTimeGetSeconds(self.playerItem!.duration)))
            }
            //            print(loadTime)
            //            let totleTime = CMTimeGetSeconds((self.player?.currentItem!.duration)!)
            LogUtil.sharedInstance.printLog(message: "播放时间：\(loadTime)")
        })
        if(!GCDTimerManager.shared.isExistTimer(WithTimerName: PeriodGcdTimerName)){
            GCDTimerManager.shared.scheduledDispatchTimer(WithTimerName: PeriodGcdTimerName, timeInterval: 1, queue: DispatchQueue.init(label: "Period"), repeats: true) {
                if(self.UpdatePeriod == 5){
                    self.UpdatePeriod = 0
                    self.toUploadStudyPeriod()
                }else{
                    self.UpdatePeriod += 1
                }
            }
        }
    }
    func toPause(){
        periodicTimeObserver = nil
        player?.pause()
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let object = object as? AVPlayerItem  else { return }
        guard let keyPath = keyPath else { return }
        if keyPath == "status"{
            if object.status == .readyToPlay{ //当资源准备好播放，那么开始播放视频
                player?.play()
                print("正在播放...，视频总长度:\(formatPlayTime(seconds: CMTimeGetSeconds(object.duration)))")
            }else if object.status == .failed || object.status == .unknown{
                print("播放出错")
            }
        }else if keyPath == "loadedTimeRanges"{
            let loadedTime = avalableDurationWithplayerItem()
            print("当前加载进度\(loadedTime)")
        }
    }
    
    
    
    //给AVPlayerItem、AVPlayer添加监控
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(playToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        
        
        
//        为AVPlayerItem添加status属性观察，得到资源准备好，开始播放视频
        self.playerItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
//        监听AVPlayerItem的loadedTimeRanges属性来监听缓冲进度更新
        self.playerItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
        self.playerItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
        self.playerItem?.addObserver(self, forKeyPath:"playbackLikelyToKeepUp", options: .new,context:nil)
        //            NotificationCenter.default.addObserver(self, selector: #selector(CXMediaViewController.playerItemDidReachEnd(notification:)), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    @objc func playToEndTime(){
        print("播放完成")
    }
    //将秒转成时间字符串的方法，因为我们将得到秒。
    func formatPlayTime(seconds: Float64)->String{
        let Min = Int(seconds / 60)
        let Sec = Int(seconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", Min, Sec)
    }
    
    //计算当前的缓冲进度
    func avalableDurationWithplayerItem()->TimeInterval{
        guard let loadedTimeRanges = player?.currentItem?.loadedTimeRanges,let first = loadedTimeRanges.first else {fatalError()}
        //本次缓冲时间范围
        let timeRange = first.timeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange.start)//本次缓冲起始时间
        let durationSecound = CMTimeGetSeconds(timeRange.duration)//缓冲时间
        let result = startSeconds + durationSecound//缓冲总长度
        return result
    }
}
extension CXMediaViewController{
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        toPause()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if(GCDTimerManager.shared.isExistTimer(WithTimerName: VerifyPeriodGcdTimerName)){
            GCDTimerManager.shared.cancleTimer(WithTimerName: VerifyPeriodGcdTimerName)
        }
        
        if (periodicTimeObserver != nil){
            self.player?.removeTimeObserver(periodicTimeObserver as Any)
            periodicTimeObserver = nil
        }
        
//        self.playerItem?.removeObserver(self, forKeyPath: "status", context: nil)
//        self.playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges", context: nil)
//        self.playerItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty", context: nil)
//        self.playerItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp", context: nil)
        self.player?.currentItem!.cancelPendingSeeks()
        self.player?.currentItem!.asset.cancelLoading()
        NotificationCenter.default.removeObserver(self)
        LogUtil.sharedInstance.printLog(message: "CXMediaViewController is didDisappear")
    }
}
