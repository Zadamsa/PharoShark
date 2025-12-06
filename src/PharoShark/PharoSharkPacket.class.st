Class {
	#name : 'PharoSharkPacket',
	#superclass : 'Object',
	#instVars : [
		'tsSec',
		'tsUsec',
		'presentLength',
		'realLength',
		'ethernetProtocol'
	],
	#category : 'PharoShark-Model',
	#package : 'PharoShark',
	#tag : 'Model'
}

{ #category : 'parsing' }
PharoSharkPacket class >> parseStream: aStream [

	| parsedPacket |
	parsedPacket := self new.
	(parsedPacket initializeFromStream: aStream) ifFalse: [ ^ nil ].
	^ parsedPacket 
]

{ #category : 'initialization' }
PharoSharkPacket >> initializeFromStream: aStream [

	| copyStream savedPos |
	tsSec := (aStream next: 4) reversed asInteger.
	tsUsec := (aStream next: 4) reversed asInteger.
	presentLength := (aStream next: 4) reversed asInteger.
	realLength := (aStream next: 4) reversed asInteger.
	savedPos := aStream position.
	ethernetProtocol := PharoSharkEthernetProtocol parseStream:
		                    aStream .
	aStream position: savedPos.
	aStream skip: presentLength.
	^ true
]

{ #category : 'accessing' }
PharoSharkPacket >> presentLength [
	^ presentLength 
]

{ #category : 'accessing' }
PharoSharkPacket >> realLength [
	^ realLength 
]

{ #category : 'accessing' }
PharoSharkPacket >> tsSec [
	^ tsSec 
]

{ #category : 'accessing' }
PharoSharkPacket >> tsUsec [
	^ tsUsec 
]
