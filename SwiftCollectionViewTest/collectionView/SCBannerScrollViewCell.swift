//
//  SCCollectionViewCell.swift
//  SwiftCollectionViewTest
//
//  Created by muzhou on 2018/5/9.
//  Copyright © muzhou 朱成龙. All rights reserved.
//

import UIKit
import Kingfisher

class SCBannerScrollViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        self.imageView.frame = self.bounds
        self.contentView.addSubview(self.imageView)
    }
    
    func setCellImage(imageName: String ,imageType: SCImageType) -> Void {
//        self.imageView.image = UIImage(named: imageName)
        switch imageType {
        case .SCImageTypeImageUrl:
                self.imageView.kf.setImage(with: URL(string: imageName), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        case .SCImageTypeImageName:
                self.imageView.image = UIImage(named: imageName)
        }
    }
    
    
    
}
