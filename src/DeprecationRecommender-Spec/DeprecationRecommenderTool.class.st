Class {
	#name : #DeprecationRecommenderTool,
	#superclass : #SpPresenter,
	#instVars : [
		'stepsList',
		'mainArea',
		'oldVersionSnapshot',
		'projectHistory',
		'newVersionSnapshot'
	],
	#category : #'DeprecationRecommender-Spec'
}

{ #category : #accessing }
DeprecationRecommenderTool class >> defaultExtent [
	^ 1300@600
]

{ #category : #specs }
DeprecationRecommenderTool class >> defaultSpec [
	^ SpBoxLayout newHorizontal
		spacing: 5;
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
DeprecationRecommenderTool >> connectPresenters [
	super connectPresenters.
	
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
		yourself.
]

{ #category : #initialization }
DeprecationRecommenderTool >> initializeNewApiStep [

	^ DepExperimentStep new
		name: 'Define new API';
		presenterProvider: [
			DepMethodVisibilityEditor new
				publicMethods: (self defaultPublicMethodsIn: newVersionSnapshot);
				privateMethods: (self defaultPrivateMethodsIn: newVersionSnapshot);
				yourself ];
		yourself.
]

{ #category : #initialization }
DeprecationRecommenderTool >> initializeOldApiStep [

	^ DepExperimentStep new
		name: 'Define old API';
		presenterProvider: [
			DepMethodVisibilityEditor new
				publicMethods: (self defaultPublicMethodsIn: oldVersionSnapshot);
				privateMethods: (self defaultPrivateMethodsIn: oldVersionSnapshot);
				yourself ];
		yourself.
]

{ #category : #initialization }
DeprecationRecommenderTool >> initializePresenters [
	super initializePresenters.
	
	self loadDefaultProject.
	
	stepsList := self newList
		displayIcon: [ :step | step icon ];
		display: [ :step | step name ];
		items: self initializeExperimentSteps;
		yourself.
		
	mainArea := self newNullPresenter.
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
		initialExtent: self class defaultExtent.
]

{ #category : #'as yet unclassified' }
DeprecationRecommenderTool >> loadDefaultProject [

	| dir newVersionSnapshotFile oldVersionSnapshotFile projectHistoryFile |

	dir := '/Users/oleks/Documents/tmp/clio' asFileReference.
	newVersionSnapshotFile := dir / 'dataFrame-newVersionSnapshot.json'.
	oldVersionSnapshotFile := dir / 'dataFrame-oldVersionSnapshot.json'.
	projectHistoryFile := dir / 'dataFrame-history.json'.
	
	newVersionSnapshot := ClioSnapshot readFromJsonFile: newVersionSnapshotFile.
	oldVersionSnapshot := ClioSnapshot readFromJsonFile: oldVersionSnapshotFile.
	projectHistory := ClioHistory readFromJsonFile: projectHistoryFile.
]

{ #category : #initialization }
DeprecationRecommenderTool >> showInMainArea: aPresenter [

	mainArea := aPresenter.
	self rebuildLayout.
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
