// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

import UIKit
import OpenMediation
class CrossPromotViewController: UIViewController, OMCrossPromotionDelegate {
    var logLabel = UILabel()
    override func viewDidLoad() {
        self.title = "Cross Promotion Ad";
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
        
        let removeBtn:UIButton = UIButton(frame: CGRect(x: 20, y: showBtn.frame.maxY+20, width: 120, height: 30))
        removeBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        removeBtn.backgroundColor = UIColor.white
        removeBtn.setTitleColor(UIColor.blue, for: .normal)
        removeBtn.setTitleColor(UIColor.gray, for: .highlighted)
        removeBtn.setTitleColor(UIColor.gray, for: .selected)
        removeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        removeBtn.setTitle("Remove", for: .normal)
        removeBtn.addTarget(self, action: #selector(removeBtnDidClicked), for: .touchUpInside)
        self.view.addSubview(removeBtn)
        
        logLabel = UILabel(frame: CGRect(x: 20, y: removeBtn.frame.maxY+20, width: 200, height: 30))
        logLabel.text = "Log"
        logLabel.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(logLabel)
        
        // Do any additional setup after loading the view.
        OMCrossPromotion.sharedInstance().add(self);
    }
    
    
    @objc func showBtnDidClicked(){
        if OMCrossPromotion.sharedInstance().isReady() {
            OMCrossPromotion.sharedInstance().showAd(withScreenPoint: CGPoint.init(x: 0.6, y: 0.3), angle: 20, scene: "")
        }
    }
    
    @objc func removeBtnDidClicked() {
        OMCrossPromotion.sharedInstance().hideAd()
    }
    
    /// Invoked when promotion ad is available.
    func omCrossPromotionChangedAvailability(_ available: Bool) {
        if available {
            print("Ad is Available")
            logLabel.text = "ad available"
        }else{
            logLabel.text = "ad invailable"
        }
    }
    
    /// Sent immediately when a promotion ad will appear.
    func omCrossPromotionWillAppear(_ scene: OMScene) {
        logLabel.text = "CrossPromotion Ad Will Appear"
        print("CrossPromotion Ad Will Appear")
    }
    
    /// Sent after a promotion ad has been clicked.
    func omCrossPromotionDidClick(_ scene: OMScene) {
        logLabel.text = "CrossPromotion Ad Did Click"
        print("CrossPromotion Ad Did Click")
    }
    
    /// Sent after a promotion ad did disappear.
    func omCrossPromotionDidDisappear(_ scene: OMScene) {
        logLabel.text = "CrossPromotion Ad Did Disappear"
        print("CrossPromotion Ad Did Disappear")
    }
    
    /// Sent after a promotion ad has failed to play.
    func omCrossPromotionDidFail(toShow scene: OMScene, withError error: Error) {
        logLabel.text = "CrossPromotion Ad Failed To Play"
        print("CrossPromotion Ad Failed To Play")
    }
    
}
