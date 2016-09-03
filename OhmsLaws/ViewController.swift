//
//  ViewController.swift
//  OhmsLaws
//
//  Created by Matthew Curtner on 9/3/16.
//  Copyright © 2016 Matthew Curtner. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, GADBannerViewDelegate {
    @IBOutlet weak var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let request = GADRequest();
        request.testDevices = [kGADSimulatorID]
        
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-9801328113033460/3521494233"
        bannerView.rootViewController = self
        bannerView.load(request)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

