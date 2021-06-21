Class {
	#name : #DeprecationRecommenderTool,
	#superclass : #SpPresenter,
	#instVars : [
		'recommender',
		'explanationLabel',
		'groupCheckbox',
		'recommendedDeprecationsNotebook',
		'methodsList',
		'classesList',
		'methodsTree',
		'classesTree',
		'methodsPage',
		'classesPage',
		'code',
		'generateButton',
		'recommendationLabelLine1',
		'recommendationLabelLine2'
	],
	#category : #'DeprecationRecommender-Spec'
}

{ #category : #accessing }
DeprecationRecommenderTool class >> defaultExtent [
	^ 900@700
]

{ #category : #specs }
DeprecationRecommenderTool class >> defaultSpec [
	^ SpBoxLayout newHorizontal
		spacing: 2;
		add: (SpBoxLayout newVertical
			add: (SpBoxLayout newHorizontal
				add: #explanationLabel;
				add: #groupCheckbox width: 2 * self buttonWidth;
				yourself) height: self buttonHeight;
			add: #recommendedDeprecationsNotebook;
			yourself) width: 300;
		add: (SpBoxLayout newVertical
			add: #recommendationLabelLine1 height: self buttonHeight;
			add: #recommendationLabelLine2 height: self buttonHeight;
			add: #code;
			add: (SpBoxLayout newHorizontal
				add: '';
				add: #generateButton width: self buttonWidth;
				yourself) height: self buttonHeight;
			yourself);
		yourself.
]

{ #category : #accessing }
DeprecationRecommenderTool class >> defaultTitle [
	^ 'Deprecation Recommender'
]

{ #category : #'world menu' }
DeprecationRecommenderTool class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: 'Deprecation Recommender')
		parent: #Tools;
		action: [ self open ];
		order: 15;
		help: 'A tool for recommending methods and classes to deprecate';
		icon: (self iconNamed: #exception).
]

{ #category : #examples }
DeprecationRecommenderTool class >> open [
	<example>
	self new openWithSpec
]

{ #category : #initialization }
DeprecationRecommenderTool >> buildToolbar [
	^ self toolbarActions 
		asToolbarPresenterWith: [ :presenter | 
			presenter 
				displayMode: SpToolbarDisplayMode modeIconAndLabel;
				addStyle: 'stToolbar' ]
]

{ #category : #initialization }
DeprecationRecommenderTool >> connectPresenters [
	super connectPresenters.
	
	recommendedDeprecationsNotebook whenSelectedPageChangedDo: [ :selectedPage |
		explanationLabel label: selectedPage title ].
	
	methodsList whenSelectionChangedDo: [ :selection |
		methodsList selectedItem ifNotNil: [
			self showSourceCodeFor: methodsList selectedItem ] ].
]

{ #category : #initialization }
DeprecationRecommenderTool >> initializePresenters [
	super initializePresenters.
	
	explanationLabel := self newLabel.
	recommendationLabelLine1 := self newLabel.
	recommendationLabelLine2 := self newLabel.
	
	groupCheckbox := self newCheckBox
		label: 'Group into packages';
		yourself.
	
	recommendedDeprecationsNotebook := self newNotebook.
	
	methodsList := self newList.
	classesList := self newList.
	
	methodsTree := self newTree.
	classesTree := self newTree.
	
	methodsPage := self newNotebookPage
		title: 'Methods';
		presenterProvider: [ methodsList ];
		yourself.
		
	classesPage := self newNotebookPage
		title: 'Classes';
		presenterProvider: [ classesList ];
		yourself.
		
	recommendedDeprecationsNotebook
		addPage: methodsPage;
		addPage: classesPage.
	
	code := self newCode
		withoutLineNumbers;
		yourself.
	
	generateButton := self newButton
		label: 'Generate';
		yourself.
]

{ #category : #initialization }
DeprecationRecommenderTool >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	
	aWindowPresenter
		title: self class defaultTitle;
		initialExtent: self class defaultExtent;
		toolbar: self buildToolbar.
]

{ #category : #'as yet unclassified' }
DeprecationRecommenderTool >> onProjectLoaded: aRepository oldVersion: aCommitSha [
	recommender := DeprecationRecommender new
		repositoryName: aRepository name
		oldVersion: aCommitSha
		newVersion: aRepository head commit id;
		yourself.
		
	self showMethods.
]

{ #category : #'as yet unclassified' }
DeprecationRecommenderTool >> showMethods [
	methodsList
		items: recommender methodsToDeprecate asArray;
		display: [ :method | method signature ].
]

{ #category : #'as yet unclassified' }
DeprecationRecommenderTool >> showSourceCodeFor: aMethod [
	code
		text: aMethod sourceCode;
		beForBehavior: (self class environment at: aMethod methodClass name).
]

{ #category : #building }
DeprecationRecommenderTool >> toolbarActions [
	^ CmCommandGroup forSpec
		register: (CmCommandGroup forSpec
			register: (DepLoadProjectCommand forSpecContext: self);
			register: (DepOpenCommand forSpecContext: self);
			register: (DepSaveCommand forSpecContext: self);
			yourself);
		yourself
]
