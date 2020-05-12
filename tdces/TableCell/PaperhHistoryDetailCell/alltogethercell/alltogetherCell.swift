//
//  alltogetherCell.swift
//  tdces
//
//  Created by MAC on 2020/4/27.
//  Copyright © 2020 gmcx. All rights reserved.
//

import UIKit

class alltogetherCell: UITableViewCell {
    @IBOutlet weak var labQuestionTitle: UILabel!
    @IBOutlet weak var answerTV: UITextView!

       var maxHeight:CGFloat=200//定义最大高度
       
       
       override func awakeFromNib() {
           super.awakeFromNib()
          
           
       }

       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)

           // Configure the view for the selected state
       }
       
       func setupWithBean(examContentBean : ExamContentBean) {
           weak var weakSelf=self
           var quesTypeStr:String?
           
         if(examContentBean.quesType == 0)
         {
           quesTypeStr = "单选题"
         }
         else if(examContentBean.quesType == 1)
         {
           quesTypeStr = "多选题"
         }
         else if(examContentBean.quesType == 2)
         {
             quesTypeStr = "判断题"
         }else
           {
             quesTypeStr = "简答题"
           }

           //问题
           weakSelf?.labQuestionTitle.text = "\(String(examContentBean.sn!))." + "[\(quesTypeStr!)]" + "\(String(examContentBean.question!))" + "你的答案\(String(describing: examContentBean.userAnswer!))"
           
         
           //答案
           let examContentOptionsList:[ExamContentOptionsBean] = examContentBean.examContentOptionsList
                 // print("abc = \(examContentBean.examContentOptionsList.count)")
           let indexCount:Int = examContentOptionsList.count
                  
           weakSelf?.answerTV.isEditable = false //textView不可编辑
           weakSelf?.answerTV.alwaysBounceVertical = false//textView不可滚动
           weakSelf?.answerTV.isSelectable = false //textView不可复制
           weakSelf?.answerTV.text = nil
           for idx in stride(from: 0, to: indexCount, by: 1) {
                      
               let singleTextStr:String = "\(String(examContentOptionsList[idx].code!))." + "\(String(examContentOptionsList[idx].content!))"
                   //   print("idx = \(idx)---singleTextStr = \(singleTextStr)")
                weakSelf?.answerTV.text.append(singleTextStr)
                if (examContentOptionsList[idx].judge!)
                {
                      weakSelf?.answerTV.text.append(" √ ")
               }
                      if(idx < (indexCount-1))
                      {
                          weakSelf?.answerTV.text.append("\n")
                      }

                  }
                  //textview高度自适应
                  //定义一个constrainSize值用于计算textview的高度
                  let constrainSize=CGSize(width:(weakSelf?.answerTV.frame.size.width)!,height:CGFloat(MAXFLOAT))
                  //获取textview的真实高度
                  var size = weakSelf?.answerTV.sizeThatFits(constrainSize)
                  //如果textview的高度大于最大高度高度就为最大高度并可以滚动，否则不能滚动
                  if size!.height >= maxHeight{
                      size!.height = maxHeight
                      weakSelf?.answerTV.isScrollEnabled=true
                  }else{
                      weakSelf?.answerTV.isScrollEnabled=false
                  }
                  //重新设置textview的高度
                  weakSelf?.answerTV.frame.size.height=size!.height
           
         
           

         
       }
       
       
       internal class func heightForTextView(textView: UITextView, fixedWidth: CGFloat) -> CGFloat {
           let size = CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)
         let constraint = textView.sizeThatFits(size)
         return constraint.height
       }

}
