//
//  File.swift
//  moodifyV2
//
//  Created by Zoe Pacalin on 2/25/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
// CREDIT TO PUBLICALLY AVAILABLE CODE ON stack overflow, FROM WHICH THE FOLLOWING WAS PULLED:
// https://stackoverflow.com/questions/30763519/ios-segue-left-to-right

import Foundation
import UIKit
class SegueFromLeft: UIStoryboardSegue {
    override func perform() {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: {
                        dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        },
                       completion: { finished in
                        src.present(dst, animated: false, completion: nil)
        }
        )
    }
}
