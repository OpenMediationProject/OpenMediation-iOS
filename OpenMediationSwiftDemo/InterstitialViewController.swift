// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

import UIKit
import OpenMediation
class InterstitialViewController: UIViewController, OMInterstitialDelegate {
    
    var logLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Interstitial"
        self.view.backgroundColor = UIColor.white
        
        let showBtn:UIButton = UIButton(frame: CGRect(x: 20, y: 120, width: 120, height: 30))
        showBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        showBtn.backgroundColor = UIColor.white
        showBtn.setTitleColor(UIColor.blue, for: .normal)
        showBtn.setTitleColor(UIColor.gray, for: .highlighted)
        showBtn.setTitleColor(UIColor.gray, for: .selected)
        showBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        showBtn.setTitle("Show", for: .normal)
        showBtn.addTarget(self, action: #selector(showBtnDidClicked), for: .touchUpInside)
        self.view.addSubview(showBtn)
        
        logLabel = UILabel(frame: CGRect(x: 20, y: showBtn.frame.maxY+20, width: 200, height: 30))
        logLabel.text = "Log"
        logLabel.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(logLabel)
        
        OMInterstitial.sharedInstance().add(self);
    }
    
    // Scene is optional，if you don't want to use it just ignore the sceneName parameter or use value "". 
    @objc func showBtnDidClicked(){
        if OMInterstitial.sharedInstance().isReady() {
            OMInterstitial.sharedInstance().show(with: self, scene: "YOUR_SCENE_NAME")
        }
    }
    
    /// Invoked when interstitial video is available.
    func omInterstitialChangedAvailability(_ available: Bool) {
        if available {
            print("InterstitialAd is Available")
            logLabel.text = "ad available"
        }else{
            logLabel.text = "ad invailable"
        }
    }
    
    /// Sent immediately when a interstitial video is opened.
    func omInterstitialDidOpen(_ scene: OMScene) {
        logLabel.text = "InterstitialAd is Open"
        print("InterstitialAd is Open")
    }
    
    /// Sent immediately when a interstitial video starts to play.
    func omInterstitialDidShow(_ scene: OMScene) {
        logLabel.text = "InterstitialAd Start Play"
        print("InterstitialAd Start Play")
    }
    
    /// Sent after a interstitial video has been clicked.
    func omInterstitialDidClick(_ scene: OMScene) {
        logLabel.text = "InterstitialAd Did Click"
        print("InterstitialAd Did Click")
    }
    
    /// Sent after a interstitial video has been closed.
    func omInterstitialDidClose(_ scene: OMScene) {
        logLabel.text = "InterstitialAd Did Close"
        print("InterstitialAd Did Close")
    }
    
    /// Sent after a interstitial video has failed to play.
    func omInterstitialDidFail(toShow scene: OMScene, withError error: Error) {
        logLabel.text = "InterstitialAd failed to play"
        print("InterstitialAd failed to play")
    }
}
