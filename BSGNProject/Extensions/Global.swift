//
//  Global.swift
//  AdmicroHybridEvent
//
//  Created by Khanh Vu on 21/9/24.
//

import Foundation
import UIKit

class Global {
    

}

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let deviceID = UIDevice.current.identifierForVendor?.uuidString

func log(_ text: String) {
    debugPrint("===== \(text)")
}

func safeAreaInset() -> UIEdgeInsets {
    return UIApplication.shared.windows.first?.safeAreaInsets ?? .zero
}

func isDarkMode() -> Bool {
    return UIScreen.main.traitCollection.userInterfaceStyle == .dark
}

func openSettings() {
    let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
    UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
}

///GCD
func mainAsync(_ completion: (() -> Void)?) {
    DispatchQueue.main.async {
        completion?()
    }
}

func mainAsyncAfter(_ deadline: CGFloat , _ completion: (() -> Void)?) {
    DispatchQueue.main.asyncAfter(deadline: .now() + deadline) {
        completion?()
    }
}

func isIpadScreen() -> Bool {
    return UIDevice.current.userInterfaceIdiom == .pad
}
