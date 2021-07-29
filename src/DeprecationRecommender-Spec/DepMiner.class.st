Class {
	#name : #DepMiner,
	#superclass : #SpPresenter,
	#instVars : [
		'listTreeViewButton',
		'mainAreaNotebook',
		'deprecationRecommender',
		'isListView',
		'missingMethodsView',
		'missingMethods'
	],
	#category : #'DeprecationRecommender-Spec-Views'
}

{ #category : #accessing }
DepMiner class >> defaultExtent [
	^ 1300@600
]

{ #category : #specs }
DepMiner class >> defaultSpec [
	^ SpBoxLayout newHorizontal
		spacing: 5;
		add: (SpBoxLayout newVertical
			add: (SpBoxLayout newHorizontal
				add: 'Missing methods';
				add: #listTreeViewButton width: 80;
				yourself) height: self buttonHeight;
			add: #missingMethodsView;
			yourself) width: 250;
		add: #mainAreaNotebook;
		yourself.
]

{ #category : #accessing }
DepMiner class >> defaultTitle [
	^ 'Deprecation Recommender'
]

{ #category : #'world menu' }
DepMiner class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: 'Deprecation Recommender')
		parent: #Tools;
		action: [ self open ];
		order: 15;
		help: 'A tool for recommending methods and classes to deprecate';
		icon: (self iconNamed: #exception).
]

{ #category : #examples }
DepMiner class >> open [
	<example>
	self new openWithSpec
]

{ #category : #initialization }
DepMiner >> buildToolbar [
	^ self toolbarActions 
		asToolbarPresenterWith: [ :presenter | 
			presenter 
				displayMode: SpToolbarDisplayMode modeIconAndLabel;
				addStyle: 'stToolbar' ]
]

{ #category : #initialization }
DepMiner >> connectPresenters [
	super connectPresenters.
	
	listTreeViewButton action: [
		self toggleListTreeView ].
	
	missingMethodsView whenSelectionChangedDo: [ 
		missingMethodsView selectedItem ifNotNil: [ :item |
			item class = DepMethodModel
				ifTrue: [ self showMethod: item ] ] ].
]

{ #category : #initialization }
DepMiner >> initializePresenters [
	super initializePresenters.
	
	listTreeViewButton := self newButton.
	missingMethodsView := self newNullPresenter.
		
	mainAreaNotebook := self newNotebook.
	
	isListView := false.
	
	self loadDefaultProject.
	self showMissingMethodsAsTree.
]

{ #category : #initialization }
DepMiner >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	
	aWindowPresenter
		title: self class defaultTitle;
		initialExtent: self class defaultExtent;
		toolbar: self buildToolbar.
]

{ #category : #'as yet unclassified' }
DepMiner >> loadDefaultProject [

	| dir recommendationsFile recommendations |

	dir := '/Users/oleks/Documents/tmp/clio/DataFrame' asFileReference.
	recommendationsFile := dir / 'recommendations.json'.
	
	recommendations := DepRecommendations readFromJsonFile: recommendationsFile.
	self loadRecommendations: recommendations.
]

{ #category : #'as yet unclassified' }
DepMiner >> loadRecommendations: aCollectionOfRecommendations [
		
	missingMethods := aCollectionOfRecommendations collect: [ :each |
		DepMethodModel new
			recommendation: each;
			yourself ].
		
	self showMissingMethods.
]

{ #category : #'as yet unclassified' }
DepMiner >> showMethod: aMethod [
	
	mainAreaNotebook removeAll.
	
	mainAreaNotebook
		addPage: (self newNotebookPage
			title: 'Step 1';
			yourself);
		addPage: (self newNotebookPage
			title: 'Step 2';
			yourself);
		addPage: (self newNotebookPage
			title: 'Step 3';
			yourself).
]

{ #category : #'as yet unclassified' }
DepMiner >> showMissingMethods [
	isListView
		ifTrue: [ self showMissingMethodsAsList ]
		ifFalse: [ self showMissingMethodsAsTree ].
]

{ #category : #'as yet unclassified' }
DepMiner >> showMissingMethodsAsList [
	listTreeViewButton
		label: 'List View';
		icon: (self iconNamed: #smallJustified).
		
	missingMethodsView := self newList
		display: [ :method | method signature ];
		displayIcon: [ :method | method icon ];
		yourself.
		
	self rebuildLayout.
	
	missingMethods ifNotNil: [
		missingMethodsView items:
			(missingMethods sorted: [ :a :b | a signature < b signature ]) ].
]

{ #category : #'as yet unclassified' }
DepMiner >> showMissingMethodsAsTree [
	| classes classModel |
	
	listTreeViewButton
		label: 'Tree View';
		icon: (self iconNamed: #merge).
	
	missingMethodsView := self newTree
		display: [ :each | each name ];
		displayIcon: [ :each | each icon ];
		children: [ :each | each children ];
		yourself.
		
	self rebuildLayout.
	
	missingMethods ifNil: [ ^ self ].
	classes := Dictionary new.
		
	missingMethods do: [ :method |
		classModel := classes at: method methodClassName ifAbsentPut: [
			DepClassModel new
				className: method methodClassName;
				yourself ].
					
		classModel methods add: method ].
		
	classes values do: [ :each | each methods sort: [ :a :b | a name < b name ] ].
	missingMethodsView items: classes.
]

{ #category : #'as yet unclassified' }
DepMiner >> toggleListTreeView [
	isListView := isListView not.
	self showMissingMethods.
]

{ #category : #building }
DepMiner >> toolbarActions [
	^ CmCommandGroup forSpec
		register: (CmCommandGroup forSpec
			register: (DepOpenCommand forSpecContext: self);
			register: (DepSaveCommand forSpecContext: self);
			yourself);
		yourself
]
