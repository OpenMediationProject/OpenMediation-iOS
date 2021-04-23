// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

import UIKit
import OpenMediation

class BannerViewController: UIViewController, OMBannerDelegate {
    
    private lazy var banner: OMBanner = {
        let banner = OMBanner(bannerType: .default, placementID: "4932");//YOUR_PLACEMENT_ID
        banner.add(.horizontally, constant: 0)
        banner.add(.vertically, constant: 0)
        banner.delegate = self
        self.view.addSubview(banner)
        return banner
    }()
    
    var logLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Banner"
        self.view.backgroundColor = UIColor.white
        
        var loadBtn = UIButton.init(type: UIButton.ButtonType.system)
        loadBtn = UIButton(frame: CGRect(x: 20, y: 120, width: 120, height: 30))
        loadBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        loadBtn.backgroundColor = UIColor.white
        loadBtn.setTitleColor(UIColor.blue, for: .normal)
        loadBtn.setTitleColor(UIColor.gray, for: .highlighted)
        loadBtn.setTitleColor(UIColor.gray, for: .selected)
        loadBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        loadBtn.setTitle("Load&Show", for: .normal)
        loadBtn.addTarget(self, action: #selector(loadBtnDidClicked), for: .touchUpInside)
        self.view.addSubview(loadBtn)
        
        logLabel = UILabel(frame: CGRect(x: 20, y: loadBtn.frame.maxY+20, width: 200, height: 30))
        logLabel.text = "Log"
        logLabel.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(logLabel)
        
    }
    
    @objc func loadBtnDidClicked(){
        logLabel.text = "BannerAd is loading"
        banner.loadAndShow()
    }
    
    /// Invoked when the banner ad is available.
    func omBannerDidLoad(_ banner: OMBanner) {
        logLabel.text = "BannerAd Did Load"
        print("BannerAd Did Load")
    }
    
    /// Invoked when the call to load a banner has failed.
    /// Parameter error contains the reason for the failure.
    func omBannerDidFail(toLoad banner: OMBanner, withError error: Error) {
        logLabel.text = "BannerAd Did Fail"
        print("BannerAd Did Fail")
    }
    
    /// Invoked when the banner ad is showing.
    func omBannerWillExposure(_ banner: OMBanner) {
        logLabel.text = "BannerAd Will Exposure"
        print("BannerAd Will Exposure")
    }
    
    /// Invoked when the user clicks on the banner ad.
    func omBannerDidClick(_ banner: OMBanner) {
        logLabel.text = "BannerAd Did Click"
        print("BannerAd Did Click")
    }
    
}



