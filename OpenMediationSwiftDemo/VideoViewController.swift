// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

import UIKit
import OpenMediation

class VideoViewController: UIViewController, OMRewardedVideoDelegate {
    
    var logLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Video"
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
        
        logLabel = UILabel(frame: CGRect(x: 20, y: showBtn.frame.maxY+20, width: 120, height: 30))
        logLabel.text = "Log"
        logLabel.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(logLabel)
        
        OMRewardedVideo.sharedInstance().add(self);
    }
    
    // Scene is optional，if you don't want to use it just ignore the sceneName parameter or use value "". 
    @objc func showBtnDidClicked(){
        if OMRewardedVideo.sharedInstance().isReady() {
            OMRewardedVideo.sharedInstance().show(with: self, scene: "YOUR_SCENE_NAME")
        }
    }
    
    func adtimingRewardedVideoChangedAvailability(_ available: Bool) {
        if available {
            print("VideoAd is Available")
            logLabel.text = "ad available"
        }
    }
    
    /// Invoked when rewarded video is available.
    func omRewardedVideoChangedAvailability(_ available: Bool) {
        if available {
            print("VideoAd is Available")
            logLabel.text = "ad available"
        }else{
            logLabel.text = "ad inavailable"
        }
    }
    
    /// Sent immediately when a rewarded video is opened.
    func omRewardedVideoDidOpen(_ scene: OMScene) {
        logLabel.text = "VideoAd is Open"
        print("VideoAd is Open")
    }
    
    /// Sent immediately when a rewarded video starts to play.
    func omRewardedVideoPlayStart(_ scene: OMScene) {
        logLabel.text = "VideoAd Start Play"
        print("VideoAd Start Play")
    }
    
    /// Sent after a rewarded video has been clicked.
    func omRewardedVideoDidClick(_ scene: OMScene) {
        logLabel.text = "VideoAd is Open"
        print("VideoAd Did Click")
    }
    
    /// Send after a rewarded video has been completed.
    func omRewardedVideoPlayEnd(_ scene: OMScene) {
        logLabel.text = "VideoAd Play End"
        print("VideoAd Play End")
    }
    
    /// Sent after a rewarded video has been closed.
    func omRewardedVideoDidClose(_ scene: OMScene) {
        logLabel.text = "VideoAd Did Close"
        print("VideoAd Did Close")
    }
    
    /// Sent after a user has been granted a reward.
    func omRewardedVideoDidReceiveReward(_ scene: OMScene) {
        logLabel.text = "Receive a reward"
        print("Receive a reward")
    }
    
    /// Sent after a rewarded video has failed to play.
    func omRewardedVideoDidFail(toShow scene: OMScene, withError error: Error) {
        logLabel.text = "VideoAd failed to play"
        print("VideoAd failed to play")
    }
    
}
