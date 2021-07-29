Class {
	#name : #DepMethodModel,
	#superclass : #Object,
	#instVars : [
		'recommendation',
		'review'
	],
	#category : #'DeprecationRecommender-Spec-Models'
}

{ #category : #accessing }
DepMethodModel >> children [
	^ #()
]

{ #category : #accessing }
DepMethodModel >> icon [
	^ self iconNamed: (review isComplete
		ifTrue: [ #glamorousGreenCircle ]
		ifFalse: [ #glamorousGrayCircleEmpty ]).
]

{ #category : #initialization }
DepMethodModel >> initialize [
	super initialize.
	review := DepReview new.
]

{ #category : #accessing }
DepMethodModel >> methodClassName [

	^ recommendation method fullClassName 
]

{ #category : #accessing }
DepMethodModel >> name [
	^ recommendation method selector
]

{ #category : #accessing }
DepMethodModel >> recommendation [

	^ recommendation
]

{ #category : #accessing }
DepMethodModel >> recommendation: anObject [

	recommendation := anObject
]

{ #category : #accessing }
DepMethodModel >> review [

	^ review
]

{ #category : #accessing }
DepMethodModel >> signature [
	^ recommendation method signature
]
