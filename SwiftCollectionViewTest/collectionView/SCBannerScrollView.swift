//
//  SCCollectionView.swift
//  SwiftCollectionViewTest
//
//  Created by muzhou on 2018/5/3.
//  Copyright © 2018年 muzhou. All rights reserved.
//

import UIKit
import Foundation

@objc public enum SCImageType: Int{
    case SCImageTypeImageUrl
    case SCImageTypeImageName
}

public typealias ItemDidClickEdBlock = (_ currentIndex: Int) -> Void

class SCBannerScrollView: UIView ,UICollectionViewDelegate, UICollectionViewDataSource {

    private var scTimer: Timer?
    
    //设置传入数据类型，图片或者是imageurl,默认为imageurl
    @objc public var imageType: SCImageType = .SCImageTypeImageUrl{
        didSet{
            if (self.imageArray?.count)!>0 {
                
            }
        }
    }
    
    @objc public var imageArray:Array<String>?{
        didSet{
            invalidateTimer()
            if(imageArray!.count>0){
                setUpPageControl()
                setupTimer()
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc public var currentPageIndicatorTintColor: UIColor = UIColor.red{
        didSet{
            if self.pageControl != nil{
                self.pageControl?.currentPageIndicatorTintColor = currentPageIndicatorTintColor
            }
        }
    }
    
    @objc public var pageIndicatorTintColor: UIColor = .blue{
        didSet{
            if self.pageControl != nil {
                self.pageControl?.pageIndicatorTintColor = pageIndicatorTintColor
            }
        }
    }
    
    
    @objc public var itemDidClickedBlock: ItemDidClickEdBlock?
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        var width: CGFloat = UIScreen.main.bounds.width
        
        flowLayout.itemSize = CGSize.init(width:width,height:self.bounds.height)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        flowLayout.sectionInset = UIEdgeInsetsMake(0,0, 0, 0)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0

        return flowLayout;
    }()
    
    private lazy var collectionView:UICollectionView = {
        var scwidth: CGFloat = self.bounds.width
        var scheight: CGFloat = self.bounds.height
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: scwidth, height: scheight), collectionViewLayout: self.collectionViewFlowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.scrollsToTop = false
        collectionView.backgroundColor = UIColor.white
        collectionView.bounces = false
        collectionView.register(SCBannerScrollViewCell.self, forCellWithReuseIdentifier: "cell")
        
        self.addSubview(collectionView)
        return collectionView
    }()
    
    private var pageControl: UIPageControl?
    
    /// 是否自动轮播
    @objc public var autoScroll = true {
        didSet {
            self.invalidateTimer()
            if autoScroll {
                self.setupTimer()
            }
        }
    }
    
    /// 自动轮播间隔时间
    @objc public var autoScrollTimeInterval: TimeInterval = 5.0 {
        didSet {
            self.invalidateTimer()
            if autoScrollTimeInterval > 0 {
                self.setupTimer()
            }
        }
    }
    
    private func setUpPageControl() {
        
        if self.pageControl != nil {
            self.pageControl?.removeFromSuperview()
        }
        
        let pageControl = UIPageControl()
        pageControl.numberOfPages = self.imageArray!.count
        pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor
        pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor
        pageControl.isUserInteractionEnabled = false
        pageControl.currentPage = currentIndex()
        pageControl.center.x = self.center.x
        let width: Int = Int(self.imageArray!.count * 20)
        pageControl.frame = CGRect(x: (Int(self.frame.size.width) - width)/2, y: Int(self.frame.size.height - 20), width: width, height: 10)
        self.addSubview(pageControl)
        self.pageControl = pageControl
        
        if self.imageArray!.count == 1 {
            self.pageControl!.isHidden = true
        }else{
            self.pageControl!.isHidden = false
        }
    }
    
    
    private func currentIndex() -> Int {
        if collectionView.frame.width == 0 || collectionView.frame.height == 0 {
            return 0
        }
        
        var index = 0

        index = Int((self.collectionView.contentOffset.x + self.collectionViewFlowLayout.itemSize.width * 0.5) / self.collectionViewFlowLayout.itemSize.width)

        return max(0, index)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.collectionView.bounds = self.bounds
        setupTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.imageArray!.count == 1 {
            return 1
        }
        return self.imageArray!.count + 2
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SCBannerScrollViewCell
        cell.setCellImage(imageName: self.imageArray![indexPath.row % self.imageArray!.count], imageType: self.imageType)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.itemDidClickedBlock != nil {
            self.itemDidClickedBlock!(indexPath.row % self.imageArray!.count)
        }
    }
}

// MARK: - 手动滚动
extension SCBannerScrollView {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.invalidateTimer()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        self.setupTimer()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        var index:Float
        index = Float(scrollView.contentOffset.x * 1.0 / scrollView.frame.size.width)
        
        if index < 0.25 {
            self.collectionView.scrollToItem(at: IndexPath(item: self.imageArray!.count, section: 0), at: [.top,.left], animated: false)
        }else if index >= Float(self.imageArray!.count+1) {
            self.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: [.top,.left], animated: false)
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var index:Int
        index = Int(scrollView.contentOffset.x * 1.0 / scrollView.frame.size.width)
        self.pageControl!.currentPage = index%self.imageArray!.count
        print("index:\(index)")
        
    }
}

// MARK: - auto滚动
extension SCBannerScrollView {
    
    public func setupTimer() {
        
        self.invalidateTimer()
        
        if self.imageArray != nil && self.imageArray!.count <= 1 {
            return
        }
        
        if self.autoScroll {
            self.scTimer = Timer.scheduledTimer(timeInterval: self.autoScrollTimeInterval, target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
            RunLoop.main.add(self.scTimer!, forMode: .commonModes)
        }
    }
    
    public func invalidateTimer() {
        if self.scTimer != nil {
            self.scTimer?.invalidate()
            self.scTimer = nil
        }
    }

    @objc private func automaticScroll() {
        var index:Int
        index = Int(self.collectionView.contentOffset.x * 1.0 / self.collectionView.frame.size.width)
        scrollToItem(targetIndex: index+1, animated: true)
    }

/// 解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
    open override func willMove(toSuperview newSuperview: UIView?) {

        if newSuperview == nil {
            self.invalidateTimer()
        }
    }

/// 手动控制滚动到某一个index
    public func makeScrollViewScrollToIndex(index: Int) {

        self.invalidateTimer()

        if self.imageArray?.count == 0 {
            return
        }
        self.scrollToItem(targetIndex: index, animated: true)
        self.setupTimer()
    }

    private func scrollToItem(targetIndex: Int, animated: Bool) {
        print("targetIndex:\(targetIndex)")
        self.pageControl!.currentPage = targetIndex%self.imageArray!.count
        self.collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: .right, animated: true)

        if(targetIndex >= self.imageArray!.count + 1){
            
            let delay = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: delay) {
                self.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .right, animated: false)
            }
            
        }
    }

}


extension UIColor {
    //返回随机颜色
    class var randomColor: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}
