//
//  ScrollThreeImageView.swift
//  ScrollThreePages
//
//  Created by LinNick on 2016/1/3.
//  Copyright © 2016年 LinNick. All rights reserved.
//

import UIKit

class ScrollThreeImageView: UIView,UIScrollViewDelegate{
    
    var imageNameArray = [""]
    var duration : Double = 1
    private var contenView : UIView = UIView()
    private var scrollView : UIScrollView = UIScrollView()
    private var pageControl : UIPageControl = UIPageControl()
    private var imageView01 : UIImageView = UIImageView()
    private var imageView02 : UIImageView = UIImageView()
    private var imageView03 : UIImageView = UIImageView()
    private var pageNumber : Int = 0
    private var timer : NSTimer?
    
    init(frame:CGRect,imageName : [String],duration:Double){
    //  nick feature 2  super.init(frame:frame)
        imageNameArray = imageName
        self.duration = duration
        contenView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        scrollView = UIScrollView(frame: contenView.frame)
        scrollView.pagingEnabled = true
        let scfw = scrollView.frame.width
        let scfh = scrollView.frame.height
        scrollView.contentSize = CGSize(width: scfw * 3, height: scfh)
        imageView01 = UIImageView(frame: CGRect(x: scfw * CGFloat(0), y: 0, width: scfw, height: scfh))
        imageView02 = UIImageView(frame: CGRect(x: scfw * CGFloat(1), y: 0, width: scfw, height: scfh))
        imageView03 = UIImageView(frame: CGRect(x: scfw * CGFloat(2), y: 0, width: scfw, height: scfh))
        imageView01.contentMode = .ScaleAspectFit
        imageView02.contentMode = .ScaleAspectFit
        imageView03.contentMode = .ScaleAspectFit
        scrollView.contentOffset.x = scfw
        pageControl = UIPageControl(frame: CGRect(x: 10, y: self.contenView.frame.height - 50 , width: 100, height: 30))
        pageControl.currentPage = 1
        pageControl.numberOfPages = imageNameArray.count
        self.addSubview(contenView)
        contenView.addSubview(scrollView)
        scrollView.addSubview(imageView01)
        scrollView.addSubview(imageView02)
        scrollView.addSubview(imageView03)
        contenView.addSubview(pageControl)
        imageView01.image = UIImage(named: imageNameArray[imageNameArray.count-1])
        imageView02.image = UIImage(named: imageNameArray[0])
        imageView03.image = UIImage(named: imageNameArray[1])
        scrollView.delegate = self
        self.addTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- UIScrollViewDelegate
    // 開始滑動scrollView
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.removeTimer()
    }
    
    // scrollView減速停止後
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.addTimer()
    }
    
    // scrollView滑動中
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let width = self.scrollView.frame.width
        let offsetX = scrollView.contentOffset.x
        if offsetX == 0 {
            if pageNumber == 0{
                pageNumber = imageNameArray.count-1
                imageView01.image = UIImage(named: imageNameArray[pageNumber-1])
                imageView02.image = UIImage(named: imageNameArray[pageNumber])
                imageView03.image = UIImage(named: imageNameArray[0])
                scrollView.contentOffset = CGPointMake(width, 0)
            }else if pageNumber == imageNameArray.count - 1{
                pageNumber = pageNumber - 1
                imageView01.image = UIImage(named: imageNameArray[pageNumber-1])
                imageView02.image = UIImage(named: imageNameArray[pageNumber])
                imageView03.image = UIImage(named: imageNameArray[0])
                scrollView.contentOffset = CGPointMake(width, 0)
            }else if pageNumber == 1{
                pageNumber = pageNumber - 1
                imageView01.image = UIImage(named: imageNameArray[imageNameArray.count-1])
                imageView02.image = UIImage(named: imageNameArray[pageNumber])
                imageView03.image = UIImage(named: imageNameArray[pageNumber+1])
                scrollView.contentOffset = CGPointMake(width, 0)
            }else{
                pageNumber = pageNumber - 1
                imageView01.image = UIImage(named: imageNameArray[pageNumber-1])
                imageView02.image = UIImage(named: imageNameArray[pageNumber])
                imageView03.image = UIImage(named: imageNameArray[pageNumber+1])
                scrollView.contentOffset = CGPointMake(width, 0)
            }
        }
        if offsetX == width * CGFloat(2) {
            if pageNumber == imageNameArray.count - 1 {
                pageNumber = 0
                imageView01.image = UIImage(named: imageNameArray[imageNameArray.count - 1])
                imageView02.image = UIImage(named: imageNameArray[pageNumber])
                imageView03.image = UIImage(named: imageNameArray[pageNumber + 1])
                scrollView.contentOffset = CGPointMake(width, 0)
            }else if pageNumber == imageNameArray.count - 2 {
                pageNumber = pageNumber + 1
                imageView01.image = UIImage(named: imageNameArray[pageNumber - 1])
                imageView02.image = UIImage(named: imageNameArray[pageNumber])
                imageView03.image = UIImage(named: imageNameArray[0])
                scrollView.contentOffset = CGPointMake(width, 0)
            }else {
                pageNumber = pageNumber + 1
                imageView01.image = UIImage(named: imageNameArray[pageNumber-1])
                imageView02.image = UIImage(named: imageNameArray[pageNumber])
                imageView03.image = UIImage(named: imageNameArray[pageNumber+1])
                scrollView.contentOffset = CGPointMake(width, 0)
            }
        }
        pageControl.currentPage = pageNumber
    }
    
    // MARK:- 自動播放
    func addTimer(){
        self.removeTimer()
        self.timer = NSTimer(timeInterval: duration, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
    }
    
    func removeTimer(){
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func updateTimer(){
        let width = self.scrollView.frame.width
        var frame = scrollView.frame
        frame.origin.x = frame.size.width + width
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame , animated: true)
    }
}


