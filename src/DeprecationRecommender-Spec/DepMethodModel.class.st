Class {
	#name : #DepMethodModel,
	#superclass : #Object,
	#instVars : [
		'method',
		'blamedCommit',
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
	recommendation := DepMethodRecommendation new.
	review := DepMethodReview new.
]

{ #category : #accessing }
DepMethodModel >> method: anObject [
	method := anObject
]

{ #category : #accessing }
DepMethodModel >> methodClass [
	^ method methodClass
]

{ #category : #accessing }
DepMethodModel >> name [
	^ method selector
]

{ #category : #accessing }
DepMethodModel >> recommendation [

	^ recommendation
]

{ #category : #accessing }
DepMethodModel >> review [

	^ review
]

{ #category : #accessing }
DepMethodModel >> signature [
	^ method signature
]
