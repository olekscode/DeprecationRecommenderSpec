Class {
	#name : #DepReview,
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
DepReview >> initialize [
	super initialize.
	isComplete := false.
]

{ #category : #accessing }
DepReview >> isComplete [

	^ isComplete 
]

{ #category : #accessing }
DepReview >> markAsComplete [
	
	isComplete := true.
]
