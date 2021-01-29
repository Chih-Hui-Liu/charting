//
//  WelcomeViewController.swift
//  charting
//
//  Created by Leo on 2021/1/27.
//

import UIKit
import Lottie
class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let animationView = AnimationView(name: "conversation")
       animationView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
       animationView.center = self.view.center
       animationView.contentMode = .scaleAspectFill
       animationView.loopMode = .repeat(5.0)
       view.addSubview(animationView)
       animationView.play()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true //初始畫面不要顯示NavigationBar
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false//下一頁出現NavigationBar
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
