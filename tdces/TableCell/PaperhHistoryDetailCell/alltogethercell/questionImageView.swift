//
//  StartExamView.swift
//  tdces
//
//  Created by Str1ng on 2019/11/9.
//  Copyright © 2019 gmcx. All rights reserved.
//



class questionImageView: UIView {

     @IBOutlet weak var closeBtn: UIButton!

    
    //初始化时将xib中的view添加进来
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
     
      
  
    
    }
    //加载xib
    func loadViewFromNib() -> UIView {
        let className = type(of: self)
        let bundle = Bundle.init(for: className)
        let name =  NSStringFromClass(className).components(separatedBy: ".").last
        let nib = UINib(nibName: name!, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
  @IBAction func btnStartExamAction(_ sender: UIButton) {
    
       }
    
    

}
