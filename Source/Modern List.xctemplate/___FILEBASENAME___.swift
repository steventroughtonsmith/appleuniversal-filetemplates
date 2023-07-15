//___FILEHEADER___

import UIKit

class ___FILEBASENAME___: UICollectionViewController {
	enum Section {
		case main
	}
	
	struct Item: Hashable {
		var identifier = UUID().uuidString

		func hash(into hasher: inout Hasher) {
			hasher.combine(identifier)
		}
		
		static func == (lhs: Item, rhs: Item) -> Bool {
			return lhs.identifier == rhs.identifier
		}
	}
	
	typealias ItemType = Item

	let reuseIdentifier = "Cell"
	var dataSource: UICollectionViewDiffableDataSource<Section, ItemType>! = nil
	var currentItems:[ItemType] = []

	init() {
		let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
		let layout = UICollectionViewCompositionalLayout.list(using: configuration)
				
		super.init(collectionViewLayout: layout)
		guard let collectionView = collectionView else { return }

		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		
		if #available(iOS 15.0, *) {
			collectionView.allowsFocus = true
		}

		configureDataSource()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Data Source
	
	func configureDataSource() {
		
		dataSource = UICollectionViewDiffableDataSource<Section, ItemType>(collectionView: collectionView) {
			(collectionView: UICollectionView, indexPath: IndexPath, item: ItemType) -> UICollectionViewCell? in
			
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath)
			
			var config = UIListContentConfiguration.cell()
			
			config.text = "Cell"
			config.image = UIImage(systemName: "star")
			
			if #available(iOS 15.0, *) {
				cell.focusEffect = UIFocusHaloEffect()
			}

			cell.contentConfiguration = config
			
			return cell
		}
		
		collectionView.dataSource = dataSource
		
		refresh()
	}
		
	func snapshot() -> NSDiffableDataSourceSectionSnapshot<ItemType> {
		var snapshot = NSDiffableDataSourceSectionSnapshot<ItemType>()
		
		currentItems = [ItemType(), ItemType(), ItemType()]
		snapshot.append(currentItems)
		
		return snapshot
	}
	
	func refresh() {
		guard let dataSource = collectionView.dataSource as? UICollectionViewDiffableDataSource<Section, ItemType> else { return }
		
		dataSource.apply(snapshot(), to: .main, animatingDifferences: false)
	}
}
