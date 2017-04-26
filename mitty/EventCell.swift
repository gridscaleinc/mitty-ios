import UIKit
import PureLayout

class EventCell: UICollectionViewCell {
    static let id = "journey-search-result-cell"
    
    // MARK: - View Elements
    var event : Event?
    var images = ["event1", "event6", "event4","event10.jpeg","event5", "event9.jpeg"]

    let itemImageView: UIImageView
    let titleLabel: UILabel
    let priceLabel: UILabel
    let likesLabel: UILabel
    let endTimeLabel: UILabel
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        itemImageView = UIImageView.newAutoLayout()
        itemImageView.clipsToBounds=true
        itemImageView.contentMode = UIViewContentMode.scaleAspectFit
        
        titleLabel = UILabel.newAutoLayout()
        priceLabel = UILabel.newAutoLayout()
        likesLabel = UILabel.newAutoLayout()
        endTimeLabel = UILabel.newAutoLayout()
        endTimeLabel.numberOfLines = 0
        
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
        contentView.addSubview(itemImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(likesLabel)
        contentView.addSubview(endTimeLabel)
    }
    
    private func configureSubviews() {}
    
    private func addConstraints() {
        itemImageView.autoPinEdge(toSuperviewEdge: .top, withInset: 2)
        itemImageView.autoPinEdge(toSuperviewEdge: .left, withInset: 2)
        itemImageView.autoPinEdge(toSuperviewEdge: .right, withInset: 2)
        
        itemImageView.autoMatch(.width, to: .width, of: itemImageView)
        
        
        titleLabel.autoPinEdge(.top, to: .bottom, of: itemImageView, withOffset: 3.0)
        titleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 2)
        titleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 2)

        priceLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 3.0)
        priceLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 2)
        priceLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 2)

        endTimeLabel.autoPinEdge(.top, to: .bottom, of: priceLabel, withOffset: 3.0)
        endTimeLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 2)
        endTimeLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5)

        likesLabel.autoPinEdge(.top, to: .bottom, of: priceLabel, withOffset: 3.0)
        likesLabel.autoPinEdge(.left, to: .right, of: endTimeLabel, withOffset: 10.0)
        likesLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5)

    }
    
    func configureView(event: Event) {
        
        self.event = event
        
        
        // タイトルを表示
        
        // logoがある場合ロゴを表示
        
        // imageがある場合、イメージを表示
        
        // 日付情報を設定
        
        // 価格情報を設定
        
        
        // 説明があれば、説明をつける。
        
        // like数
        
        // 登録者
        
        // TODO
        // itemImageView.image = UIImage(data: Data(bytes: (event.gallery[0].content?.data)!))
        itemImageView.image = UIImage(named: images[Int(event.id!)])
        
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        titleLabel.text = event.title

        priceLabel.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
        priceLabel.text = LS(key: "now") + String(describing: event.price1) + LS(key: "yen")

        endTimeLabel.font = UIFont.systemFont(ofSize: CGFloat(10))
        endTimeLabel.text = event.duration()
        

        likesLabel.font = UIFont.systemFont(ofSize: CGFloat(10))
        likesLabel.text = "🔨"         
        
    }
}
