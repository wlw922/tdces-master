//
//  TrainBiz.swift
//  tdces
//
//  Created by Str1ng on 2019/10/17.
//  Copyright © 2019 gmcx. All rights reserved.
//

import Foundation
import SwiftyXMLParser
import SwiftyJSON
class TrainBiz{
    static let sharedInstance=TrainBiz()
    private init(){
    }
    
    /// 获取用户报名记录列表
    /// - Parameter idNumber: <#idNumber description#>
    /// - Parameter completion: <#completion description#>
    public func findRegistrationList(loginId:String, idNumber:String,completion:@escaping(_ responseBean:ResponseBean) -> ()) {
        
        let params =  ["loginId" : loginId,"idNumber" : idNumber,"searchTrainStates[0]":"0","searchTrainStates[1]":"1"]
        SystemBiz.sharedInstance.sendPost(url:SERVER_API_URL,methodName: "findRegistrationList", param: params) { (responseBean) in
            do{
                let result:ResponseBean = responseBean
                if(responseBean.success!){
                    //                    LogUtil.sharedInstance.printLog(message: responseBean.result)
                    var trainList:[TrainBean] = [TrainBean].init()
                    let resultJson:JSON = try JSON.init(data: (responseBean.result as! String).data(using: .utf8)!)
                    let trainListJson:[JSON] = (resultJson["list"].array)!
                    for trainJson in trainListJson{
                        let trainBean:TrainBean = TrainBean.init(json: trainJson)
                        trainList.append(trainBean)
                    }
                    result.result = trainList
                    
                }else{
                }
                completion(result)
            }
            catch{
                
            }
        }
    }
    
    /// 获取培训课程详情
    /// - Parameter id: <#id description#>
    /// - Parameter completion: <#completion description#>
    public func getPlanDetailByReg(id:String,completion:@escaping(_ responseBean:ResponseBean) -> ()) {
        
        let params =  ["id" : id]
        SystemBiz.sharedInstance.sendPost(url:SERVER_API_URL,methodName: "getPlanDetailByReg", param: params) { (responseBean) in
            do{
                let result:ResponseBean = responseBean
                if(responseBean.success!){
//                                        LogUtil.sharedInstance.printLog(message: responseBean.result)
                    let resultJson:JSON = try JSON.init(data: (responseBean.result as! String).data(using: .utf8)!)
                    var chapterList:[ChapterBean] = [ChapterBean].init()
                    let chapterListJson = resultJson["details"].array
                    for chapterJson in chapterListJson!{
                        if(chapterList.count>0){
                            var hasChapter = false
                            for chapter in chapterList{
                                if(chapter.chapterTitle == chapterJson["outlineDetailType"].string){

//                                    LogUtil.sharedInstance.printLog(message: chapterJson["material"])
                                    let material = MaterialBean.init(json: chapterJson["material"])
                                    chapter.materialList?.append(material)//.appendMaterialList(materialJson: chapterJson["material"])
                                    hasChapter = true
                                    break
                                }
                            }
                            if(!hasChapter){
                                let chapterBean:ChapterBean = ChapterBean.init(json: chapterJson)
                                chapterList.append(chapterBean)
                            }
                        }else{
                            let chapterBean:ChapterBean = ChapterBean.init(json: chapterJson)
                            chapterList.append(chapterBean)
                        }
                    }
                    result.result = chapterList
//                    LogUtil.sharedInstance.printLog(message: "Login success")
                }else{
//                    LogUtil.sharedInstance.printLog(message: "Login fail")
                }
                completion(result)
            }
            catch{
                
            }
        }
    }
    
    public func findTrainList(idNumber:String,completion:@escaping(_ responseBean:ResponseBean) -> ()) {
        
        let params =  ["idNumber" : idNumber]
        SystemBiz.sharedInstance.sendPost(url:SERVER_API_URL,methodName: "findTrainList", param: params) { (responseBean) in
            do{
                let result:ResponseBean = responseBean
                if(responseBean.success!){
//                    LogUtil.sharedInstance.printLog(message: responseBean.result)
                    var trainList:[TrainBean] = [TrainBean].init()
                    let trainListJson:[JSON] = try JSON.init(data: (responseBean.result as! String).data(using: .utf8)!).arrayValue
                    for trainJson in trainListJson{
                        let trainBean:TrainBean = TrainBean.init(json: trainJson)
                        trainList.append(trainBean)
                    }
//                    LogUtil.sharedInstance.printLog(message: "Login success")
                }else{
//                    LogUtil.sharedInstance.printLog(message: "Login fail")
                }
                completion(result)
            }
            catch{
                
            }
        }
    }
    
