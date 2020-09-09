//
//  ViewController.swift
//  ReactiveSwiftPlayground
//
//  Created by odajima.naoki on 2020/09/09.
//  Copyright © 2020 Naoki Odajima. All rights reserved.
//

//import ReactiveCocoa
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
    @IBOutlet weak private var countLabel: UILabel!

    // 型と初期値でインスタンスを生成
    // MutablePropertyの定義にもあるが、スレッドセーフ
    private let count = MutableProperty<Int>(-3)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
    }

    private func bind() {
        // incrementButton が押された時
        self.incrementButton.addTarget(self, action: #selector(self.incrementButtonPressed(_:)), for: .primaryActionTriggered)
        // decrementButton が押された時
        self.decrementButton.addTarget(self, action: #selector(self.decrementButtonPressed(_:)), for: .primaryActionTriggered)
        // count の変更を監視する
        // producer でバインドすると MutableProperty の初期値もストリームに流れる
        self.count.producer
            .start(on: UIScheduler()) // メインスレッドで監視
            .startWithValues { [weak self] count in
                // countLabel のテキストを変更
                self?.countLabel.text = String(count)
            }
        // signal でバインドすると初期値は流れない
//        self.count.signal
//            .observe(on: UIScheduler())
//            .observeValues { [weak self] count in
//               self?.countLabel.text = String(count)
//           }
    }

    /// count を +1 する
    @objc private func incrementButtonPressed(_ sender: UIButton) {
        // .value で普通の変数と同じように set get できる
        // 後述する modify を内部で使用しているためスレッドセーフ
        self.count.value += 1
    }

    /// count を -1 する
    @objc private func decrementButtonPressed(_ sender: UIButton) {
        // 自分の値を利用して変更する時に便利
        // スレッドセーフ
        self.count.modify { $0 = $0 - 1 }
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
