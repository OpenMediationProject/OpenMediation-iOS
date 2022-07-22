// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

import UIKit
import AppTrackingTransparency
import OpenMediation
import FBAudienceNetwork
import AdSupport

var welcomeLab = UILabel()

class WelcomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let itemBtn = UIBarButtonItem.init(title: "Ad", style: .plain, target: self, action: #selector(showItemAction))
        self.navigationItem.rightBarButtonItem = itemBtn
        
        var idfaBtn = UIButton.init(type: UIButton.ButtonType.system)
        idfaBtn = UIButton(frame: CGRect(x: 0, y: self.view.frame.size.height/3.0*2.0 - 100, width: self.view.frame.size.width, height: 50))
        idfaBtn.setTitleColor(UIColor.systemBlue, for: .normal)
        idfaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        idfaBtn.setTitle("RequestIDFAAuthorization", for: .normal)
        idfaBtn.addTarget(self, action: #selector(idfaBtnDidClicked), for: .touchUpInside)
        self.view.addSubview(idfaBtn)
        
        NotificationCenter.default.addObserver(self, selector: #selector(initSuccess), name: Notification.Name("kOpenMediatonInitSuccessNotification"), object: nil)
        
        
        welcomeLab = UILabel.init(frame: CGRect(x: 0, y: 200, width: self.view.frame.size.width, height: 200))
        welcomeLab.textAlignment = .center
        welcomeLab.numberOfLines = 0
        
        let buildDate = NSString()
        let dateformatter = DateFormatter()
        dateformatter.locale = NSLocale.init(localeIdentifier: "en_US") as Locale
        dateformatter.dateFormat = "MMM dd yyyy HH:mm:ss"
        let date = dateformatter.date(from: buildDate as String) ?? Date.init()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateformatter.timeZone = NSTimeZone.system
        let dateStr = dateformatter.string(from: date)
        let version: String = OpenMediation.sdkVersion()
        
        welcomeLab.text = "V" + version + "\n\n" + dateStr
        self.view.addSubview(welcomeLab)
        
    }
    
    @objc func initSuccess() {
        welcomeLab.text = welcomeLab.text?.appending("\n\nOpenMediation init success!!!")
    }
    
    @objc func showItemAction() {
        self.navigationController?.pushViewController(ViewController(), animated: true)
        
        
    }
    
    @objc func idfaBtnDidClicked() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { (status) in
                let anyClass: AnyClass? = NSClassFromString("FBAdSettings")
                guard let typeClass = anyClass as? FBAdSettings.Type else { return }
                let selector = NSSelectorFromString("setAdvertiserTrackingEnabled:")
                if typeClass.responds(to: selector) == true {
                    typeClass.setAdvertiserTrackingEnabled(status == .authorized)
                    if status == .authorized {
                        let idfa:String = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                        print("IDFA: %@",idfa)
                    }else{
                        print("The authorization status %@",status)
                    }
                }
            }
        }
    }
    
}
