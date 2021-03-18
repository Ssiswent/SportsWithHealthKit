//
//  UIView+Extension.swift
//  Futures-0814
//
//  Created by Ssiswent on 2020/8/14.
//

import UIKit
import ViewAnimator

extension UIView {
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(type(of: self).className, owner: self, options: nil)?.first as? T else {
            return nil
        }
        addSubview(contentView)
        contentView.fillSuperview()
        return contentView
    }
    
    /// 设置圆角
    /// - Parameter r: 圆角半径
    func setRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    /// 为某个角设置圆角
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - rect: 需要设置的角
    func setRadiusForRect(radius: CGFloat, rect: UIRectCorner) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: rect, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    /// 设置阴影
    func setShadow(color: UIColor, opacity: Float, radius: CGFloat, offset: CGSize) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
}

extension UIView {
    func addCornerRadiusWithShadow(color: UIColor, borderColor: UIColor, cornerRadius: CGFloat) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 6.0
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = false
    }
    
    func setCornerRadiusWith(radius: Float, borderWidth: Float, borderColor: UIColor) {
        self.layer.cornerRadius = CGFloat(radius)
        self.layer.borderWidth = CGFloat(borderWidth)
        self.layer.borderColor = borderColor.cgColor
        self.layer.masksToBounds = true
    }
    
    func zoomHideAnim(coverView: UIView, mainView: UIView) {
        let zoomAnimation = AnimationType.zoom(scale: 0.2)
        coverView.animate(animations: [AnimationType.identity], reversed: true, initialAlpha: 0.6, finalAlpha: 0, delay: 0, duration: 0.5, completion: {
            coverView.removeFromSuperview()
        })
        mainView.animate(animations: [zoomAnimation], reversed: true, initialAlpha: 1, finalAlpha: 0, delay: 0, duration: 0.5, completion: {
            mainView.removeFromSuperview()
        })
    }
    
    func zoomShowAnim(coverView: UIView, mainView: UIView) {
        coverView.backgroundColor = .black
        coverView.frame = UIScreen.main.bounds
        mainView.center = coverView.center
        
        let array = UIApplication.shared.windows
        let keyWindow = array[0]
        keyWindow.addSubview(coverView)
        keyWindow.addSubview(mainView)
        
        let zoomAnimation = AnimationType.zoom(scale: 0.2)
        coverView.animate(animations: [AnimationType.identity], reversed: true, initialAlpha: 0, finalAlpha: 0.6, delay: 0, duration: 0.5)
        mainView.animate(animations: [zoomAnimation], reversed: false, initialAlpha: 0, finalAlpha: 1, delay: 0, duration: 0.5)
    }
    
    /// 给每个角单独设置圆角
    func setCornersWith(topLeft: CGFloat, topRight: CGFloat, bottomRight: CGFloat, bottomLeft: CGFloat){
        if topLeft == 0 && topRight == 0 && bottomRight == 0 && bottomLeft == 0{
            return
        }
        let maxX = self.bounds.maxX
        let maxY = self.bounds.maxY
        //获取中心点
        let topLeftCenter = CGPoint.init(x: topLeft, y: topLeft)
        let topRightCener = CGPoint.init(x: maxX-topRight, y: topRight)
        let bottomRightCenter = CGPoint.init(x: maxX-bottomRight, y: maxY-bottomRight)
        let bottomLeftCenter = CGPoint.init(x: bottomLeft, y: maxY-bottomLeft)
        let shaperLayer = CAShapeLayer.init()
        let mutablePath = CGMutablePath.init()
        //左上
        mutablePath.addArc(center: topLeftCenter, radius: topLeft, startAngle: .pi, endAngle: .pi/2*3, clockwise:false)
        //右上
        mutablePath.addArc(center: topRightCener, radius: topRight, startAngle: .pi/2*3, endAngle:0, clockwise:false)
        //右下
        mutablePath.addArc(center: bottomRightCenter, radius: bottomRight, startAngle:0, endAngle:CGFloat(Double.pi/2), clockwise:false)
        //左下
        mutablePath.addArc(center: bottomLeftCenter, radius: bottomLeft, startAngle: .pi/2, endAngle: .pi, clockwise:false)
        shaperLayer.path = mutablePath
        self.layer.mask = shaperLayer
    }
}
