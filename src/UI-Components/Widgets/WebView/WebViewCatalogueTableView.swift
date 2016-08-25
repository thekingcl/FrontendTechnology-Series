//
//  WebViewCatalogueTableView.swift
//  iOSBoilerplate
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 WXChevalier. All rights reserved.
//

import UIKit

class WebViewCatalogueTableView: UITableViewController {
    
    
    @IBOutlet weak var Cordova: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //CODE TO BE RUN ON CELL TOUCH
        switch indexPath.row {
        case 0:
            NSLog("Cordova")
            let cordovaService = CordovaContainer.getSingletonInstance()
            cordovaService.startPage("index.html",fromViewController: self)
            
            break
        default:
            break
        }
    }
    
    
}


