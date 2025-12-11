"
Abstract base class for all protocols that PharoShark supports. Every protocol must define its minimal header size in _minimalHeaderSize_ and parsing is automaticaly failed if the stream doesn't contain enough bytes. Constructor is _initializeFromStream_. Also defines _nextProtocol_ which allows recursively traverse from outer layers to inner. _fieldsInfo_ is used to provide a menu items that are used in deep info about each packet.
"
Class {
	#name : 'PharoSharkAbstractProtocol',
	#superclass : 'Object',
	#category : 'PharoShark-Model',
	#package : 'PharoShark',
	#tag : 'Model'
}

{ #category : 'parsing' }
PharoSharkAbstractProtocol class >> enoughBytesLeftIn: aStream bytes: aCount [
	"Helper function to check if stream contains atleast aCount bytes."

	^ aStream size - aStream position >= aCount
]

{ #category : 'parsing' }
PharoSharkAbstractProtocol class >> minimalHeaderSize [
	"Must return the minial possible size of the valid header of the protocol."

	self subclassResponsibility
]

{ #category : 'parsing' }
PharoSharkAbstractProtocol class >> parseStream: aStream [
	"The main enty for every protocol parsing routine."

	| parsedProtocol |
	parsedProtocol := self new.
	(self enoughBytesLeftIn: aStream bytes: self minimalHeaderSize)
		ifFalse: [ ^ nil ].
	(parsedProtocol initializeFromStream: aStream) ifFalse: [ ^ nil ].
	^ parsedProtocol
]

{ #category : 'comparing' }
PharoSharkAbstractProtocol >> contains: aProtocolName [
	"Recursively checks if current layer or any of inner layers is a method argument."

	aProtocolName = self shortName ifTrue: [ ^ true ].
	self nextProtocol ifNil: [ ^ false ].
	^ self nextProtocol contains: aProtocolName
]

{ #category : 'accessing' }
PharoSharkAbstractProtocol >> fieldsInfo [
	"Must return an array of strings that will be printed in deep packet inspection menu."

	self subclassResponsibility
]

{ #category : 'initialization' }
PharoSharkAbstractProtocol >> initializeFromStream: aStream [
	"The main parsing logick of the layer. In this method all fields of the layer must be initialized from the input stream. Stream already contains at least _minimalHeaderSize_ bytes. If the parsing requires more than minimal header size bytes additional checks are required too"

	self subclassResponsibility
]

{ #category : 'accessing' }
PharoSharkAbstractProtocol >> nextProtocol [
	"Must return next layer protocol or nil if the current layer is last one or parsing error."

	self subclassResponsibility
]

{ #category : 'accessing' }
PharoSharkAbstractProtocol >> shortName [
	self subclassResponsibility 
]
