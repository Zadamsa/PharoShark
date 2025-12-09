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

{ #category : 'comparing' }
PharoSharkAbstractProtocol >> contains: aProtocolName [

	aProtocolName == self shortName ifTrue: [ ^ true ].
	self nextProtocol ifNil: [ ^ false ].
	^ self nextProtocol contains: aProtocolName
]

{ #category : 'accessing' }
PharoSharkAbstractProtocol >> fieldsInfo [
	self subclassResponsibility 
]

{ #category : 'initialization' }
PharoSharkAbstractProtocol >> initializeFromStream: aStream [
	self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
PharoSharkAbstractProtocol >> nextProtocol [
	self subclassResponsibility 
]

{ #category : 'default' }
PharoSharkAbstractProtocol >> shortName [
	self subclassResponsibility 
]
