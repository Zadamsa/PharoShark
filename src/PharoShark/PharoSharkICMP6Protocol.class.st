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

{ #category : 'accessing' }
PharoSharkICMP6Protocol >> fieldsInfo [

	^ {
		  ('Type: ' , type asString).
		  ('Code: ' , code asString).
		  ('Checksum: 0x' , (checksum printStringBase: 16)) }
]

{ #category : 'initialization' }
PharoSharkICMP6Protocol >> initializeFromStream: aStream [

	type := (aStream next: 1) reversed asInteger.
	code := (aStream next: 1) reversed asInteger.
	checksum := (aStream next: 2) reversed asInteger.
	body := (aStream next: 4) reversed asInteger.

	^ true
]

{ #category : 'as yet unclassified' }
PharoSharkICMP6Protocol >> nextProtocol [
	^ nil 
]

{ #category : 'default' }
PharoSharkICMP6Protocol >> shortName [ 
	^ 'ICMPv6'
]
