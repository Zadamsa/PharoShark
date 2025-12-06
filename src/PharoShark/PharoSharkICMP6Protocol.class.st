Class {
	#name : 'PharoSharkICMP6Protocol',
	#superclass : 'PharoSharkAbstractProtocol',
	#instVars : [
		'type',
		'code',
		'checksum',
		'body'
	],
	#category : 'PharoShark-Model',
	#package : 'PharoShark',
	#tag : 'Model'
}

{ #category : 'initialization' }
PharoSharkICMP6Protocol >> initializeFromStream: aStream [

	type := (aStream next: 1) reversed asInteger.
	code := (aStream next: 1) reversed asInteger.
	checksum := (aStream next: 2) reversed asInteger.
	body := (aStream next: 4) reversed asInteger.

	^ true
]
