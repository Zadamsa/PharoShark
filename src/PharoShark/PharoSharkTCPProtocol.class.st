Class {
	#name : 'PharoSharkTCPProtocol',
	#superclass : 'PharoSharkAbstractProtocol',
	#instVars : [
		'srcPort',
		'dstPort',
		'seq',
		'ack',
		'headerLength',
		'flags',
		'window',
		'checksum',
		'urgentPtr'
	],
	#category : 'PharoShark-Model',
	#package : 'PharoShark',
	#tag : 'Model'
}

{ #category : 'initialization' }
PharoSharkTCPProtocol >> initializeFromStream: aStream [

	srcPort := (aStream next: 2) asInteger.
	dstPort := (aStream next: 2) asInteger.
	seq := (aStream next: 4) asInteger.
	ack := (aStream next: 4) asInteger.
	headerLength := (aStream next) asInteger >> 4.
	flags := (aStream next)  asInteger.
	window := (aStream next: 2) asInteger.
	checksum := (aStream next: 2) asInteger.
	urgentPtr := (aStream next: 2) asInteger.

	^ true
]
