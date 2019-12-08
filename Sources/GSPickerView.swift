//
//  GSPickerView.swift
//  GSPickerView
//
//  Created by Tej on 23/11/19.
//  Copyright © 2019 Tej. All rights reserved.
//


import UIKit
protocol GSPickerViewDataSource {
    func numberOfRowsInPickerView(pickerView : GSPickerView) -> Int
    func pickerViewTitleForRow(pickerView : GSPickerView, row : Int) -> String
}
@objc protocol GSPickerViewDataDelegate {
    func pickerViewDidSelectWithItemAtRow(pickerView : GSPickerView,row : Int)
    @objc optional func pickerViewDidSelectWithItemsAtRows(pickerView : GSPickerView,rows : [Int])
    @objc optional func pickerViewDidClickCancelButton(pickerView : GSPickerView)
}
public class GSPickerView: UIViewController {
    var mySelf : GSPickerView?
    let baseView = UIView()
    let contentView = UIView()
    let tableView = UITableView()
    let headerView = UIView()
    let footerView = UIView()
    let stackView = UIStackView()
    let buttonSubmit = UIButton(type: .system)
    let buttonCancel = UIButton(type: .system)
    public var animationDuration = 0.2
    var contentViewYAnchor: NSLayoutConstraint?
    public var labelTitle = UILabel()
    public var buttonSubmitBackgroundColor = UIColor()
    public var buttonCancelBackgroundColor = UIColor()
    public var labelTitleTextColor = UIColor()
    public var addBlurEffect = true
    public var showSubmitButton = true
    public var showCancelButton = true
    public var showFooter = true
    public var showHeader = true
    public var showTableviewSeparator = false
    public var tapBackgroundToDismiss = true
    public var multiSelection = false
    public var arrSelectedIndex = [Int]()
    public var selectedIndex = Int()
    var dataSource : GSPickerViewDataSource?
    var delegate : GSPickerViewDataDelegate?
    override public func viewDidLoad() {
        super.viewDidLoad()
        mySelf = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setupUI()
        setupGesture()
        // Do any additional setup after loading the view.
    }
    func setupUI() {
        buttonSubmitBackgroundColor = UIColor(red: 100/255, green: 200/255, blue: 150/255, alpha: 1)
        buttonCancelBackgroundColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1)
        headerView.backgroundColor = UIColor(red: 100/255, green: 200/255, blue: 150/255, alpha: 1)
        labelTitleTextColor = .white
        contentView.backgroundColor = .purple
        // Set up main view
        view.frame = UIScreen.main.bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addBlurEffect ? baseView.addSubview(blurEffectView) :  (baseView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.5))
        view.addSubview(baseView)
        // Base View
        baseView.backgroundColor = .clear
        baseView.frame = view.frame
        baseView.addSubview(contentView)
        // Content View
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true
        contentView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5).isActive = true
        contentViewYAnchor = contentView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.height)
        contentViewYAnchor?.isActive = true
        contentView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.addSubview(footerView)
        contentView.addSubview(tableView)
        // Header View
        if showHeader{
            contentView.addSubview(headerView)
            headerView.translatesAutoresizingMaskIntoConstraints = false
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            headerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            headerView.addSubview(labelTitle)
            
            // Title Label
            labelTitle.translatesAutoresizingMaskIntoConstraints = false
            labelTitle.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
            labelTitle.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
            labelTitle.text = "Select"
            labelTitle.textColor = labelTitleTextColor
            labelTitle.font = UIFont(name: "HelveticaNeue-light", size: 21)
        }
        // Footer View
        if showFooter{
            footerView.translatesAutoresizingMaskIntoConstraints = false
            footerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            footerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            footerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            footerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            footerView.addSubview(stackView)
            // Stack View For Footer
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.topAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
            stackView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor).isActive = true
            stackView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor).isActive = true
            stackView.bottomAnchor.constraint(equalTo: footerView.bottomAnchor).isActive = true
            stackView.distribution = .fillEqually
            stackView.axis = .horizontal
            stackView.alignment = .fill
            // Cancel Button
            if showCancelButton{
                buttonCancel.setTitle("Cancel", for: .normal)
                buttonCancel.setTitleColor(.black, for: .normal)
                buttonCancel.backgroundColor = buttonCancelBackgroundColor
                buttonCancel.addTarget(mySelf, action: #selector(handleCancelButtonPressed), for: .touchUpInside)
                stackView.addArrangedSubview(buttonCancel)
            }
            // Submit Button
            if showSubmitButton{
                buttonSubmit.setTitle("Submit", for: .normal)
                buttonSubmit.setTitleColor(.white, for: .normal)
                buttonSubmit.backgroundColor = buttonSubmitBackgroundColor
                buttonSubmit.addTarget(mySelf, action: #selector(handleSubmit), for: .touchUpInside)
                stackView.addArrangedSubview(buttonSubmit)
            }
        }
        
        // Table View
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
        if !showTableviewSeparator{
            tableView.separatorStyle = .none
        }
        
    }
    func setupGesture(){
        if tapBackgroundToDismiss{
            let tab = UITapGestureRecognizer(target: self, action: #selector(handleCancelButtonPressed))
            baseView.addGestureRecognizer(tab)
        }
    }
    @objc func handleSubmit() {
        if multiSelection{
            delegate?.pickerViewDidSelectWithItemsAtRows?(pickerView: self, rows: arrSelectedIndex)
        }
        else{
            delegate?.pickerViewDidSelectWithItemAtRow(pickerView: self, row: selectedIndex)
        }
        
        handleCancel()
    }
    @objc func handleCancelButtonPressed(){
        delegate?.pickerViewDidClickCancelButton?(pickerView: self)
        handleCancel()
    }
    @objc func handleCancel() {
        contentViewYAnchor?.isActive = false
        contentViewYAnchor = contentView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.height)
        contentViewYAnchor?.isActive = true
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            self.view.removeFromSuperview()
        }
        
    }
    func show(){
        let rv = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        rv?.addSubview(view)
        view.frame = rv!.bounds
        baseView.frame = rv!.bounds
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        contentViewYAnchor?.isActive = false
        contentViewYAnchor = contentView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        contentViewYAnchor?.isActive = true
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
}
extension GSPickerView : UITableViewDelegate,UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfRowsInPickerView(pickerView: self) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if multiSelection{
             cell?.accessoryType = arrSelectedIndex.contains(indexPath.row) ? .checkmark : .none
        }
        cell?.textLabel?.text = dataSource?.pickerViewTitleForRow(pickerView: self, row: indexPath.row) ?? ""
        return cell!
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if multiSelection{
            if cell?.accessoryType == UITableViewCell.AccessoryType.none{
                arrSelectedIndex.append(indexPath.row)
            }
            else{
                arrSelectedIndex.remove(at: arrSelectedIndex.firstIndex(of: indexPath.row) ?? 0)
            }
            
            tableView.reloadData()
        }
        selectedIndex = indexPath.row
        if !showSubmitButton{
            delegate?.pickerViewDidSelectWithItemAtRow(pickerView: self, row: indexPath.row)
            handleCancel()
        }
    }
}


