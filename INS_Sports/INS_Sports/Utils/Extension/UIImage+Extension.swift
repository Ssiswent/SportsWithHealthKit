//
//  UIImage+Extension.swift
//  Futures-0814
//
//  Created by Ssiswent on 2020/8/14.
//

import UIKit

extension UIImage
{
    class func imageWithColor(color: UIColor?) -> UIImage
    {
        // 描述矩形
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)

        // 开启位图上下文
        UIGraphicsBeginImageContext(rect.size)
        // 获取位图上下文
        let context = UIGraphicsGetCurrentContext()
        // 使用color演示填充上下文
        if let cg = color?.cgColor {
            context?.setFillColor(cg)
        }
        // 渲染上下文
        context?.fill(rect)
        // 从上下文中获取图片
        let theImage = UIGraphicsGetImageFromCurrentImageContext()!
        // 结束上下文
        UIGraphicsEndImageContext()
        return theImage
    }
    
    /// 压缩图片
    /// - Parameter size: 压缩的大小(默认为102400B)
    /// - Returns: 压缩后的图片
    func compressImageSize(_ size: CGFloat? = 102400) -> UIImage
    {
        var tempImage :UIImage = self
        let fixedSize : CGFloat = size!//对图片的要求 单位：B
        var imageSize = self.pngData()
        var changeScale : CGFloat = CGFloat(fixedSize/CGFloat((imageSize?.count)!))
        var tempSize : CGFloat = CGFloat((imageSize?.count)!)
        let difference : CGFloat = 2000 //前后压缩完成后两张图片之间相差多少时返回压缩后的图片
        
        while CGFloat((imageSize?.count)!) > fixedSize {
            tempImage = UIImage(data: tempImage.jpegData(compressionQuality: CGFloat(changeScale))!)!
            imageSize = tempImage.pngData()
            changeScale = CGFloat(fixedSize / CGFloat((imageSize?.count)!))
            if tempSize - CGFloat((imageSize?.count)!) > 0 && (tempSize - CGFloat((imageSize?.count)!)) < difference {
                break
            } else if tempSize - CGFloat((imageSize?.count)!) < 0 {
                if CGFloat((imageSize?.count)!) - tempSize < difference {
                    break
                }else{
                    tempSize = CGFloat((imageSize?.count)!)
                }
            }else{
                tempSize = CGFloat((imageSize?.count)!)
            }
        }
        return tempImage
    }
    
    func originalImg() -> UIImage
    {
        let img = self.withRenderingMode(.alwaysOriginal)
        return img
    }
    
    func templateImg() -> UIImage
    {
        let img = self.withRenderingMode(.alwaysTemplate)
        return img
    }
    
    /// 设置图片透明度
    /// - Parameter alpha: 透明度
    /// - Returns: 设置了透明度的图片
    func image(byApplyingAlpha alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        let ctx = UIGraphicsGetCurrentContext()
        let area = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        ctx?.scaleBy(x: 1, y: -1)
        ctx?.translateBy(x: 0, y: -area.size.height)

        ctx?.setBlendMode(.multiply)

        ctx?.setAlpha(alpha)
        
        ctx?.draw(cgImage!, in: area)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return newImage
    }
}
