//
//  ContainerViewController.swift
//  hitch
//
//  Created by Shreeya Indap on 5/2/21.
//

import UIKit

class ContainerViewController: UIViewController {
    
    enum MenuState {
        case opened
        case closed
    }
    
    private var menuState: MenuState = .closed
    
    let menuVC = MenuViewController()
    let homeVC = ViewController()
    lazy var profileVC = ProfileViewController()
    lazy var historyVC = PastRidesViewController()
    var navVC: UINavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVCs()

        // Do any additional setup after loading the view.
    }
    
    private func addChildVCs(){
        menuVC.delegate = self
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        
        let navVC = UINavigationController(rootViewController: homeVC)
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        self.navVC = navVC
        homeVC.delegate = self
//        addChild(homeVC)
//        view.addSubview(homeVC.view)
//        menuVC.didMove(toParent: self)
    }
    
}

extension ContainerViewController: ViewControllerDelegate {
    func settingsButtonPressed() {
        toggleMenu(completion: nil)
    }
    
    func toggleMenu(completion: (() -> Void)?){
    switch menuState{
    case .closed:
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.navVC?.view.frame.origin.x = self.homeVC.view.frame.size.width - 100
        } completion: { [weak self] done in
            if done {
                self?.menuState = .opened
            }
        }

    case .opened:
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.navVC?.view.frame.origin.x = 0
        } completion: { [weak self] done in
            if done {
                self?.menuState = .closed
                DispatchQueue.main.async {
                    completion?()
                }
            }
        }
    }
    }
}

extension ContainerViewController: MenuViewControllerDelegate {

    func didSelect(menuItem: MenuViewController.MenuOptions) {
        toggleMenu(completion: nil)
        switch menuItem {
        case .home:
            self.resetToHome()
        case .profile:
            self.addInfo()
        case .history:
            self.showHistory()
        }
    }

    func addInfo() {
        let vc = profileVC
        homeVC.addChild(vc)
        homeVC.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: homeVC)
    }

    func showHistory() {
        let vc = historyVC
        homeVC.addChild(vc)
        homeVC.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: homeVC)
    }
    
    func showHome() {
        let vc = homeVC
        homeVC.addChild(vc)
        homeVC.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: homeVC)
    }

    func resetToHome() {
        profileVC.view.removeFromSuperview()
        historyVC.view.removeFromSuperview()
        profileVC.didMove(toParent: nil)
        historyVC.didMove(toParent: nil)
    }
    
    //https://www.youtube.com/watch?v=1hzPFAYcuUI

}
