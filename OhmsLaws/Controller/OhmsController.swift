//
//  OhmsController.swift
//  OhmsLaws
//
//  Created by Matthew Curtner on 8/8/18.
//  Copyright © 2018 Matthew Curtner. All rights reserved.
//

import UIKit

struct Ohms {
    var volts: Double?
    var amps: Double?
    var ohms: Double?
    var watts: Double?
    
    init(volts: Double?, amps: Double?, ohms: Double?, watts: Double?) {
        self.volts = volts
        self.amps = amps
        self.ohms = ohms
        self.watts = watts
    }
}

class OhmsController {
    private var ohms: Ohms?
    private var roundingDigit: Int?
    
    required init(object: Ohms?) {
        self.ohms = object
    }
    
    func calculate() -> Ohms! {
        // Volts
        if let o = ohms?.ohms {
            if let a = ohms?.amps {
                ohms?.volts = (o * a)
            }
        }
        
        if let a = ohms?.amps {
            if let w = ohms?.watts {
                ohms?.volts = (a / w)
            }
        }
        
        if let o = ohms?.ohms {
            if let w = ohms?.watts {
                ohms?.volts = sqrt(o * w)
            }
        }
        
        // Amps
        if let v = ohms?.volts {
            if let o = ohms?.ohms {
                ohms?.amps = v / o
            }
        }
        
        if let w = ohms?.watts {
            if let v = ohms?.volts {
                ohms?.amps = w / v
            }
        }
        
        if let w = ohms?.watts {
            if let o = ohms?.ohms {
                ohms?.amps = sqrt(w / o)
            }
        }
        
        // Ohms
        if let v = ohms?.volts {
            if let a = ohms?.amps {
                ohms?.ohms = v / a
            }
        }
        
        if let v = ohms?.volts {
            if let w = ohms?.watts {
                ohms?.ohms = (pow(v , 2.0) / w)
            }
        }
        
        if let w = ohms?.watts {
            if let a = ohms?.amps {
                ohms?.ohms = (w / pow(a, 2.0))
            }
        }
        
        // Watts
        
        if let v = ohms?.volts {
            if let a = ohms?.amps {
                ohms?.watts = v * a
            }
        }
        
        if let o = ohms?.ohms {
            if let a = ohms?.amps {
                ohms?.watts = (o * pow(a, 2.0))
            }
        }
        
        if let v = ohms?.volts {
            if let o = ohms?.ohms {
                ohms?.watts = (pow(v, 2.0) / o)
            }
        }
        
        
        return ohms
    }
}

