//
//  ChapterBean.swift
//  tdces
//
//  Created by Str1ng on 2019/10/21.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyJSON
class ChapterBean: BaseBean {
    var chapterTitle:String?
    var materialList:[MaterialBean]?
    var chapterType:Int?//0-材料看视频   3-考试
    var paper:PaperBean?
    
    required init(json: JSON) {
        super.init(json: json)
        chapterTitle = json["outlineDetailType"].string
        chapterType = json["detailType"].int
        if(chapterType == 0){
            materialList=[MaterialBean].init()
            let materialBean = MaterialBean.init(json: json["material"])
            materialList?.append(materialBean)
        }else if(chapterType == 3){
            if(json["paper"].description != "null"){
            paper=PaperBean.init(json: json["paper"])
            }else{
                
            }
        }
        
        
    }
    
    func appendMaterialList(materialJson:JSON){
        let materialBean = MaterialBean.init(json: materialJson["material"])
        materialList?.append(materialBean)
    }
    
    required init(){
        super.init()
    }
}
