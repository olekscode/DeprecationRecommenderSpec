Class {
	#name : #DepCommitSelector,
	#superclass : #SpPresenter,
	#instVars : [
		'commitsTable',
		'selectButton',
		'commits',
		'callback'
	],
	#category : #'DeprecationRecommender-Spec-Views'
}

{ #category : #accessing }
DepCommitSelector class >> defaultExtent [
	^ 500@600
]

{ #category : #specs }
DepCommitSelector class >> defaultSpec [
	^ SpBoxLayout newVertical
		spacing: 2;
		add: #commitsTable;
		add: (SpBoxLayout newHorizontal
			add: '';
			add: #selectButton width: self buttonWidth;
			yourself) height: self buttonHeight;
		yourself.
]

{ #category : #accessing }
DepCommitSelector class >> defaultTitle [
	^ 'Commit Selector'
]

{ #category : #accessing }
DepCommitSelector >> callback: aBlock [
	callback := aBlock
]

{ #category : #initialization }
DepCommitSelector >> connectPresenters [
	super connectPresenters.
	
	selectButton action: [
		callback value: commitsTable selectedItem.
		self window close ].
]

{ #category : #initialization }
DepCommitSelector >> initializePresenters [
	super initializePresenters.
	
	commitsTable := self newTable.
	
	selectButton := self newButton
		label: 'Select';
		yourself.
		
	commits ifNotNil: [ self showCommits ].
]

{ #category : #initialization }
DepCommitSelector >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	
	aWindowPresenter
		title: self class defaultTitle;
		initialExtent: self class defaultExtent.
]

{ #category : #initialization }
DepCommitSelector >> setModelBeforeInitialization: aCollectionOfCommits [
	commits := aCollectionOfCommits
]

{ #category : #initialization }
DepCommitSelector >> showCommits [
	commitsTable
		columns: { };
		items: commits;
		addColumn: (SpStringTableColumn
			title: 'SHA'
			evaluated: [ :commit | commit id ]);
		addColumn: (SpStringTableColumn
			title: 'Author'
			evaluated: [ :commit | commit author ]);
		addColumn: (SpStringTableColumn
			title: 'Message'
			evaluated: [ :commit | commit comment ]);
		addColumn: (SpStringTableColumn
			title: 'Date'
			evaluated: [ :commit | commit datetime asDate ]);
		addColumn: (SpStringTableColumn
			title: 'Time'
			evaluated: [ :commit | commit datetime asTime ]).
]