    public func getPaperById(id:String,completion:@escaping(_ responseBean:ResponseBean) -> ()) {
        
        let params =  ["id" : id]
        SystemBiz.sharedInstance.sendPost(url:SERVER_API_URL,methodName: "getPaperById", param: params) { (responseBean) in
            do{
                let result:ResponseBean = responseBean
                if(responseBean.success!){
                    let resultJson:JSON = try JSON.init(data: (responseBean.result as! String).data(using: .utf8)!)
                
                    let paperBean:PaperBean = PaperBean.init(json: resultJson)
                    result.result=paperBean
                }else{
//                    LogUtil.sharedInstance.printLog(message: "Login fail")
                }
                completion(result)
            }
            catch{
                
            }
        }
    }
    
    public func UploadStudyPeriod(regId:String,materialId:String,currentPos:String,totalDuration:String,id:String,periodId:String,loginId:String,completion:@escaping(_ responseBean:ResponseBean) -> ()) {
        
        let params =  ["regId" : regId,"materialId" : materialId,"currentPos" : currentPos,"totalDuration" : totalDuration,"id" : id,"periodId" : periodId,"loginId" : loginId]
        SystemBiz.sharedInstance.sendPost(url:SERVER_API_URL,methodName: "UploadStudyPeriod", param: params) { (responseBean) in
            do{
                let result:ResponseBean = responseBean
                if(responseBean.success!){
                    //                        LogUtil.sharedInstance.printLog(message: responseBean.result)
                    let resultJson:JSON = try JSON.init(data: (responseBean.result as! String).data(using: .utf8)!)
                    let studyPeriodBean:StudyPeriodBean = StudyPeriodBean.init(json: resultJson)
                    result.result=studyPeriodBean
                }else{
                }
                completion(result)
            }
            catch{

            }
        }
    }
    
    public func getQuestionsById(id:String,completion:@escaping(_ responseBean:ResponseBean) -> ()) {
        
        let params =  ["id" : id]
        SystemBiz.sharedInstance.sendPost(url:SERVER_API_URL,methodName: "getQuestionsById", param: params) { (responseBean) in
            do{
                let result:ResponseBean = responseBean
                if(responseBean.success!){
                    //                        LogUtil.sharedInstance.printLog(message: responseBean.result)
                    let resultJson:JSON = try JSON.init(data: (responseBean.result as! String).data(using: .utf8)!)
                    let questionBean:QuestionBean = QuestionBean.init(json: resultJson)
                    result.result=questionBean
                }else{
                }
                completion(result)
            }
            catch{
                
            }
        }
    }
    
    public func saveExam(id:String,areaId:String,password:String,startTime:String,endTime:String,paperId:String,quesNumber:String,rightNumber:String,score:String,regId:String,orgId:String,result:String,loginId:String,examContent:String,completion:@escaping(_ responseBean:ResponseBean) -> ()) {
        
        let params =  ["id":id,"area.id" : areaId,"password":password,"startTime":startTime,"endTime":endTime,"paperId":paperId,"quesNumber":quesNumber,"rightNumber":rightNumber,"score":score,"reg.id":regId,"org.id":orgId,"result":result,"loginId":loginId,"examContentStr":examContent]
//        if(examContent.count > 0){
//            for i in 0..<examContent.count{
//                params["examContent[\(i)]"]=examContent[i].string!
//            }
//        }
        SystemBiz.sharedInstance.sendPost(url:SERVER_API_URL,methodName: "saveExam", param: params) { (responseBean) in

                let result:ResponseBean = responseBean

                completion(result)
        }
    }
    
