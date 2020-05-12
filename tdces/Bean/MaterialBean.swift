//
//  MaterialBean.swift
//  tdces
//
//  Created by Str1ng on 2019/10/21.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON
/// 培训课程内容
class MaterialBean: BaseBean {
    
    /// 课程ID
    var id:Int?
    /// 课程名称
    var name:String?
    /// 视频时长
    var materialDuration:Int?
    /// 材料类型  0-视频 1-文档
    var materialFormat:Int?
    
    var materialType:Int?
    var medium:[MediaBean]?
    
    /// 已学学时
    var watchDuration:Int?
    
    required init(json: JSON) {
        super.init(json: json)
        id=json["id"].int
        name = json["name"].string
        materialFormat = json["materialFormat"].int
        if(materialFormat == 0){//视频文件
            medium=[MediaBean].init()
            
            let mediumString:String = json["fileUrl"].string!
            let mediumJson = JSON.init(parseJSON: mediumString).array
            for mediaJson in mediumJson!{
                let media = MediaBean.init(json: mediaJson)
                medium?.append(media)
            }
            if(!json["materialDuration"].isEmpty){
                materialDuration = json["materialDuration"].int
            }
        }else if(materialFormat == 1){//文档
            medium=[MediaBean].init()
            let media = MediaBean.init()
            media.url=json["materialHtmlUrl"].string
            medium?.append(media)
        }
        
        
    }
    
    required init(){
        super.init()
    }
}
