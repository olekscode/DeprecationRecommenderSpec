Class {
	#name : #DeprecationRecommenderTool,
	#superclass : #SpPresenter,
	#instVars : [
		'stepsList',
		'listTreeViewButton',
		'mainArea',
		'deprecationRecommender',
		'isListView',
		'missingMethodsView',
		'missingMethods'
	],
	#category : #'DeprecationRecommender-Spec-Views'
}

{ #category : #accessing }
DeprecationRecommenderTool class >> defaultExtent [
	^ 1300@600
]

{ #category : #specs }
DeprecationRecommenderTool class >> defaultSpec [
	^ SpBoxLayout newHorizontal
		spacing: 5;
		add: (SpBoxLayout newVertical
			add: (SpBoxLayout newHorizontal
				add: 'Missing methods';
				add: #listTreeViewButton width: 80;
				yourself) height: self buttonHeight;
			add: #missingMethodsView;
			yourself) width: 250;
		add: #stepsList width: 300;
		add: #mainArea;
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
	
	listTreeViewButton action: [
		self toggleListTreeView ].
	
	missingMethodsView whenSelectionChangedDo: [ 
		missingMethodsView selectedItem ifNotNil: [ :item |
			item class = DepMethodModel
				ifTrue: [ item review markAsComplete ] ] ].
	
	stepsList whenSelectionChangedDo: [ 
		stepsList selectedItem ifNotNil: [
			stepsList selectedItem markAsComplete. 
			self showInMainArea: stepsList selectedItem presenterProvider value ] ].
]

{ #category : #'as yet unclassified' }
DeprecationRecommenderTool >> defaultPrivateMethodsIn: aSnapshot [

	^ aSnapshot methods select: [ :method |
		VisibilityDeductor new isMethodPrivate: method ].
]

{ #category : #'as yet unclassified' }
DeprecationRecommenderTool >> defaultPublicMethodsIn: aSnapshot [

	^ aSnapshot methods reject: [ :method |
		VisibilityDeductor new isMethodPrivate: method ].
]

{ #category : #initialization }
DeprecationRecommenderTool >> initializeExperimentSteps [

	| steps |
	
	steps := {
		self initializeLoadHistoryStep .
		self initializeSelectPackagesStep .
		self initializeOldApiStep .
		self initializeNewApiStep .
		self initializeRecommendedDeprecationsStep .
		self initializeProposedReplacementsStep .
		self initializeGenerateCodeStep
	}.
	
	steps withIndexDo: [ :step :index |
		step name: ('Step ', index asString, ': ', step name) ].
	
	^ steps
]

{ #category : #initialization }
DeprecationRecommenderTool >> initializeGenerateCodeStep [

	^ DepExperimentStep new
		name: 'Generate code';
		yourself.
]

{ #category : #initialization }
DeprecationRecommenderTool >> initializeLoadHistoryStep [

	^ DepExperimentStep new
		name: 'Load project history';
		presenterProvider: [ DepProjectHistoryLoader new ]
		yourself.
]

{ #category : #initialization }
DeprecationRecommenderTool >> initializeNewApiStep [

	^ DepExperimentStep new
		name: 'Define new API';
		presenterProvider: [
			DepMethodVisibilityEditor new
				publicMethods: (self defaultPublicMethodsIn: deprecationRecommender newVersionSnapshot);
				privateMethods: (self defaultPrivateMethodsIn: deprecationRecommender newVersionSnapshot);
				yourself ];
		yourself.
]

{ #category : #initialization }
DeprecationRecommenderTool >> initializeOldApiStep [

	^ DepExperimentStep new
		name: 'Define old API';
		presenterProvider: [
			DepMethodVisibilityEditor new
				publicMethods: (self defaultPublicMethodsIn: deprecationRecommender oldVersionSnapshot);
				privateMethods: (self defaultPrivateMethodsIn: deprecationRecommender oldVersionSnapshot);
				yourself ];
		yourself.
]

{ #category : #initialization }
DeprecationRecommenderTool >> initializePresenters [
	super initializePresenters.
	
	listTreeViewButton := self newButton.
		
	missingMethodsView := self newNullPresenter.
	
	stepsList := self newList
		displayIcon: [ :step | step icon ];
		display: [ :step | step name ];
		items: self initializeExperimentSteps;
		yourself.
		
	mainArea := self newNullPresenter.
	
	isListView := false.
	
	self loadDefaultProject.
	self showMissingMethodsAsTree.
]

{ #category : #initialization }
DeprecationRecommenderTool >> initializeProposedReplacementsStep [

	^ DepExperimentStep new
		name: 'Review the proposed replacements';
		yourself.
]

{ #category : #initialization }
DeprecationRecommenderTool >> initializeRecommendedDeprecationsStep [

	^ DepExperimentStep new
		name: 'Review the recommended deprecations';
		yourself.
]

{ #category : #initialization }
DeprecationRecommenderTool >> initializeSelectPackagesStep [

	^ DepExperimentStep new
		name: 'Select packages';
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
DeprecationRecommenderTool >> loadDefaultProject [

	| dir newVersionSnapshotFile oldVersionSnapshotFile projectHistoryFile |

	dir := '/Users/oleks/Documents/tmp/clio' asFileReference.
	newVersionSnapshotFile := dir / 'dataFrame-newVersionSnapshot.json'.
	oldVersionSnapshotFile := dir / 'dataFrame-oldVersionSnapshot.json'.
	projectHistoryFile := dir / 'dataFrame-history.json'.
	
	self
		loadProjectHistory: (ClioHistory readFromJsonFile: projectHistoryFile)
		oldVersionSnapshot: (ClioSnapshot readFromJsonFile: oldVersionSnapshotFile)
		newVersionSnapshot: (ClioSnapshot readFromJsonFile: newVersionSnapshotFile).
]

{ #category : #'as yet unclassified' }
DeprecationRecommenderTool >> loadProjectHistory: aHistory oldVersionSnapshot: anOldVersion newVersionSnapshot: aNewVersion [
	
	deprecationRecommender := DeprecationRecommender new
		projectHistory: aHistory;
		oldVersionSnapshot: anOldVersion;
		newVersionSnapshot: aNewVersion;
		yourself.
		
	missingMethods := deprecationRecommender methodsToDeprecate collect: [ :each |
		DepMethodModel new
			method: each;
			yourself ].
		
	self showMissingMethods.
]

{ #category : #initialization }
DeprecationRecommenderTool >> showInMainArea: aPresenter [

	mainArea := aPresenter.
	self rebuildLayout.
]

{ #category : #'as yet unclassified' }
DeprecationRecommenderTool >> showMissingMethods [
	isListView
		ifTrue: [ self showMissingMethodsAsList ]
		ifFalse: [ self showMissingMethodsAsTree ].
]

{ #category : #'as yet unclassified' }
DeprecationRecommenderTool >> showMissingMethodsAsList [
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
DeprecationRecommenderTool >> showMissingMethodsAsTree [
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
		classModel := classes at: method methodClass name ifAbsentPut: [
			DepClassModel new
				class: method methodClass;
				yourself ].
					
		classModel methods add: method ].
		
	classes values do: [ :each | each methods sort: [ :a :b | a name < b name ] ].
	missingMethodsView items: classes.
]

{ #category : #'as yet unclassified' }
DeprecationRecommenderTool >> showVisibilityEditor [

	| dir newVersionSnapshotFile newVersionSnapshot publicMethods privateMethods |

	dir := '/Users/oleks/Documents/tmp/clio' asFileReference.
	newVersionSnapshotFile := dir / 'dataFrame-newVersionSnapshot.json'.

	newVersionSnapshot := ClioSnapshot readFromJsonFile: newVersionSnapshotFile.

	publicMethods := OrderedCollection new.
	privateMethods := OrderedCollection new.

	newVersionSnapshot methods do: [ :method |
		(VisibilityDeductor new isMethodPrivate: method)
			ifTrue: [ privateMethods add: method ]
			ifFalse: [ publicMethods add: method ] ].

	self showInMainArea: ((self instantiate: DepMethodVisibilityEditor)
		publicMethods: publicMethods;
		privateMethods: privateMethods;
		yourself).
		
	self rebuildLayout.
]

{ #category : #'as yet unclassified' }
DeprecationRecommenderTool >> toggleListTreeView [
	isListView := isListView not.
	self showMissingMethods.
]

{ #category : #building }
DeprecationRecommenderTool >> toolbarActions [
	^ CmCommandGroup forSpec
		register: (CmCommandGroup forSpec
			register: (DepOpenCommand forSpecContext: self);
			register: (DepSaveCommand forSpecContext: self);
			yourself);
		yourself
]
