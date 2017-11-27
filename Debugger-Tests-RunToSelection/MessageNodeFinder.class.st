Class {
	#name : #MessageNodeFinder,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'messageNodeCheckingBlock',
		'resultMessageNodes'
	],
	#category : #Debugger-Tests-RunToSelection
}

{ #category : #'as yet unclassified' }
MessageNodeFinder class >> findMessageNodesSatisfying: aBlock inNode: anRBProgramNode [
	^ self new findMessageNodesSatisfying: aBlock inNode: anRBProgramNode.
]

{ #category : #main }
MessageNodeFinder >> findMessageNodesSatisfying: aBlock inNode: anRBProgramNode [
	messageNodeCheckingBlock := aBlock.
	anRBProgramNode acceptVisitor: self.
	^ resultMessageNodes.
]

{ #category : #initialization }
MessageNodeFinder >> initialize [
	resultMessageNodes := LinkedList new.
]

{ #category : #initialization }
MessageNodeFinder >> visitMessageNode: aMessageNode [
	(messageNodeCheckingBlock value: aMessageNode) ifTrue: [resultMessageNodes add: aMessageNode ].
	super visitMessageNode: aMessageNode.
]
