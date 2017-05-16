import UIKit
import PureLayout

class TalkingCell: UICollectionViewCell {
    static let id = "talking-cell"
    
    // MARK: - View Elements
    var talk : Talk!
    
    let avatarIcon: UIImageView = {
        let a = UIImageView.newAutoLayout()
        return a
    } ()
    
    let name: UILabel = {
        let l = UILabel.newAutoLayout()
        l.numberOfLines = 1
        return l
    } ()

    let talking: UILabel = {
        let l = UILabel.newAutoLayout()
        l.numberOfLines = 0
        return l
    } ()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubviews()
        configureSubviews()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Setup
    private func addSubviews() {
        contentView.addSubview(name)
        contentView.addSubview(avatarIcon)
        contentView.addSubview(talking)
        
        
    }
    
    private func configureSubviews() {
        
    }
    
    private func addConstraints() {
        avatarIcon.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
        avatarIcon.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
        avatarIcon.autoSetDimension(.height, toSize: 40)
        avatarIcon.autoSetDimension(.width, toSize: 40)

        name.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
        name.autoPinEdge(.left, to:.right, of: avatarIcon, withOffset: 15)
        name.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        name.autoSetDimension(.height, toSize: 30)
        
        talking.autoPinEdge(.top, to:.bottom, of: name, withOffset:10)
        talking.autoPinEdge(.left, to:.right, of: avatarIcon, withOffset:10)
        talking.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        
    }
    
    func configureView(talk: Talk) {
        
        self.talk = talk
        
        name.numberOfLines = 1
        name.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        name.text = self.talk.mittyId 
        avatarIcon.image = UIImage (named: (self.talk?.avatarIcon)!)
        talking.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        talking.text = self.talk.speaking
        
        talking.sizeToFit()
        self.talk.height = talking.frame.height + 40

    }
}
