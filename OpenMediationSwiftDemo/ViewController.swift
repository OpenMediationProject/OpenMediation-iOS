// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

import UIKit
import OpenMediation
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var mainTableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        mainTableView = UITableView(frame: self.view.bounds)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        self.view.addSubview(mainTableView)
        mainTableView.rowHeight = 50
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = UITableViewCell()
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Banner"
        }else if indexPath.row == 1 {
            cell.textLabel?.text = "Native"
        }else if indexPath.row == 2 {
            cell.textLabel?.text = "Interstitial"
        }else if indexPath.row == 3 {
            cell.textLabel?.text = "Video"
        }else if indexPath.row == 4 {
            cell.textLabel?.text = "Splash"
        }else if indexPath.row == 5 {
            cell.textLabel?.text = "Cross Promotion"
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            self.navigationController?.pushViewController(BannerViewController(), animated: true)

        }else if indexPath.row == 1 {
            self.navigationController?.pushViewController(NativeViewController(), animated: true)

        }else if indexPath.row == 2 {
            self.navigationController?.pushViewController(InterstitialViewController(), animated: true)

        }else if indexPath.row == 3 {
            self.navigationController?.pushViewController(VideoViewController(), animated: true)
        }else if indexPath.row == 4 {
            self.navigationController?.pushViewController(SplashViewController(), animated: true)
        }else if indexPath.row == 5 {
            self.navigationController?.pushViewController(CrossPromotViewController(), animated: true)
        }
    }
    
    
    
}

