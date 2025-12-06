Class {
	#name : 'PharoSharkAbstractProtocol',
	#superclass : 'Object',
	#category : 'PharoShark-Model',
	#package : 'PharoShark',
	#tag : 'Model'
}

{ #category : 'parsing' }
PharoSharkAbstractProtocol class >> parseStream: aStream [

	| parsedProtocol |
	parsedProtocol := self new.
	(parsedProtocol initializeFromStream: aStream) ifFalse: [ ^ nil ].
	^ parsedProtocol
]

{ #category : 'initialization' }
PharoSharkAbstractProtocol >> initializeFromStream: aStream [
	self subclassResponsibility 
]
