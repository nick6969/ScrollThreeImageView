//
//  ScrollThreeImageView.swift
//  ScrollThreePages
//
//  Created by LinNick on 2016/1/3.
//  Copyright © 2016年 LinNick. All rights reserved.
//

import UIKit

class ScrollPage : UIViewController {
    
    var imgNameArray :      [String] = [""]      // 圖片名稱 Array
    var duration            : TimeInterval = 2.5 // 0 秒不動作
    
    fileprivate var delegate    : UIScrollViewDelegate!
    fileprivate var timer       : Timer?
    fileprivate var scroll      = UIScrollView()
    fileprivate var backView    = UIView()
    fileprivate var imgView01   = UIImageView()
    fileprivate var imgView02   = UIImageView()
    fileprivate var imgView03   = UIImageView()
    fileprivate var page        = 0
    fileprivate var pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        duration != 0 ? ( self.addTimer() ) : ()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scroll.contentOffset.x = scroll.frame.width
    }
    
    private func setUI(){
        self.automaticallyAdjustsScrollViewInsets = false
        scroll.isPagingEnabled = true
        self.delegate = self
        scroll.delegate = self.delegate
        scroll.showsHorizontalScrollIndicator = false
        
        pageControl.currentPage = page
        pageControl.numberOfPages = imgNameArray.count
        pageControl.currentPageIndicatorTintColor = .yellow
        pageControl.pageIndicatorTintColor = .green
        
        self.view.addSubview(scroll)
        scroll.addSubview(backView)
        backView.addSubview(imgView01)
        backView.addSubview(imgView02)
        backView.addSubview(imgView03)
        self.view.addSubview(pageControl)
        
        imgView01.contentMode = .scaleToFill
        imgView02.contentMode = .scaleToFill
        imgView03.contentMode = .scaleToFill
        
        imgView01.image = UIImage(named: imgNameArray[page != 0 ? page - 1 : imgNameArray.count-1])
        imgView02.image = UIImage(named: imgNameArray[page])
        imgView03.image = UIImage(named: imgNameArray[page != imgNameArray.count - 1 ? page + 1 : 0])
        
        
    }
    
    private func setLayout(){
        view.addConstraints([
            scroll.mLay(.width     , .equal, view),
            scroll.mLay(.centerX   , .equal, view),
            scroll.mLay(.bottom    , .equal, view),
            scroll.mLay(.top       , .equal, view),
            ])
        
        view.addConstraints([
            pageControl.mLay(.bottom  , .equal, view, constant: 10 ),
            pageControl.mLay(.centerX , .equal, view),
            
            ])
        
        scroll.addConstraints([
            backView.mLay(.width   , .equal, scroll, multiplier: 3, constant: 0),
            backView.mLay(.height  , .equal, scroll),
            backView.mLay(.left    , .equal, scroll),
            backView.mLay(.top     , .equal, scroll),
            backView.mLay(.right   , .equal, scroll),
            backView.mLay(.bottom  , .equal, scroll),
            
            ])
        
        backView.addConstraints([
            imgView01.mLay(.left   , .equal, backView),
            imgView01.mLay(.top    , .equal, backView),
            imgView01.mLay(.width  , .equal, backView, multiplier: 1.0 / 3.0 , constant: 0),
            imgView01.mLay(.height , .equal, backView)
            ])
        
        backView.addConstraints([
            imgView02.mLay(.centerX, .equal, backView),
            imgView02.mLay(.top    , .equal, backView),
            imgView02.mLay(.width  , .equal, backView, multiplier: 1.0 / 3.0 , constant: 0),
            imgView02.mLay(.height , .equal, backView)
            ])
        
        backView.addConstraints([
            imgView03.mLay(.right  , .equal, backView),
            imgView03.mLay(.bottom , .equal, backView),
            imgView03.mLay(.width  , .equal, backView, multiplier: 1.0 / 3.0 , constant: 0),
            imgView03.mLay(.height , .equal, backView)
            ])
    }
}

