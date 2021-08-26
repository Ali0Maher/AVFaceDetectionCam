//
//  UIViewController+Ext.swift
//  TestApp
//
//  Created by Ali on 8/22/21.
//

import UIKit

extension UIViewController {
    
    ///A function the open the settings permission view
    func openSettingsUIAlertView(){
        let alertController = UIAlertController (title: Global.Strings.warning, message: Global.Strings.didNotAllowPermission, preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: Global.Strings.settings, style: .default) { (_) -> Void in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                print("Couldn't Get settings urls")
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (_) in
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: Global.Strings.cancel, style: .default, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
}
