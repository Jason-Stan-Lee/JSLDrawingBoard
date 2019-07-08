//
//  DrawingBoard.swift
//  DrawingBoard
//
//  Created by JasonLee on 2019/6/23.
//

import UIKit

@objc(JSLDrawingBoard)
public class DrawingBoard: UIView {

    //----------------------------------------------------------
    // MARK: Properties

    /// 笔划信息
    private var strokesInfos = [StrokeInfo]()
    /// 画笔颜色
    @objc public var brushColor = StrokeInfo.defaultColor
    /// 画笔宽度
    @objc public var brushWidth: CGFloat = StrokeInfo.defaultWidth

    //----------------------------------------------------------
    // MARK: Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //----------------------------------------------------------

    // MARK: 渲染视图
    override public func draw(_ rect: CGRect) {
        if strokesInfos.count <= 0 {
            return
        }

        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setLineCap(.round)
        context.setLineJoin(.round)

        for info in strokesInfos {

            guard let startPoint = info.points.first?.cgPointValue else {
                return
            }

            context.beginPath()
            context.move(to: startPoint)
            if info.points.count > 1 {

                for (indx, value) in info.points.enumerated() {
                    if indx == 0 {
                        continue
                    }
                    let point = value.cgPointValue
                    context.addLine(to: point)
                }
            } else {
                context.addLine(to: startPoint)
            }

            context.setStrokeColor(info.color.cgColor)
            context.setLineWidth(info.width)
            context.strokePath()
        }
    }

    // MARK: Touch Events

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        drawingBegin(point: touch.location(in: self))
    }

    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        drawingMove(point: touch.location(in: self))
    }

    // MARK: DrawingEvent

    /// 开始绘画
    private func drawingBegin(point: CGPoint) {

        let lineInfo = StrokeInfo()
        lineInfo.width = brushWidth
        lineInfo.color = brushColor
        lineInfo.points.append(NSValue(cgPoint: point))

        strokesInfos.append(lineInfo)
        self.setNeedsDisplay()
    }

    /// 画笔移动
    private func drawingMove(point: CGPoint) {
        guard let lineInfo = strokesInfos.last else {
            return
        }
        lineInfo.points.append(NSValue(cgPoint: point))
        self.setNeedsDisplay()
    }

    @objc
    public func hasEdited() -> Bool {
        return strokesInfos.count > 0
    }

    /// 撤销上一步
    @objc
    public func revokeLatestStroke() {
        if strokesInfos.count == 0 {
            return
        }
        strokesInfos.removeLast()
        self.setNeedsDisplay()
    }

    /// 清除所有笔划
    @objc
    public func clearAllStrokes() {
        if strokesInfos.count == 0 {
            return
        }
        strokesInfos.removeAll()
        self.setNeedsDisplay()
    }

}

/// 笔划信息
fileprivate class StrokeInfo: NSObject {

    static let defaultWidth: CGFloat = 3
    static let defaultColor = UIColor.black

    /// 线条所包含的点
    var points = [NSValue]()
    /// 线条颜色
    var width: CGFloat = defaultWidth
    /// 线条颜色
    var color = defaultColor

}