extension ScrollPage : UIScrollViewDelegate {
    // UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        func change(){
            pageControl.currentPage = page
            imgView01.image = UIImage(named: imgNameArray[page != 0 ? page - 1 : imgNameArray.count-1] )
            imgView02.image = UIImage(named: imgNameArray[page])
            imgView03.image = UIImage(named: imgNameArray[page != imgNameArray.count-1 ? page + 1 : 0])
            scrollView.contentOffset.x = scrollView.frame.width
        }
        
        if scrollView.contentOffset.x == 0 { // 向左滑
            page != 0 ? ( page -= 1 ): ( page = imgNameArray.count - 1 )
            change()
        } else if scrollView.contentOffset.x == scrollView.frame.width * CGFloat(2) { // 向右滑
            page != imgNameArray.count - 1 ? ( page += 1 ) : ( page = 0 )
            change()
        }
        
    }
    
    // 開始滑動scrollView
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        duration != 0 ? ( self.removeTimer() ) : ()
    }
    
    // scrollView減速停止後
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        duration != 0 ? ( self.addTimer() ) : ()
    }
}

// MARK:- Timer 相關
extension ScrollPage {
    // 加上 Timer
    func addTimer(){
        self.removeTimer()
        self.timer = Timer(timeInterval: duration, target: self, selector: #selector(ScrollPage.updateTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer!, forMode: RunLoopMode.commonModes)
    }
    
    // 移除 Timer
    func removeTimer(){
        self.timer?.invalidate()
        self.timer = nil
    }
    
    // Timer 每次的動作
    func updateTimer(){
        var frame = scroll.frame
        frame.origin.x = scroll.frame.size.width * 2
        frame.origin.y = 0
        scroll.scrollRectToVisible(frame , animated: true)
    }
    
}


// 自己建立的簡單的使用 AutoLayout
extension UIView{
    
    // 便利使用的 NSLayoutConstraint
    func mLay(_ attribute:NSLayoutAttribute,_ relatedBy:NSLayoutRelation,_ toItem:Any?,_ attribute1:NSLayoutAttribute , multiplier: CGFloat , constant: CGFloat)->NSLayoutConstraint{
        self.translatesAutoresizingMaskIntoConstraints = false
        return NSLayoutConstraint(item: self, attribute: attribute, relatedBy: relatedBy, toItem: toItem, attribute: attribute1, multiplier: multiplier, constant: constant)
    }
    
    // 便利使用的 NSLayoutConstraint
    func mLay(_ attribute:NSLayoutAttribute,_ relatedBy:NSLayoutRelation,_ toItem:Any?)->NSLayoutConstraint{
        return mLay(attribute, relatedBy, toItem, attribute, multiplier:1, constant:0)
    }
    
    // 便利使用的 NSLayoutConstraint
    func mLay(_ attribute:NSLayoutAttribute,_ constant: CGFloat)->NSLayoutConstraint{
        return mLay(attribute, .equal, nil, attribute,multiplier: 1, constant:constant)
    }
    
    // 便利使用的 NSLayoutConstraint
    func mLay(_ attribute:NSLayoutAttribute,_ relatedBy:NSLayoutRelation,_ toItem:Any?, multiplier: CGFloat, constant: CGFloat)->NSLayoutConstraint{
        return mLay(attribute, relatedBy , toItem, attribute, multiplier:multiplier, constant:constant)
    }
    // 便利使用的 NSLayoutConstraint
    func mLay(_ attribute:NSLayoutAttribute,_ relatedBy:NSLayoutRelation,_ toItem:Any?,  constant: CGFloat)->NSLayoutConstraint{
        return mLay(attribute, relatedBy , toItem, attribute, multiplier:1, constant:constant)
    }
    // 便利使用的 NSLayoutConstraint
    func mLay(_ attribute:NSLayoutAttribute,_ relatedBy:NSLayoutRelation,_ toItem:Any?,_ attribute1:NSLayoutAttribute ,constant: CGFloat)->NSLayoutConstraint{
        return mLay(attribute, relatedBy , toItem, attribute1, multiplier:1, constant:constant)
    }
    
}

