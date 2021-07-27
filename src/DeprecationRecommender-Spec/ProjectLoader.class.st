Class {
	#name : #ProjectLoader,
	#superclass : #SpPresenter,
	#instVars : [
		'projectDropdown',
		'oldVersionInput',
		'newVersionInput',
		'loadButton',
		'callback'
	],
	#category : #'DeprecationRecommender-Spec-Views'
}

{ #category : #accessing }
ProjectLoader class >> defaultExtent [
	^ 300@190
]

{ #category : #specs }
ProjectLoader class >> defaultSpec [
	| labelWidth |
	labelWidth := 75.
	
	^ SpBoxLayout newVertical
		add: '';
		add: (SpBoxLayout newVertical
			spacing: 7;
			add: (SpBoxLayout newHorizontal
				add: 'Project' width: labelWidth;
				add: #projectDropdown;
				yourself) height: self buttonHeight;
			add: (SpBoxLayout newHorizontal
				add: 'Old version' width: labelWidth;
				add: #oldVersionInput;
				yourself) height: self buttonHeight;
			add: (SpBoxLayout newHorizontal
				add: 'New version' width: labelWidth;
				add: #newVersionInput;
				yourself) height: self buttonHeight;
			add: (SpBoxLayout newHorizontal
				add: '';
				add: #loadButton width: self buttonWidth;
				add: '';
				yourself) height: self buttonHeight;
			yourself);
		add: '';
		yourself.
]

{ #category : #accessing }
ProjectLoader class >> defaultTitle [
	^ 'Select a project'
]

{ #category : #examples }
ProjectLoader class >> open [
	<example>
	self new openWithSpec
]

{ #category : #accessing }
ProjectLoader >> callback: aBlock [
	callback := aBlock
]

{ #category : #initialization }
ProjectLoader >> connectPresenters [ 
	| repository |
	super connectPresenters.
	
	oldVersionInput action: [
		repository := projectDropdown selectedItem.
		
		repository 
			ifNil: [ self inform: 'Please select a project' ]
			ifNotNil: [
				(DepCommitSelector on: (self extractAllCommitsFrom: repository))
					callback: [ :commit | self onOldVersionSelected: commit ];
					openWithSpec ] ].
			
	newVersionInput action: [
		repository := projectDropdown selectedItem.
		
		repository 
			ifNil: [ self inform: 'Please select a project' ]
			ifNotNil: [
				(DepCommitSelector on: (self extractAllCommitsFrom: repository))
					callback: [ :commit | self onNewVersionSelected: commit ];
					openWithSpec ] ].
			
	loadButton action: [
		callback value: projectDropdown selectedItem value: oldVersionInput text.
		self window close ].
]

{ #category : #'as yet unclassified' }
ProjectLoader >> currentVersionText [
	^ '<current version>'
]

{ #category : #'as yet unclassified' }
ProjectLoader >> extractAllCommitsFrom: aRepository [
	"Extract commits from all branches of a repository"
	| commits |
	
	commits := (aRepository allBranches flatCollect: [ :branch | branch commits ]) asSet.
	^ commits asArray sorted: [ :a :b | a datetime > b datetime ]
]

{ #category : #initialization }
ProjectLoader >> initializePresenters [
	super initializePresenters.
	
	projectDropdown := self newDropList
		items: (IceRepository registry select: [ :repository | repository isValid ]);
		display: [ :repository | repository name ];
		yourself.
	
	oldVersionInput := self instantiate: DepTextInputWithButton.
	newVersionInput := self instantiate: DepTextInputWithButton.
	
	newVersionInput text: self currentVersionText.
	
	loadButton := self newButton
		label: 'Load';
		yourself.
]

{ #category : #initialization }
ProjectLoader >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	
	aWindowPresenter
		title: self class defaultTitle;
		initialExtent: self class defaultExtent;
		centered.
]

{ #category : #'as yet unclassified' }
ProjectLoader >> onNewVersionSelected: aCommit [
	self showCommitSha: aCommit id in: newVersionInput
]

{ #category : #'as yet unclassified' }
ProjectLoader >> onOldVersionSelected: aCommit [
	self showCommitSha: aCommit id in: oldVersionInput
]

{ #category : #'as yet unclassified' }
ProjectLoader >> showCommitSha: aCommitSha in: aTextInput [
	| repository |
	repository := projectDropdown selectedItem.
	
	aTextInput text: (aCommitSha = repository head commit id
		ifTrue: [ self currentVersionText ]
		ifFalse: [ aCommitSha ]).
]
