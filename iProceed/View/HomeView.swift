//
//  HomeView.swift
//  iProceed
//
//  Created by Mac-Mini_2021 on 25/11/2021.
//

import UIKit
import Lottie

class HomeView: UIViewController {
    
    // iboutlet
    @IBOutlet weak var animationview: AnimationView!
    
    // lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lottieAnimation()
    }
    
    // methods
    func lottieAnimation() {
        let animationview = AnimationView(name : "61425-light-learning")
        
        animationview.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        animationview.center = self.view.center
        animationview.contentMode = .scaleAspectFit
        view.addSubview(animationview)
        animationview.play()
        animationview.loopMode = .loop
    }
    
}
