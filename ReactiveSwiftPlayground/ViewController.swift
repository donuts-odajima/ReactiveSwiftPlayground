//
//  ViewController.swift
//  ReactiveSwiftPlayground
//
//  Created by odajima.naoki on 2020/09/09.
//  Copyright © 2020 Naoki Odajima. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import UIKit

/*
 incrementButton を押した時に count の値が1増える
 decrementButton を押した時に count の値が1減る
 count が変更された時に countLabel のテキストの値を count と同期する
 */

// ReactiveCocoaを使用しない場合
final class ViewController: UIViewController {
    @IBOutlet weak private var incrementButton: UIButton!
    @IBOutlet weak private var decrementButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
    }

    private func bind() {
        // incrementButton が押された時
        self.incrementButton.addTarget(self, action: #selector(self.incrementButtonPressed(_:)), for: .primaryActionTriggered)
        // decrementButton が押された時
        self.decrementButton.addTarget(self, action: #selector(self.decrementButtonPressed(_:)), for: .primaryActionTriggered)
    }

    @objc private func incrementButtonPressed(_ sender: UIButton) {
    }
    
    @objc private func decrementButtonPressed(_ sender: UIButton) {
        self.incrementButton.isSelected = !self.incrementButton.isSelected
    }
}

// ReactiveCocoaとシグナルの概念を使用した場合は以下
//final class ViewController: UIViewController {
//    @IBOutlet weak private var incrementButton: UIButton!
//    @IBOutlet weak private var decrementButton: UIButton!
//    @IBOutlet weak private var countLabel: UILabel!
//
//    private let count = MutableProperty<Int>(0)
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.bind()
//    }
//
//    private func bind() {
//        self.countLabel.reactive.text <~ self.count.producer.map { String($0) }.start(on: UIScheduler())
//
//        self.incrementButton.reactive.controlEvents(.primaryActionTriggered)
//            .map { _ in }
//            .observeValues { [weak self] in self?.count.value += 1 }
//
//        self.decrementButton.reactive.controlEvents(.primaryActionTriggered)
//            .map { _ in }
//            .observeValues { [weak self] in self?.count.value -= 1 }
//    }
//}
