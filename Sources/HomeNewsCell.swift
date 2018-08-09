//
//  RollingCell.swift
//  TestRolling
//
//  Created by fenghanxu on 2018/3/30.
//  Copyright © 2018年 fenghanxu. All rights reserved.
//

import UIKit
import FHXColorAndFont
import FHXKit
import SnapKit

public class HomeNewsCell: UITableViewCell, SPCellProtocol {

  fileprivate let newsImg1 = Asserts.findImages(named: "icon_news_1")
  fileprivate let newsImg2 = Asserts.findImages(named: "icon_news_inform")
  fileprivate let cellHeight: CGFloat = 50
  fileprivate let leftWidth: CGFloat = 110
  fileprivate let padding: CGFloat = 15
  fileprivate let paddingY: CGFloat = 10
  fileprivate var testHeight: CGFloat { get{ return cellHeight - paddingY * 2 } }

  public var model = [String]() {
    didSet{
      if model == oldValue {
        start()
        return
      }
      var arr = [String]()
      model.forEach { (item) in
        arr.append(item)
      }
      /// 解锁
      endAnimation()
      list = arr
    }
  }
  
  /// 滚动数据列表
  fileprivate var list = [String]() {
    didSet{
      var LB2Item: Int
      if list.count == 1{ LB2Item = 0
      }else { LB2Item = 1 }
      messageLB1.text = list[0]
      messageLB2.text = list[LB2Item]
      item = LB2Item
      start()
    }
  }
  // 私有属性
  fileprivate var item = 0
  fileprivate var timer: DispatchSourceTimer?
  fileprivate var isLock = false
  
  fileprivate let backView = UIView()
  fileprivate let leftView = UIView()
  fileprivate let messageView = UIView()
  fileprivate let messageLB1 = UILabel()
  fileprivate let messageLB2 = UILabel()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    buildUI()
    addTag()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - 自定义方法
extension HomeNewsCell {
  /// 开始
  func start() {
    /// 延时3秒开始动画（判断）
    DispatchAfter(after: 3) { [weak self] in
      guard let base = self else{ return }
      if base.isLock { return }
      base.isLock = true
      base.startAniamtion()
    }
  }
  /// 结束
  func endAnimation() {
    timer?.cancel()
    timer = nil
    isLock = false
  }
  
  /// 开始动画
  fileprivate func startAniamtion() {
    if timer != nil { return }
    DispatchTimer(timeInterval: 3, repeatCount: Int(INT32_MAX)) { [weak self] (timer, count) in
      guard let base = self else{ return }
      base.timer = timer
      base.animation()
    }
  }
  
  fileprivate func animation() {
    if !(sp.viewController?.sp.isVisible ?? true) {
      endAnimation()
      return
    }
    UIView.animate(withDuration: 0.5, animations: { [weak self] in
      guard let base = self else{ return }
      base.messageView.frame.origin = CGPoint(x: base.leftWidth,
                                              y: -base.testHeight)
    }) { [weak self] (true) in
      guard let base = self else{ return }
      base.messageViewReset()
    }
  }
  fileprivate func messageViewReset() {
    item += 1
    if item >= list.count { item = 0 }
    let nextText = list[item]
    messageLB1.text = messageLB2.text
    messageLB2.text = nextText
    messageView.frame.origin = CGPoint(x: leftWidth, y: 0)
  }
  
  func addTag(){
    let tag = UITapGestureRecognizer(target: self, action: #selector(tagEvent))
    addGestureRecognizer(tag)
  }
  
  @objc func tagEvent(){
    print("已点击")
//    var row = item - 1
//    if row < 0 { row = list.count - 1 }
//    guard let url = model[row] else { return }
//    let vc = Routable.viewController(url: url)
//    sp.viewController?.sp.push(vc: vc, animated: true)
  }
}

// MARK: - UI
extension HomeNewsCell {
  fileprivate func buildUI() {
    contentView.addSubview(backView)
    
    buildSubView()
    buildLayout()
  }
  
  fileprivate func buildSubView() {
    backView.layer.masksToBounds =  true
    backView.cornerRadius = 15
    backView.backgroundColor = Color.background
    backView.addSubview(leftView)
    backView.addSubview(messageView)
    
    messageLB1.font = UIFont.systemFont(ofSize: 12)
    messageLB2.font = UIFont.systemFont(ofSize: 12)
    
    buildLeftView()
    buildMessageView()
  }
  
  fileprivate func buildLeftView() {
    let imageView1 = UIImageView(image: newsImg1)
    let imageView2 = UIImageView(image: newsImg2)
    leftView.addSubview(imageView1)
    leftView.addSubview(imageView2)
    imageView1.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.left.equalToSuperview().offset(10)
    }
    imageView2.snp.makeConstraints { (make) in
      make.left.equalTo(imageView1.snp.right).offset(5)
      make.centerY.equalTo(imageView1)
    }
  }
  
  fileprivate func buildMessageView() {
    messageView.addSubview(messageLB1)
    messageView.addSubview(messageLB2)
  }
  
  
  fileprivate func buildLayout() {
    let screenW = UIScreen.main.bounds.width
    backView.frame = CGRect(x: padding, y: paddingY, width: screenW - padding * 2, height: testHeight)
    leftView.frame = CGRect(x: 0, y: 0, width: leftWidth, height: testHeight)
    let messageW = screenW - leftWidth - padding * 2
    messageView.frame = CGRect(x: leftWidth, y: 0, width: messageW, height: testHeight * 2)
    
    buildMessageLayout()
  }
  
  fileprivate func buildMessageLayout() {
    let width = messageView.frame.width - 15
    messageLB1.frame = CGRect(x: 0, y: testHeight*0, width: width, height: testHeight)
    messageLB2.frame = CGRect(x: 0, y: testHeight*1, width: width, height: testHeight)
  }
}

// MARK: - GCD
extension HomeNewsCell {
  /// GCD定时器倒计时⏳
  ///   - timeInterval: 循环间隔时间
  ///   - repeatCount: 重复次数
  ///   - handler: 循环事件, 闭包参数： 1. timer， 2. 剩余执行次数
  public func DispatchTimer(timeInterval: Double, repeatCount:Int, handler:@escaping (DispatchSourceTimer?, Int)->())
  {
    if repeatCount <= 0 { return }
    let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
    var count = repeatCount
//    timer.schedule(wallDeadline: .now(), repeating: timeInterval)
//    timer.scheduleOneshot(wallDeadline: <#T##DispatchWallTime#>, leeway: <#T##DispatchTimeInterval#>)
    timer.scheduleRepeating(wallDeadline: .now(), interval: timeInterval)
    timer.setEventHandler(handler: {
      count -= 1
      DispatchQueue.main.async {
        handler(timer, count)
      }
      if count == 0 { timer.cancel() }
    })
    timer.resume()
  }
  
  /// GCD定时器循环操作
  ///   - timeInterval: 循环间隔时间
  ///   - handler: 循环事件
  public func DispatchTimer(timeInterval: Double, handler:@escaping (DispatchSourceTimer?)->())
  {
    let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
//    timer.schedule(deadline: .now(), repeating: timeInterval)
    timer.scheduleRepeating(deadline: .now(), interval: timeInterval)
    timer.setEventHandler {
      DispatchQueue.main.async {
        handler(timer)
      }
    }
    timer.resume()
  }
  
  /// GCD延时操作
  ///   - after: 延迟的时间
  ///   - handler: 事件
  public func DispatchAfter(after: Double, handler:@escaping ()->())
  {
    DispatchQueue.main.asyncAfter(deadline: .now() + after) {
      handler()
    }
  }
}
