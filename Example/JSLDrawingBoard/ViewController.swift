//
//  ViewController.swift
//  JSLDrawingBoard
//
//  Created by jason_lee_92@yahoo.com on 06/23/2019.
//  Copyright (c) 2019 jason_lee_92@yahoo.com. All rights reserved.
//

import UIKit
import JSLDrawingBoard

class ViewController: UIViewController {

    private let board = DrawingBoard()
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Back", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return button
    }()

    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Clear", for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(clearAction), for: .touchUpInside)
        return button
    }()

    private lazy var colorButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Color", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(changeColor), for: .touchUpInside)
        return button
    }()

    private lazy var strokeWidth: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("StrokeW", for: .normal)
        button.backgroundColor = .lightGray
        return button
    }()

    private lazy var strokeWidthSlider: UISlider = {
        let slider = UISlider()
        slider.maximumValue = 10
        slider.minimumValue = 0.5
        slider.addTarget(self, action: #selector(changeStrokeWidth(_:)), for: .valueChanged)
        slider.setValue(3, animated: false)
        return slider
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(board)
        buttons().forEach { button in
            view.addSubview(button)
        }
        view.addSubview(strokeWidthSlider)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bounds = view.bounds
        board.frame = bounds
        let buttonH: CGFloat = 40
        let buttonW: CGFloat = bounds.width / CGFloat(buttons().count)
        buttons().enumerated().forEach { i, button in
            button.frame = CGRect(x: buttonW * CGFloat(i), y: 50, width: buttonW, height: buttonH)
        }

        strokeWidthSlider.frame = CGRect(x: 15, y: 100, width: bounds.width - 30, height: 40)
    }

    @objc
    func backAction() {
        board.revokeLatestStroke()
    }

    @objc
    func clearAction() {
        board.clearAllStrokes()
    }

    @objc
    func changeColor() {
        let color = randomColor()
        board.brushColor = color
        colorButton.backgroundColor = color
    }

    @objc
    func changeStrokeWidth(_ slider: UISlider) {
        let width = String(format: "%.2f", slider.value)
        strokeWidth.setTitle("w:\(width)", for: .normal)
        board.brushWidth = CGFloat(slider.value)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func buttons() -> [UIButton] {
        return [backButton, clearButton, colorButton, strokeWidth]
    }

    func randomColor() -> UIColor {
        return UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1)
    }
}