    public func getRegistrationResult(regId:String,completion:@escaping(_ responseBean:ResponseBean) -> ()) {
        let params =  ["regId":regId]
        SystemBiz.sharedInstance.sendPost(url:SERVER_API_URL,methodName: "getRegistrationResult", param: params) { (responseBean) in
            
            do{
                let result:ResponseBean = responseBean
                if(responseBean.success!){
                    let resultJson:JSON = try JSON.init(data: (responseBean.result as! String).data(using: .utf8)!)
                    let planPeriodBean:PlanPeriodBean = PlanPeriodBean.init(json: resultJson)
                    result.result=planPeriodBean
                }else{
                }
                completion(result)
            }
            catch{
                
            }
        }
    }
    
    
    /// 成绩列表（显示最新一张成绩单列表）
    /// - Parameters:
    ///   - idNumber: <#idNumber description#>
    ///   - completion: <#completion description#>
    public func findExamListByStaff(idNumber:String,completion:@escaping(_ responseBean:ResponseBean) -> ()) {
        let params =  ["idNumber":idNumber]
        SystemBiz.sharedInstance.sendPost(url:SERVER_API_URL,methodName: "findExamListByStaff", param: params) { (responseBean) in
            
            do{
                let result:ResponseBean = responseBean
//                LogUtil.sharedInstance.printLog(message: result.result)
                if(responseBean.success!){
                    let resultJson:JSON = try JSON.init(data: (responseBean.result as! String).data(using: .utf8)!)
                    var transcriptList:[TranscriptBean] = [TranscriptBean].init()
                    let transcriptListJson:[JSON] = resultJson["list"].arrayValue
                    for transcriptJson in transcriptListJson{
                        let transcriptBean:TranscriptBean = TranscriptBean.init(json: transcriptJson)
                        transcriptList.append(transcriptBean)
                    }
                    result.result=transcriptList
                }else{
                }
                completion(result)
            }
            catch{
                
            }
        }
    }
    /// 试卷列表（查看显示所有考过的试卷）
     
        public func findExamList (idNumber:String,completion:@escaping(_ responseBean:ResponseBean) -> ()) {
            let params =  ["idNumber":idNumber]
            SystemBiz.sharedInstance.sendPost(url:SERVER_API_URL,methodName: "findExamList", param: params) { (responseBean) in
                
                do{
                    let result:ResponseBean = responseBean
    //                LogUtil.sharedInstance.printLog(message: result.result)
                    if(responseBean.success!){
                        let resultJson:JSON = try JSON.init(data: (responseBean.result as! String).data(using: .utf8)!)
                      //  print("试卷查询结果集：\(resultJson)")
                        var transcriptList:[TranscriptBean] = [TranscriptBean].init()
                        let transcriptListJson:[JSON] = resultJson["list"].arrayValue
                        for transcriptJson in transcriptListJson{
                            let transcriptBean:TranscriptBean = TranscriptBean.init(json: transcriptJson)
                            transcriptList.append(transcriptBean)
                        }
                        result.result=transcriptList
                    }else{
                    }
                    completion(result)
                }
                catch{
                    
                }
            }
        }
    
    //单张试卷
    public func getExamAllById(id:String,completion:@escaping(_ responseBean:ResponseBean) -> ()) {
                let params =  ["id":id]
                SystemBiz.sharedInstance.sendPost(url:SERVER_API_URL,methodName: "getExamAllById", param: params) { (responseBean) in
                    
                    do{
                        let result:ResponseBean = responseBean
    //                    LogUtil.sharedInstance.printLog(message: result.result)
                        if(responseBean.success!){
                            let resultJson:JSON = try JSON.init(data: (responseBean.result as! String).data(using: .utf8)!)
                                print("单张试卷结果集：\(resultJson)")
                           
                            let paperHistroyBean:PaperHistroryBean = PaperHistroryBean.init(json: resultJson)
                             
                            result.result = paperHistroyBean
                        }else{
                        }
                        completion(result)
                    }
                    catch{
                        
                    }
                }
            }

     //单张成绩
     public func getExamById(id:String,completion:@escaping(_ responseBean:ResponseBean) -> ()) {
            let params =  ["id":id]
            SystemBiz.sharedInstance.sendPost(url:SERVER_API_URL,methodName: "getExamById", param: params) { (responseBean) in
                
                do{
                    let result:ResponseBean = responseBean
//                    LogUtil.sharedInstance.printLog(message: result.result)
                    if(responseBean.success!){
                        let resultJson:JSON = try JSON.init(data: (responseBean.result as! String).data(using: .utf8)!)
                        print("单张成绩结果集：\(resultJson)")
                        let transcriptBean:TranscriptBean = TranscriptBean.init(json: resultJson)
                         
                        result.result=transcriptBean
                    }else{
                    }
                    completion(result)
                }
                catch{
                    
                }
            }
        }
}

        
