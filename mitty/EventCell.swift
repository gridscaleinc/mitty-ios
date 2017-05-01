import UIKit
import PureLayout

class EventCell: UICollectionViewCell {
    static let id = "journey-search-result-cell"
    
    // MARK: - View Elements
    var event : Event?
    var images = ["event1", "event6", "event4","event10.jpeg","event5", "event9.jpeg"]

    let form = MQForm.newAutoLayout()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.addSubview(form)
        form.autoPinEdgesToSuperviewEdges()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        
        
    }
    
    func configureView(event: Event) {
        
        self.event = event
        
        let section = Section(name: "eventcell", view: UIView.newAutoLayout())
        section.layout {
            s in
            s.fillParent()
        }
        form +++ section
        
        // 誰かポストしたのか
        var row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(30)
        }
        
        let publisherIcon = MQForm.img(name: "pushlisherIcon", url: "pengin4")
        row +++ publisherIcon.width(30).height(30)
        
        let publisher = MQForm.label(name: "publisher", title: "Some Publisher")
        row +++ publisher.layout{
            pub in
            let l = pub.label
            l.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            l.textColor = MittyColor.healthyGreen
        }
        
        let published = MQForm.label(name: "publishDate", title: "10 days ago.")
        row +++ published.layout{
            pub in
            let l = pub.label
            l.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            l.textColor = UIColor.lightGray
        }
        
        section <<< row
        
        // タイトルを表示
        // logoがある場合ロゴを表示
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(75)
        }
        let col = Col.UpDownAligned().layout {
            c in
            c.height(75).width(25)
        }
        col +++ MQForm.label(name: "likes1", title: "🔺").width(25).height(25)
        col +++ MQForm.label(name: "likes2", title: "133").width(25).height(25).layout {
            l in
            let label = l.label
            label.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
        }
        
        col +++ MQForm.label(name: "likes3", title: "🔻").width(25).height(25)
        row +++ col
        
        row +++ MQForm.img(name: "eventIcon", url: "timesquare").width(50).height(50)
        let titleLabel = MQForm.label(name: "titleLabel", title: "Goto newyork city , Time square, Happy new year count down!").layout {t in
            t.label.numberOfLines = 2
            t.label.font = UIFont.boldSystemFont(ofSize: 18)
            t.rightMost()
        }
        row +++ titleLabel
        section <<< row
        
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(150)
        }
        // imageがある場合、イメージを表示
        let itemImage = MQForm.img(name: "eventImage", url: images[Int(event.id!)]).layout {
            img in
            img.fillHolizon()
        }
        row +++ itemImage
        section <<< row
        
        // 日付情報を設定
        row = Row.LeftAligned().layout {
            r in
            r.fillHolizon().height(20)
        }
        let endTimeLabel = UILabel.newAutoLayout()
        endTimeLabel.font = UIFont.systemFont(ofSize: CGFloat(10))
        endTimeLabel.text = event.duration()
        let timeDuration = Control(name:"duration", view: endTimeLabel).layout {
            l in
            l.fillParent()
        }
        row +++ timeDuration
        section <<< row
        
        // 価格情報を設定
//        let priceLabel: UILabel
        
        // 説明があれば、説明をつける。
        
        // like数
        
        // 登録者
        

//        priceLabel.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
//        priceLabel.text = LS(key: "now") + String(describing: event.price1) + LS(key: "yen")

    
        
        
        
//        priceLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 3.0)
//        priceLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 2)
//        priceLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 2)
        

        form.configLayout()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for v in contentView.subviews {
            v.removeFromSuperview()
        }
    }
}
