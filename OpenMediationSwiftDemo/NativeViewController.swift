// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

import UIKit
import OpenMediation

class NativeViewController: UIViewController, OMNativeDelegate {
    
    private lazy var iconView: UIImageView = {
        let icon = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        return icon
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 270, width: UIScreen.main.bounds.size.width, height: 15))
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        return titleLabel
    }()
    
    private lazy var bodyLabel: UILabel = {
        let bodyLabel = UILabel(frame: CGRect(x: 0, y: 285, width: UIScreen.main.bounds.size.width, height: 15))
        bodyLabel.font = UIFont.systemFont(ofSize: 13)
        return bodyLabel
    }()
    
    var nativeAd: OMNativeAd?
    private lazy var nativeView: OMNativeView = {
        let view = OMNativeView(frame: CGRect(x: 0, y: 300, width: self.view.frame.size.width, height: 300))
        view.mediaView = OMNativeMediaView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 300))
        view.addSubview(view.mediaView)
        view.addSubview(self.iconView)
        view.addSubview(self.titleLabel)
        view.addSubview(self.bodyLabel)
        return view
    }()
    
    private lazy var native: OMNative = {
        let native = OMNative(placementID: "4937")
        native.delegate = self
        self.view.addSubview(nativeView)
        return native
    }()
    
    var logLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Native"
        self.view.backgroundColor = UIColor.white
        
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
    }
    
    @objc func loadBtnDidClicked(){
        logLabel.text = "NativeAd is Loading"
        print("NativeAd is Loading");
        self.native.loadAd()
    }
    
    @objc func showBtnDidClicked(){
        if self.nativeAd==nil {
            return;
        }
        self.nativeView.isHidden = false
        self.nativeView.nativeAd = self.nativeAd!
        self.iconView.image = UIImage(data: try! Data(contentsOf: URL(string: self.nativeAd?.iconUrl ?? "")!))
        self.titleLabel.text = self.nativeAd?.title
        self.bodyLabel.text = self.nativeAd?.body
    }
    
    /// Invoked when the ad is available.
    /// You can then show the ad.
    func omNative(_ native: OMNative, didLoad nativeAd: OMNativeAd) {
        logLabel.text = "NativeAd Did Load"
        print("NativeAd Did Load")
        self.nativeAd = nativeAd
    }
    
    /// Invoked when the call to load an ad has failed.
    /// Parameter error contains the reason for the failure.
    func omNativeDidFail(toLoad native: OMNative, withError error: Error) {
        logLabel.text = "NativeAd Did Fail"
        print("NativeAd Did Fail")
    }
    
    /// Invoked when the Ad begins to show.
    func omNativeWillExposure(_ native: OMNative) {
        logLabel.text = "NativeAd Will Exposure"
        print("NativeAd Will Exposure")
    }
    
    /// Invoked when the ad finishes playing.<
    func omNativeDidClick(_ native: OMNative) {
        logLabel.text = "NativeAd Did Click"
        print("NativeAd Did Click")
    }
    
}


