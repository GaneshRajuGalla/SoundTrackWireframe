//
//  SceneDelegate.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 31/05/23.
//

import UIKit
import FacebookCore
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController!
    var coordinator: NavigationCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        setRootView(scene: scene)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called when the scene is being released by the system.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene becomes active.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene moves from active to inactive.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions to the foreground.
        Utility.shared.fireNotification(.movingToBackground, object: false, userInfo: [:])
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        Utility.shared.fireNotification(.movingToBackground, object: true, userInfo: [:])
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }

    func setRootView(scene: UIWindowScene) {
        let window = UIWindow(windowScene: scene)
        let coordinator = NavigationCoordinator()
        self.coordinator = coordinator // Keep reference if needed

        if UserDefaultManager.shared.get(for: .isSubscribed) == true {
            navigationController = UINavigationController(rootViewController: SelectEmotionTypeVC.getVC(.dashBoard))
        } else {
            let welcomeView = WelcomeToZentraView()
                .environmentObject(coordinator)
            let hostingController = UIHostingController(rootView: welcomeView)
            navigationController = UINavigationController(rootViewController: hostingController)
            coordinator.navigationController = navigationController
        }

        navigationController.isNavigationBarHidden = true
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}
