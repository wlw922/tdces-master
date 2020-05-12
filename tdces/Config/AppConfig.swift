//
//  AppConfig.swift
//  CarManagementCommon
//
//  Created by Str1ng on 2017/4/20.
//  Copyright © 2017年 gmcx. All rights reserved.
//

import Foundation
import UIKit

//var user:UserBean?

var staff:StaffBean?
var pageSize:Int=20
var isLogin: Bool = false
var APP_ID_VALUE="9fbde7cc-8244-478d-8569-485b0658afe7"
var UNIVERSAL_LINK="https://www.cx-info.com/.well-known/apple-app-site-association"

//____________________________________________________________________________________
// MARK：测试环境
//var SERVER_API_URL="http://114.116.157.104:8060/tdces/external/exapi/studentApp/"
//var UPLOAD_IMAGE_URL="http://114.116.157.104:8060/tdces/admin/upload/uploadBase64Img"
//var WEIXIN_API_URL="http://114.116.157.104:8060/tdces/admin/wxpay/returnUnifiedorder"
//var PHOTO_URL="http://114.116.157.104:9000/upload/"
//var PAPER_URL="https://114.116.157.104:9000/#/examFull/examCheck?examId="
//____________________________________________________________________________________

//____________________________________________________________________________________
// MARK：测试环境
//var SERVER_API_URL="http://api.cx-info.com:5509/tdces/external/exapi/studentApp/"
//var UPLOAD_IMAGE_URL="http://api.cx-info.com:5509/tdces/admin/upload/uploadBase64Img"
//var WEIXIN_API_URL="http://api.cx-info.com:5509/tdces/admin/wxpay/returnUnifiedorder"
//var PHOTO_URL="http://api.cx-info.com:5509/upload/"
//____________________________________________________________________________________


//____________________________________________________________________________________
// MARK：线上环境
var SERVER_API_URL="https://www.aqwmjy.com/tdces/external/exapi/studentApp/"
var UPLOAD_IMAGE_URL="https://www.aqwmjy.com/tdces/admin/upload/uploadBase64Img"
var WEIXIN_API_URL="https://www.aqwmjy.com/tdces/admin/wxpay/returnUnifiedorder"//线上环境
var PHOTO_URL="https://www.aqwmjy.com/upload/"
var PAPER_URL="https://www.aqwmjy.com/#/examFull/examCheck?examId="
//____________________________________________________________________________________

var BUSINESS_SERVER_API_URL=""
var BUSINESS_SERVER_IS_ENCRYPT:Bool = false
var WEB_SOCKET_URL=""
var ScreenWidth = UIScreen.main.bounds.size.width
var ScreenHight = UIScreen.main.bounds.size.height
var aMapLocation:CLLocation! = nil
var WX_APPID:String="wx885af675cc9972e5"
var WX_APP_KEY:String="3fd4f3d2983bda2c48bcb031c40f0a89"
//var aMapLocationReGeocode:AMapLocationReGeocode! = nil
