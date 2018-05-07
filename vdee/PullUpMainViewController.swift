//
//  PullUpMainViewController.swift
//  vdee
//
//  Created by Nicholas Rosas on 5/6/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

import UIKit
import ISHPullUp

class PullUpMainViewController: ISHPullUpViewController {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    private func commonInit() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let contentVC = storyBoard.instantiateViewController(withIdentifier: "content") as! RadioWithPullUpViewVC
        let bottomVC = storyBoard.instantiateViewController(withIdentifier: "bottom") as! BottomVC
        contentViewController = contentVC
        bottomViewController = bottomVC
        bottomVC.pullUpController = self
        contentDelegate = contentVC
        sizingDelegate = bottomVC
        stateDelegate = bottomVC
    }
}
