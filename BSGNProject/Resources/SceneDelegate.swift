//
//  SceneDelegate.swift
//  BSGNProject
//
//  Created by Linh Thai on 13/08/2024.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        guard let userId = Auth.auth().currentUser?.uid else {
            // Not Login
            let firstVC = IntroViewController(nibName: "IntroViewController", bundle: nil)
            let navController = BaseNavigationController(rootViewController: firstVC)
            window.rootViewController = navController
            self.window = window
            window.makeKeyAndVisible()
            return
        }
        
        let ref = Database.database().reference()
        
        ref.child("users").child("doctors").child(userId).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {

//                self.fetchDoctorAttributes(userId: userId)
                let vc = DoctorHomeViewController()
                let navController = BaseNavigationController(rootViewController: vc)
//                navController.setNavigationBarHidden(true, animated: false)
                window.rootViewController = navController
                self.window = window
                window.makeKeyAndVisible()
            } else {
                ref.child("users").child("patients").child(userId).observeSingleEvent(of: .value) { (snapshot) in
                    if snapshot.exists() {
                        let vc = TabbarController()
                        let navController = BaseNavigationController(rootViewController: vc)
//                        navController.setNavigationBarHidden(true, animated: false)
                        window.rootViewController = navController
                        self.window = window
                        window.makeKeyAndVisible()
                    } else {
                        print("User data not found in either doctors or patients.")
                    }
                }
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

