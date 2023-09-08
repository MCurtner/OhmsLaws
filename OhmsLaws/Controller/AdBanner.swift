//
//  AdBanner.swift
//  OhmsLaws
//
//  Created by Matthew Curtner on 8/21/18.
//  Copyright © 2018 Matthew Curtner. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdBanner: NSObject, GADBannerViewDelegate {
    
    // Ad Unit ID
    private let ad_unit_id = "ca-app-pub-9801328113033460/3521494233"
    
    enum Position {
        case top, bottom
    }
    
    enum Orientation {
        case portrait, landscape
    }
    
    fileprivate var vc: UIViewController!
    fileprivate var bannerView: GADBannerView!
    fileprivate var view: UIView!
    
    fileprivate var position = Position.bottom
    fileprivate var showOnRecieve = true
    fileprivate var reloadOnError = true
    fileprivate var timer: Timer!
    fileprivate var timeInterval: TimeInterval = 60
    
    private override init() {}
    
    convenience init(toViewController rootViewContrller: UIViewController, withOrientation orientation: Orientation) {
        self.init()
        self.initialize(toViewController: rootViewContrller, withOrientation: orientation)
    }
    
    convenience init(toViewController rootViewController: UIViewController,
                     at position: Position,
                     withOrientation orientation: Orientation,
                     withVolumeRatio volume: Float,
                     timeInterval seconds: TimeInterval,
                     showOnRecieve: Bool,
                     reloadOnError: Bool) {
        
        self.init()
        
        timeInterval = seconds
        self.showOnRecieve = showOnRecieve
        self.reloadOnError = reloadOnError
        self.position = position
        GADMobileAds.sharedInstance().applicationVolume = volume
        
        self.initialize(toViewController: rootViewController, withOrientation: orientation)
    }
    
    fileprivate func initialize(toViewController rootViewController: UIViewController, withOrientation orientation: Orientation) {
        let adSize = (orientation == .portrait) ? kGADAdSizeSmartBannerPortrait : kGADAdSizeSmartBannerLandscape
        bannerView = GADBannerView(adSize: adSize)
        
        bannerView.adUnitID = ad_unit_id
        bannerView.rootViewController = rootViewController
        bannerView.delegate = self
        
        self.vc = rootViewController
        self.view = rootViewController.view
        
        //startTimer()
    }
    
    deinit {
        if timer != nil {
            timer.invalidate()
        }
    }
    
    public func load() {
        bannerView.load(GADRequest())
    }
    
    public func show() {
        self.addBannerViewToView(bannerView, at: position)
        
        if position == .bottom {
            UIView.animate(withDuration: 0.25) {
                self.bannerView.frame.origin.y -= self.bannerView.frame.size.height
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                self.bannerView.frame.origin.y += self.bannerView.frame.size.height
            }
        }
    }
    
    public func remove() {
        self.bannerView.removeFromSuperview()
    }
    
    private func startTimer() {
        if nil == self.timer {
            self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(switchBannerStatus), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func switchBannerStatus() {
        self.bannerView.isHidden = !self.bannerView.isHidden
    }
    
    
    // MARK: - Positioning Ad Banner
    
    private func addBannerViewToView(_ bannerView: GADBannerView, at position: Position) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        
        
        if #available(iOS 11.0, *) {
            switch position {
            case .top: positionBannerViewFullWidthAtTopOfSafeArea(bannerView)
            default  : positionBannerViewFullWidthAtBottomOfSafeArea(bannerView)
            }
        }
        else {
            switch position {
            case .top: positionBannerViewFullWidthAtTopOfView(bannerView)
            default  : positionBannerViewFullWidthAtBottomOfView(bannerView)
            }
        }
    }
    
    
    @available (iOS 11, *)
    private func positionBannerViewFullWidthAtBottomOfSafeArea(_ bannerView: UIView) {
        // Position the banner. Stick it to the bottom of the Safe Area.
        // Make it constrained to the edges of the safe area.
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            guide.leftAnchor.constraint(equalTo: bannerView.leftAnchor),
            guide.rightAnchor.constraint(equalTo: bannerView.rightAnchor),
            guide.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor)
            ])
    }
    
    @available (iOS 11, *)
    private func positionBannerViewFullWidthAtTopOfSafeArea(_ bannerView: UIView) {
        // Position the banner. Stick it to the top of the Safe Area.
        // Make it constrained to the edges of the safe area.
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            guide.leftAnchor.constraint(equalTo: bannerView.leftAnchor),
            guide.rightAnchor.constraint(equalTo: bannerView.rightAnchor),
            guide.topAnchor.constraint(equalTo: bannerView.topAnchor)
            ])
    }
    
    // @available (iOS 7, *)
    private func positionBannerViewFullWidthAtTopOfView(_ bannerView: UIView) {
        
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: vc.topLayoutGuide,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 0))
    }
    
    private func positionBannerViewFullWidthAtBottomOfView(_ bannerView: UIView) {
        
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: vc.bottomLayoutGuide,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 0))
    }
    
    
    // MARK: - Delegation
    
    /// Tells the delegate an ad request loaded an ad.
    private func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print(#function)
        
        if showOnRecieve {
            show()
        }
    }
    
    /// Tells the delegate an ad request failed.
    private func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("\(#function): \(error.localizedDescription)")
        
        if reloadOnError {
            DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) { [weak self] in
                print("loading Ad async")
                self?.load()
            }
        }
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    private func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print(#function)
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    private func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print(#function)
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    private func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print(#function)
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) { [weak self] in
            print("re load after dismiss")
            self?.load()
        }
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    private func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print(#function)
    }
}
