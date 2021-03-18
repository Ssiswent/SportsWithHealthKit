//
//  SSCoverView.swift
//  FuturesWithGreatBooks
//
//  Created by Ssiswent on 12/2/20.
//

import UIKit
import ViewAnimator

class SSCoverView: UIView {

    var coverView: UIView!
    
    func showCoverView() {
        let cover = UIView(frame: UIScreen.main.bounds)
        cover.backgroundColor = .black
        coverView = cover
        center = coverView.center
        
        let array = UIApplication.shared.windows
        let keyWindow = array[0]
        keyWindow.addSubview(coverView)
        keyWindow.addSubview(self)
        
        let zoomAnimation = AnimationType.zoom(scale: 0.2)
        coverView.animate(animations: [AnimationType.identity], reversed: true, initialAlpha: 0, finalAlpha: 0.6, delay: 0, duration: 0.5)
        animate(animations: [zoomAnimation], reversed: false, initialAlpha: 0, finalAlpha: 1, delay: 0, duration: 0.5)
    }

    func hideCoverView() {
        let zoomAnimation = AnimationType.zoom(scale: 0.2)
        coverView.animate(animations: [AnimationType.identity], reversed: true, initialAlpha: 0.6, finalAlpha: 0, delay: 0, duration: 0.5, completion: {
            self.coverView.removeFromSuperview()
        })
        animate(animations: [zoomAnimation], reversed: true, initialAlpha: 1, finalAlpha: 0, delay: 0, duration: 0.5, completion: {
            self.removeFromSuperview()
        })
    }

}
