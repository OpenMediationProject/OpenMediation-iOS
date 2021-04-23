// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

import UIKit
import OpenMediation
class SplashViewController: UIViewController, OMSplashDelegate {
    private var splash: OMSplash?;
    
    var logLabel = UILabel()
    
    override func viewDidLoad() {
        self.title = "Splash Ad";
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        // Do any additional setup after loading the view.
        let loadBtn:UIButton = UIButton(frame: CGRect(x: 20, y: 120, width: 120, height: 30))
        loadBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        loadBtn.backgroundColor = UIColor.white
        loadBtn.setTitleColor(UIColor.blue, for: .normal)
        loadBtn.setTitleColor(UIColor.gray, for: .highlighted)
        loadBtn.setTitleColor(UIColor.gray, for: .selected)
        loadBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        loadBtn.setTitle("Load", for: .normal)
        loadBtn.addTarget(self, action: #selector(loadBtnDidClicked), for: .touchUpInside)
        self.view.addSubview(loadBtn)
        
        let showBtn:UIButton = UIButton(frame: CGRect(x: 20, y: loadBtn.frame.maxY+20, width: 120, height: 30))
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
        
        self.splash = OMSplash(placementId: "8600", adSize: self.view.frame.size)
        self.splash?.delegate = self
    }
    
    @objc func loadBtnDidClicked(){
        self.splash?.loadAd();
        logLabel.text = "SplashAd is loading"
    }
    
    @objc func showBtnDidClicked(){
        self.splash?.show(with: self.view.window!, customView: self.view!);
    }
    
    
    /// Invoked when the splash ad is available.
    func omSplashDidLoad(_ splash: OMSplash) {
        logLabel.text = "SplashAd Did Load"
        print("SplashAd Did Load")
    }
    /// Invoked when the call to load a splash has failed.
    /// Parameter error contains the reason for the failure.
    func omSplashFail(toLoad splash: OMSplash, withError error: Error) {
        logLabel.text = "SplashAd Did Load fail"
        print("SplashAd Did Load fail")
    }
    
    /// Invoked when the splash ad is shown success.
    func omSplashDidShow(_ splash: OMSplash) {
        logLabel.text = "SplashAd Did Show"
        print("SplashAd Did Show")
    }
    /// Invoked when the splash ad is shown fail.
    func omSplashDidFail(toShow splash: OMSplash, withError error: Error) {
        logLabel.text = "SplashAd Fail To Show"
        print("SplashAd Fail To Show")
    }
    /// Invoked when the user clicks on the splash ad.
    func omSplashDidClick(_ splash: OMSplash) {
        logLabel.text = "SplashAd Did Click"
        print("SplashAd Did Click")
    }
    /// Invoked when the splash ad has been closed.
    func omSplashDidClose(_ splash: OMSplash) {
        logLabel.text = "SplashAd Did Close"
        print("SplashAd Did Close")
    }
}
