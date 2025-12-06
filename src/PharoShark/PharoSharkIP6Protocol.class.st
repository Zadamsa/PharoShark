Class {
	#name : 'PharoSharkIP6Protocol',
	#superclass : 'PharoSharkAbstractProtocol',
	#instVars : [
		'version',
		'trafficClass',
		'flowLabel',
		'payloadLength',
		'nextProtocol',
		'hopLimit',
		'srcIP',
		'dstIP'
	],
	#category : 'PharoShark-Model',
	#package : 'PharoShark',
	#tag : 'Model'
}

{ #category : 'parsing' }
PharoSharkIP6Protocol class >> parseStream: aStream [
	^ nil
]

{ #category : 'initialization' }
PharoSharkIP6Protocol >> initializeFromStream: aStream [

	| firstWord nextType |

	"Первые 4 байта: версия + traffic class + flow label"
	firstWord := (aStream next: 4) reversed asInteger.

	version := firstWord first >> 28.
	version = 6 ifFalse: [ ^ false ].

	payloadLength := (aStream next: 2) reversed asInteger.
	nextType := aStream next.
	hopLimit := aStream next.

	srcIP := aStream next: 16.

	dstIP := aStream next: 16.

	nextType = self class tcpType ifTrue: [
		nextProtocol := PharoSharkTCPProtocol parseStream: aStream ].

	nextType = self class udpType ifTrue: [
		nextProtocol := PharoSharkUDPProtocol parseStream: aStream ].

	nextType = self class icmp6Type ifTrue: [
		nextProtocol := PharoSharkICMP6Protocol parseStream: aStream ].

	^ true

]
