//
//  NetManager.swift
//  YiAnXing
//
//  Created by Str1ng on 5/9/19.
//  Copyright © 2019 com.gmcx. All rights reserved.
//

import Foundation
import SwiftHTTP


class NetManager {
    let queue:HTTPQueue = HTTPQueue.init(maxSimultaneousRequest: 5)
    static let sharedInstance = NetManager()
    var appKey:String = "8245bf08f1f743ed8413eb056dbd8940"
    var secretKey:String = "235fr4"
    private init(){
    }
    
    func sendPost(url:String,methodName:String,param:[String:Any],onFinish: @escaping (_ result : Response) -> ()) {
        var requestUrl = url
        requestUrl.append(methodName)
        requestUrl.append("?")
        var paramsString:String=""
        for(key,value) in param{
            paramsString.append(key + "=" + (value as! String) + "&")
        }
        var params = param
        let postHeadDic=getPostHeadDic()
        for(key,value) in postHeadDic{
            paramsString.append(key + "=" + value + "&")
            params[key]=value
        }

        requestUrl=requestUrl.substring(from: 0, to: requestUrl.lengthOfBytes(using: .utf8)-1)
        var req = URLRequest(urlString: requestUrl)
        if(req != nil){
            req?.timeoutInterval = TimeInterval(30)
            
//            let soapMsg: String = toSoapMessage(methodName: methodName, params: params)
//            req?.setValue(String(soapMsg), forHTTPHeaderField: "Content-Length")
//            req?.setValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
            req?.httpMethod = "POST"
            req?.httpBody = paramsString.data(using: .utf8)
//            req?.httpBody = soapMsg.data(using: String.Encoding.utf8)
            let task = HTTP(req!)
            task.onFinish = { (response) in
                onFinish(response)
            }
            queue.add(http: task)
        }

    }
    
    private func getPostHeadDic()->Dictionary<String ,String>{
        var postHeadDic : Dictionary<String , String>
        postHeadDic=[:]
        let strTime=DateUtil.getMothodDateTime()
        var strSign=appKey+strTime+secretKey
        strSign=strSign.md5().uppercased()
        postHeadDic["appKey"]=appKey
        postHeadDic["ts"]=strTime
        postHeadDic["sign"]=strSign
        return postHeadDic
    }
    
//    private func toSoapMessage(methodName: String, params:[String:String]) -> String {
//        var message: String = String()
//        message += "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
//        message += "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
//        message += "<soap:Body>"
//        message += "<\(methodName) xmlns=\"http://cx-info.com/\">"
//        for (key,value) in params
//        {
//            message += "<\(key)>\(value)</\(key)>"
//        }
//        message += "</\(methodName)>"
//        message += "</soap:Body>"
//        message += "</soap:Envelope>"
//        //        print("请求消息体： \(message)")
//        return message
//    }
}
