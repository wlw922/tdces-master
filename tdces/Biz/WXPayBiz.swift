//
//  WXPayBiz.swift
//  tdces
//
//  Created by Str1ng on 2019/11/11.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyXMLParser
import SwiftyJSON

class WXPayBiz{
    static let sharedInstance=WXPayBiz()
    private init(){
    }
    
    
    public func returnUnifiedorder(productId:String, body:String,totalFee:String,payMethod:String,loginId:String,completion:@escaping(_ responseBean:ResponseBean) -> ()) {
        
        let params =  ["productId" : productId,"body" : body,"totalFee" : totalFee,"payMethod" : payMethod,"loginId" : loginId]
        SystemBiz.sharedInstance.returnUnifiedorder(url: WEIXIN_API_URL, param: params) { (responseBean) in
            do{
                let result:ResponseBean = responseBean
                if(responseBean.success!){
                    let resultJson:JSON = try JSON.init(data: (responseBean.result as! String).data(using: .utf8)!)
                    let prePayBean:PrePayBean = PrePayBean.init(json: resultJson)
                    result.result=prePayBean
                }
                completion(result)
            }
            catch{
                
            }
            
        }
    }
    
}
