//
//  PictureSelectVC.swift
//  ImagePicker
//
//  Created by 余亮 on 16/6/20.
//  Copyright © 2016年 余亮. All rights reserved.
//

import UIKit



class PictureSelectVC: UIViewController {
    var pictureImages = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()

      setUpSubViews()
    }
    
    func setUpSubViews(){
        view.addSubview(collectionV)
        //布局
        collectionV.translatesAutoresizingMaskIntoConstraints = false
        var cons = [NSLayoutConstraint]()
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionV]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil , views:["collectionV":collectionV])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionV]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil , views: ["collectionV":collectionV])
        view.addConstraints(cons)
    }

 //MARK: 懒加载
    private lazy var collectionV : UICollectionView = {
        let v = UICollectionView.init(frame: CGRectZero, collectionViewLayout: LineLayout())
        v.registerClass(PictureCell.self, forCellWithReuseIdentifier:"collectionCell")
        v.delegate = self
        v.dataSource = self
        return v
    }()

}

extension PictureSelectVC : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return   pictureImages.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! PictureCell
        
        return cell
    }
    
}

class LineLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        itemSize = CGSize(width: 80, height: 80)
        minimumLineSpacing = 10
        sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
    }
}


class  PictureCell : UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.redColor()
        setUpSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSubViews(){
        contentView.addSubview(removeBtn)
        contentView.addSubview(addBtn)
        
        //布局
        addBtn.translatesAutoresizingMaskIntoConstraints = false
        removeBtn.translatesAutoresizingMaskIntoConstraints = false
        var cons = [NSLayoutConstraint]()
        
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[addBtn]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil , views: ["addBtn":addBtn])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[addBtn]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil , views: ["addBtn":addBtn])
        
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:[removeBtn]-2-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil , views: ["removeBtn":removeBtn])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-2-[removeBtn]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil , views:["removeBtn":removeBtn])
        
        contentView.addConstraints(cons)
    }
    
    func removeBtnClick(){
//        YLLog("removeBtnClick")
        print("removeBtnClick")
    }
    
    func addBtnClick(){
//        YLLog("addBtnClick")
        print("addBtnClick")
    }
    
    
    //MARK: 懒加载
    private lazy var removeBtn : UIButton = {
        let btn = UIButton()
        btn.userInteractionEnabled = true
        btn.setImage(UIImage(named:"compose_photo_close"), forState: UIControlState.Normal)
        btn.addTarget(self , action: #selector(PictureCell.removeBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    private lazy var addBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named:"compose_pic_add"), forState: UIControlState.Normal)
        btn.addTarget(self , action:#selector(PictureCell.addBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
}































