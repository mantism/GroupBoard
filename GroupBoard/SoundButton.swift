//
//  SoundButton.swift
//  GroupBoard
//
//  Created by Mikael Mantis on 4/25/17.
//  Copyright © 2017 edu.upenn.seas.cis195. All rights reserved.
//

import UIKit

class SoundButton: UIButton {
    
    var index: Int = 0
    var title: String = ""
    var backgroundImage: UIImage?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        index = 0;
        title = "";
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setIndex(index: Int) {
        self.index = index
    }
    
    func setTitle(title: String) {
        self.title = title
    }
    
    func setImage(image: UIImage) {
        self.backgroundImage = image
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
