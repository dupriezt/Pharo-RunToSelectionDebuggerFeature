"
Test suite for the run to selection feature of the debugger. (In a debugger, select some code or place the carret somewhere, then right-click and one of the options will be 'Run to here')
"
Class {
	#name : #DebuggerRunToSelectionTest,
	#superclass : #TestCase,
	#instVars : [
		'sessionRTS1',
		'processRTS1',
		'contextRTS1',
		'sessionRTS2',
		'processRTS2',
		'contextRTS2',
		'sessionRTS3',
		'processRTS3',
		'contextRTS3',
		'sessionRTS4',
		'processRTS4',
		'contextRTS4'
	],
	#category : #Debugger-Tests-RunToSelection
}

{ #category : #'instance creation' }
DebuggerRunToSelectionTest >> contextForRunToSelectionTest1 [
	^ [1+1.
		self evalBlock:[
			2+2.
			3+3.
			4+4."< test will attempt to run to here and should arrive there"
		].
		5+5.
	] asContext.
]

{ #category : #'instance creation' }
DebuggerRunToSelectionTest >> contextForRunToSelectionTest2 [
	^ [ 
		1+1.
		2+2.
		3+3."< test will attempt to run to here and should arrive there"
	] asContext.
]

{ #category : #'instance creation' }
DebuggerRunToSelectionTest >> contextForRunToSelectionTest3 [
	^ [ 
		1+1.
		[
			2+2.
			3+3.
			4+4."< test will attempt to run to here and should arrive there"
		] value.
		5+5.
	] asContext.
]

{ #category : #'instance creation' }
DebuggerRunToSelectionTest >> contextForRunToSelectionTest4 [
	^ [1+1.
		self doNotEvalBlock:[
			2+2.
			3+3.
			4+4."< test will attempt to run to here"
		].
		5+5."< test should arrive here"
	] asContext.
]

{ #category : #'instance creation' }
DebuggerRunToSelectionTest >> doNotEvalBlock: aBlock [
]

{ #category : #'instance creation' }
DebuggerRunToSelectionTest >> evalBlock: aBlock [
	aBlock value.
]

{ #category : #'instance creation' }
DebuggerRunToSelectionTest >> setUp [
	contextRTS1 := self contextForRunToSelectionTest1.
	processRTS1 := Process 
		forContext: contextRTS1 
		priority: Processor userInterruptPriority.
	sessionRTS1:= processRTS1 newDebugSessionNamed: 'test session RTS1' startedAt: contextRTS1.
	
	contextRTS2 := self contextForRunToSelectionTest2.
	processRTS2 := Process 
		forContext: contextRTS2 
		priority: Processor userInterruptPriority.
	sessionRTS2:= processRTS2 newDebugSessionNamed: 'test session RTS2' startedAt: contextRTS2.
	
	contextRTS3 := self contextForRunToSelectionTest3.
	processRTS3 := Process 
		forContext: contextRTS3 
		priority: Processor userInterruptPriority.
	sessionRTS3:= processRTS3 newDebugSessionNamed: 'test session RTS3' startedAt: contextRTS3.
	
	contextRTS4 := self contextForRunToSelectionTest4.
	processRTS4 := Process 
		forContext: contextRTS4 
		priority: Processor userInterruptPriority.
	sessionRTS4:= processRTS4 newDebugSessionNamed: 'test session RTS4' startedAt: contextRTS4.
]

{ #category : #'instance creation' }
DebuggerRunToSelectionTest >> testRunToSelectionInContext1 [
"Testing: Run to here in a block that is evaluated by another function"
	| start stop targetNode |
	start := 82.
	stop := 81.
	sessionRTS1 runToSelection: (Interval from: start to: stop) inContext: contextRTS1.
	"Uncomment the following halt, run the test to trigger it, and execute the `Smalltalk tools` line to graphically open the debugSession manipulated by this test."
	"self halt."
	"Smalltalk tools debugger openOn: sessionRTS1 withFullView: true."
	self assert: (contextRTS1 pc isNotNil).
	self assert: (sessionRTS1 interruptedContext method == (self class>>#contextForRunToSelectionTest1)).
	"When the test runner notifies that the following assert is wrong, the pc of contextRTS1 will be nil because it notifies after the test execution has been completed. Put a halt before this assert to get the real value of the pc after the execution navigation operation from above. This behaviour is demonstrated by the fact the previous isNotNil assert did NOT fail, so the pc was not nil when the asserts were checked"
	targetNode := (MessageNodeFinder findMessageNodesSatisfying: [ :msgNode | msgNode arguments size = 1 and: [ (msgNode arguments at: 1) = (RBLiteralValueNode value: 4)  and: [ msgNode selector = #+ ] ] ] inNode: ((self class >>#contextForRunToSelectionTest1) ast body)) first.
	self assert: ((contextRTS1 method sourceNodeForPC: contextRTS1 pc) == targetNode).
]

{ #category : #'instance creation' }
DebuggerRunToSelectionTest >> testRunToSelectionInContext2 [
"Testing: Run to here in code without blocks"
	| start stop targetNode |
	start := 50.
	stop := 49.
	sessionRTS2 runToSelection: (Interval from: start to: stop) inContext: contextRTS2.
	"Uncomment the following halt, run the test to trigger it, and execute the `Smalltalk tools` line to graphically open the debugSession manipulated by this test."
	"self halt."
	"Smalltalk tools debugger openOn: sessionRTS2 withFullView: true."
	self assert: (contextRTS2 pc isNotNil).
	self assert: (sessionRTS2 interruptedContext method == (self class>>#contextForRunToSelectionTest2)).
	"When the test runner notifies that the following assert is wrong, the pc of contextRTS2 will be nil because it notifies after the test execution has been completed. Put a halt before this assert to get the real value of the pc after the execution navigation operation from above. This behaviour is demonstrated by the fact the previous isNotNil assert did NOT fail, so the pc was not nil when the asserts were checked"
	targetNode := (MessageNodeFinder findMessageNodesSatisfying: [ :msgNode | msgNode arguments size = 1 and: [ (msgNode arguments at: 1) = (RBLiteralValueNode value: 3)  and: [ msgNode selector = #+ ] ] ] inNode: ((self class >>#contextForRunToSelectionTest2) ast body)) first.
	self assert: ((contextRTS2 method sourceNodeForPC: contextRTS2 pc) == targetNode).
]

{ #category : #'instance creation' }
DebuggerRunToSelectionTest >> testRunToSelectionInContext3 [
"Testing: Run to here in a block that is directly evaluated in the same method by sending it the `value` message"
	| start stop targetNode |
	start := 71.
	stop := 70.
	sessionRTS3 runToSelection: (Interval from: start to: stop) inContext: contextRTS3.
	"Uncomment the following halt, run the test to trigger it, and execute the `Smalltalk tools` line to graphically open the debugSession manipulated by this test."
	"self halt."
	"Smalltalk tools debugger openOn: sessionRTS3 withFullView: true."
	self assert: (contextRTS3 pc isNotNil).
	self assert: (sessionRTS3 interruptedContext method == (self class>>#contextForRunToSelectionTest3)).
	"When the test runner notifies that the following assert is wrong, the pc of contextRTS3 will be nil because it notifies after the test execution has been completed. Put a halt before this assert to get the real value of the pc after the execution navigation operation from above. This behaviour is demonstrated by the fact the previous isNotNil assert did NOT fail, so the pc was not nil when the asserts were checked"
	targetNode := (MessageNodeFinder findMessageNodesSatisfying: [ :msgNode | msgNode arguments size = 1 and: [ (msgNode arguments at: 1) = (RBLiteralValueNode value: 4)  and: [ msgNode selector = #+ ] ] ] inNode: ((self class >>#contextForRunToSelectionTest3) ast body)) first.
	self assert: ((contextRTS3 method sourceNodeForPC: contextRTS3 pc) == targetNode).
]

{ #category : #'instance creation' }
DebuggerRunToSelectionTest >> testRunToSelectionInContext4 [
"Testing: Run to here in a block that is not evaluated."
	| start stop targetNode |
	start := 89.
	stop := 88.
	sessionRTS4 runToSelection: (Interval from: start to: stop) inContext: contextRTS4.
	"Uncomment the following halt, run the test to trigger it, and execute the `Smalltalk tools` line to graphically open the debugSession manipulated by this test."
	"self halt."
	"Smalltalk tools debugger openOn: sessionRTS4 withFullView: true."
	self assert: (contextRTS4 pc isNotNil).
	self assert: (sessionRTS4 interruptedContext method == (self class>>#contextForRunToSelectionTest4)).
	"When the test runner notifies that the following assert is wrong, the pc of contextRTS4 will be nil because it notifies after the test execution has been completed. Put a halt before this assert to get the real value of the pc after the execution navigation operation from above. This behaviour is demonstrated by the fact the previous isNotNil assert did NOT fail, so the pc was not nil when the asserts were checked"
	targetNode := (MessageNodeFinder findMessageNodesSatisfying: [ :msgNode | msgNode arguments size = 1 and: [ (msgNode arguments at: 1) = (RBLiteralValueNode value: 5)  and: [ msgNode selector = #+ ] ] ] inNode: ((self class >>#contextForRunToSelectionTest4) ast body)) first.
	self assert: ((contextRTS4 method sourceNodeForPC: contextRTS4 pc) == targetNode).
]
