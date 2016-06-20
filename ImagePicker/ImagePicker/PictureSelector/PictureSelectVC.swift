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

extension PictureSelectVC : UICollectionViewDataSource, UICollectionViewDelegate , UINavigationControllerDelegate, UIImagePickerControllerDelegate , PictureSelectDelegate{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return   pictureImages.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! PictureCell
        cell.pictureDelegate = self
        cell.image = (pictureImages.count == indexPath.item) ? nil : pictureImages[indexPath.item]
        return cell
    }
    
    //MARK: PictureSelectDelegate
    func photoDidSelect(cell : PictureCell){
        /*
         case PhotoLibrary     照片库(所有的照片，拍照&用 iTunes & iPhoto `同步`的照片 - 不能删除)
         case SavedPhotosAlbum 相册 (自己拍照保存的, 可以随便删除)
         case Camera    相机
         */
        //1.判断能否打开照片库
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            print("不能打开相册")
            return
        }
        
        //2.创建图片选择器
        let vc = UIImagePickerController()
        vc.delegate = self
        // 设置允许用户编辑选中的图片
        // 开发中如果需要上传头像, 那么请让用户编辑之后再上传
        // 这样可以得到一张正方形的图片, 以便于后期处理(圆形)
        vc.allowsEditing = true
        presentViewController(vc, animated: true , completion: nil )
        
    }
    
    /**
     选中相片之后调用
     
     :param: picker      促发事件的控制器
     :param: image       当前选中的图片
     :param: editingInfo 编辑之后的图片
     */

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        pictureImages.append(image)
        collectionV.reloadData()
        
        //如果实现了该方法，需要我们自己关闭图片选择器
        picker.dismissViewControllerAnimated(true , completion: nil )
    }
    
    func photoDidRemove(cell: PictureCell) {
        //1.从数组移除当前点击的图片
        let indexPath = collectionV.indexPathForCell(cell)
        pictureImages.removeAtIndex((indexPath?.item)!)
        //2.刷新表格
        collectionV.reloadData()
        
    }
    
}

class LineLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        itemSize = CGSize(width: 80, height: 80)
        minimumLineSpacing = 10
        sectionInset = UIEdgeInsetsMake(20, 10, 10, 10)
    }
}


@objc
protocol PictureSelectDelegate {
    optional func photoDidSelect(cell : PictureCell)
    optional func photoDidRemove(cell : PictureCell)
    
}
class  PictureCell : UICollectionViewCell {
    ///声明代理
    weak  var pictureDelegate : PictureSelectDelegate?
    
    var image : UIImage?{
        didSet{
            if (image != nil ){
                addBtn.setBackgroundImage(image!, forState: UIControlState.Normal)
                removeBtn.hidden = false
                self.contentView.bringSubviewToFront(removeBtn)
                addBtn.userInteractionEnabled = false
            }else {
                removeBtn.hidden = true
                addBtn.userInteractionEnabled = true 
                addBtn.setBackgroundImage(UIImage(named:"compose_pic_add"), forState: UIControlState.Normal)
            }
        }
    }
    
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
        pictureDelegate?.photoDidRemove!(self)
    }
    
    func addBtnClick(){
//        YLLog("addBtnClick")
        pictureDelegate?.photoDidSelect!(self)
    }
    
    
    //MARK: 懒加载
    private lazy var removeBtn : UIButton = {
        let btn = UIButton()
//        btn.hidden = true
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































