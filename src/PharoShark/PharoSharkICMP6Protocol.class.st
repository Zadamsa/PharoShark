"
Represents 3(network) layer of ISO/OSI model. Parses and exposes: type, code, checksum.
"
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

{ #category : 'parsing' }
PharoSharkICMP6Protocol class >> minimalHeaderSize [ 
	"type u8 + code u8 + checksum u16 + body u32"
	^  8
]

{ #category : 'accessing' }
PharoSharkICMP6Protocol >> checksum [
	"Returns ICMPv6 checksum of this packet"

	^ checksum
]

{ #category : 'accessing' }
PharoSharkICMP6Protocol >> code [
	"Returns code of this ICMPv6 packet."

	^ code
]

{ #category : 'accessing' }
PharoSharkICMP6Protocol >> fieldsInfo [

	^ {
		  ('Type: ' , type asString).
		  ('Code: ' , code asString).
		  ('Checksum: 0x' , (checksum printStringBase: 16)) }
]

{ #category : 'initialization' }
PharoSharkICMP6Protocol >> initializeFromStream: aStream [

	type := aStream next asInteger.
	code := aStream next asInteger.
	checksum := (aStream next: 2) asInteger.
	body := (aStream next: 4) asInteger.

	^ true
]

{ #category : 'accessing' }
PharoSharkICMP6Protocol >> nextProtocol [
	"ICMPv6 can't hold inner protocols."

	^ nil
]

{ #category : 'accessing' }
PharoSharkICMP6Protocol >> shortName [

	^ 'ICMPv6'
]

{ #category : 'accessing' }
PharoSharkICMP6Protocol >> type [ 
	"Returns type of this ICMPv6 message."
	^ type
	
]
