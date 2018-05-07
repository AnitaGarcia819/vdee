//
//  ContentViewController.swift
//  vdee
//
//  Created by Nicholas Rosas on 5/6/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

import UIKit
import ISHPullUp

class ContentViewController: UIViewController, ISHPullUpContentDelegate {

    @IBOutlet weak var rootView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, update edgeInsets: UIEdgeInsets, forContentViewController contentVC: UIViewController) {
        // do stuff
    }

}
