Class {
	#name : 'PharoSharkUDPProtocol',
	#superclass : 'PharoSharkAbstractProtocol',
	#instVars : [
		'srcPort',
		'dstPort',
		'length',
		'checksum'
	],
	#category : 'PharoShark-Model',
	#package : 'PharoShark',
	#tag : 'Model'
}

{ #category : 'initialization' }
PharoSharkUDPProtocol >> initializeFromStream: aStream [

	srcPort := (aStream next: 2) reversed asInteger.
	dstPort := (aStream next: 2) reversed asInteger.
	length := (aStream next: 2) reversed asInteger.
	checksum := (aStream next: 2) reversed asInteger.

	^ true
]
