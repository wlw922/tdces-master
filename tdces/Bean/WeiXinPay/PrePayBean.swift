//
//  PrePayBean.swift
//  tdces
//
//  Created by Str1ng on 2019/11/11.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON
class PrePayBean: BaseBean {
    /// 商户订单号
    var outTradeNo:String?
    var mchId:String? //null,
    /// 预支付交易会话标识
    var prepayId:String?
    /// 本平台支付订单创建时间
    var payCreateTime:Int?
    /// 本平台支付订单ID
    var paymentId:Int?
    var nonceStr:String? //null
    required init(json: JSON) {
        super.init(json: json)
        outTradeNo=json["outTradeNo"].string
        mchId=json["mchId"].string
        prepayId=json["prepayId"].string
        payCreateTime=json["payCreateTime"].int
        paymentId=json["paymentId"].int
        nonceStr=json["nonceStr"].string
    }
    
    required init() {
        super.init()
    }
}
