//
//  NotifyConfig.swift
//  CarManagementCommon
//
//  Created by Str1ng on 2017/6/24.
//  Copyright © 2017年 gmcx. All rights reserved.
//

import Foundation


/// 定位变化通知
let NotifyLocationChange = NSNotification.Name("NotifyLocationChange")

/// 考试答案完成
let NotifyAnswerChange = NSNotification.Name("NotifyAnswerChange")

/// 登录成功
let NotifyLoginSuccess = NSNotification.Name("NotifyLoginSuccess")

/// 人脸识别成功
let NotifyFaceRecognitionSuccess = NSNotification.Name("NotifyFaceRecognitionSuccess")

/// 关闭视频播放
let NotifyCloseMediaView = NSNotification.Name("NotifyCloseMediaView")

/// 培训类型选择变更
let NotifyTrainCategoryCheckChange = NSNotification.Name("NotifyTrainCategoryCheckChange")

let NotifyTrainCategoryCanCheck = NSNotification.Name("NotifyTrainCategoryCanCheck")

/// 进行开始考试
let NotifyStartExam =  NSNotification.Name("NotifyStartExam")

/// 微信支付成功
let NotifyWXPaySuccess =  NSNotification.Name("WXPaySuccessNotification")

/// 微信支付失败
let NotifyWXPayFailed =  NSNotification.Name("WXPayFailedNotification")

/// 考试通过
let NotifyExamPass =  NSNotification.Name("NotifyExamPass")

// 考试失败
let NotifyExamFailed =  NSNotification.Name("NotifyExamFailed")

let NotifyExamFinished =  NSNotification.Name("NotifyExamFinished")
