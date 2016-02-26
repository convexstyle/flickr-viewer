//
//  UIBezierPath+Shape.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 27/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import UIKit

extension UIBezierPath {
  
  typealias DrawSquareLineInputData = (lineWidth: CGFloat, lineCap: CGLineCap, lineJoin: CGLineJoin, strokeColor: UIColor, rect: CGRect)
  
  class func drawLine(lineWidth: CGFloat, lineCap: CGLineCap, strokeColor: UIColor, startPoint: CGPoint, endPoint: CGPoint) -> UIBezierPath {
    let path = UIBezierPath()
    strokeColor.setStroke()
    path.lineWidth = lineWidth
    path.lineCapStyle = lineCap
    path.moveToPoint(startPoint)
    path.addLineToPoint(endPoint)
    path.stroke()
    path.closePath()
    
    return path
  }
  
  class func drawCircle(lineWidth: CGFloat, lineCapStyle: CGLineCap, radius: CGFloat, center: CGPoint, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) -> UIBezierPath {
    let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
    path.lineWidth = lineWidth
    path.lineCapStyle = lineCapStyle
    
    return path
  }
  
  class func drawSquareLine(rect: CGRect, lineWidth: CGFloat, lineCapStyle: CGLineCap, lineJoin: CGLineJoin, strokeColor: UIColor) -> UIBezierPath {
    let path = UIBezierPath(rect: rect)
    strokeColor.setStroke()
    path.lineWidth = lineWidth
    path.lineCapStyle = lineCapStyle
    path.lineJoinStyle = lineJoin
    path.stroke()
    path.closePath()
    
    return path
  }
  
}