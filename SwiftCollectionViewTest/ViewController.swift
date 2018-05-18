//
//  ViewController.swift
//  SwiftCollectionViewTest
//
//  Created by muzhou on 2018/5/3.
//  Copyright © 2018年 muzhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let collectionView = SCBannerScrollView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: 200))
        collectionView.imageArray = ["http://i2.hexun.com/2017-10-20/191300981.jpg","http://i2.hexun.com/2017-10-20/191300981.jpg"]
        collectionView.currentPageIndicatorTintColor = UIColor.orange
        collectionView.pageIndicatorTintColor = UIColor.gray
        self.view.addSubview(collectionView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

