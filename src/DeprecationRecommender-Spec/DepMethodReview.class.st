Class {
	#name : #DepMethodReview,
	#superclass : #Object,
	#instVars : [
		'acceptedRefactorings',
		'isRefactoring',
		'isDontKnowRefactoring',
		'refactoringComment',
		'acceptedReplacements',
		'replacementComment',
		'isDontKnowReplacement',
		'isComplete'
	],
	#category : #'DeprecationRecommender-Spec-Models'
}

{ #category : #accessing }
DepMethodReview >> initialize [
	super initialize.
	isComplete := false.
]

{ #category : #accessing }
DepMethodReview >> isComplete [

	^ isComplete 
]

{ #category : #accessing }
DepMethodReview >> markAsComplete [
	
	isComplete := true.
]
