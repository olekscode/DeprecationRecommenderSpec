Class {
	#name : #DepExperimentStep,
	#superclass : #Object,
	#instVars : [
		'name',
		'presenterProvider',
		'isComplete'
	],
	#category : #'DeprecationRecommender-Spec'
}

{ #category : #accessing }
DepExperimentStep >> icon [

	^ self iconNamed: (isComplete ifTrue: [ #testGreen ] ifFalse: [ #testNotRun ])
]

{ #category : #initialization }
DepExperimentStep >> initialize [
	super initialize.
	isComplete := false.
]

{ #category : #accessing }
DepExperimentStep >> isComplete [

	^ isComplete
]

{ #category : #'as yet unclassified' }
DepExperimentStep >> markAsComplete [
	
	isComplete := true.
]

{ #category : #'as yet unclassified' }
DepExperimentStep >> markAsIncomplete [
	
	isComplete := false.
]

{ #category : #accessing }
DepExperimentStep >> name [

	^ name
]

{ #category : #accessing }
DepExperimentStep >> name: anObject [

	name := anObject
]

{ #category : #accessing }
DepExperimentStep >> presenterProvider [

	^ presenterProvider
]

{ #category : #accessing }
DepExperimentStep >> presenterProvider: anObject [

	presenterProvider := anObject
]
