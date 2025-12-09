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
		'dstIP',
		'protocolNumber'
	],
	#category : 'PharoShark-Model',
	#package : 'PharoShark',
	#tag : 'Model'
}

{ #category : 'accessing' }
PharoSharkIP6Protocol >> dstIP [ 
	
	^ (dstIP inject: '' into: [ :acc :b | acc , b asString , ':' ]) allButLast .
]

{ #category : 'accessing' }
PharoSharkIP6Protocol >> fieldsInfo [

	^ {
		  ('IP version: ' , version asString).
		  ('Traffic label(QOS): ' , trafficClass asString).
		  ('Flow label: ' , flowLabel asString).
		  ('Payload length: ' , payloadLength asString).
		  ('Next protocol: ' , protocolNumber asString).
		  ('Hop limit: ' , hopLimit asString).
		  ('Source address: ' , self srcIP).
		  ('Destination address: ' , self dstIP)
		  "options ?? ." }
]

{ #category : 'initialization' }
PharoSharkIP6Protocol >> initializeFromStream: aStream [

	| firstWord |

	"Первые 4 байта: версия + traffic class + flow label"
	firstWord := (aStream next: 4) reversed asInteger.

	version := firstWord first >> 28.
	version = 6 ifFalse: [ ^ false ].

	payloadLength := (aStream next: 2) reversed asInteger.
	protocolNumber := aStream next.
	hopLimit := aStream next.

	srcIP := aStream next: 16.

	dstIP := aStream next: 16.

	protocolNumber = self class tcpType ifTrue: [
		nextProtocol := PharoSharkTCPProtocol parseStream: aStream ].

	protocolNumber = self class udpType ifTrue: [
		nextProtocol := PharoSharkUDPProtocol parseStream: aStream ].

	protocolNumber = self class icmp6Type ifTrue: [
		nextProtocol := PharoSharkICMP6Protocol parseStream: aStream ].

	^ true

]

{ #category : 'as yet unclassified' }
PharoSharkIP6Protocol >> nextProtocol [
	^ nextProtocol 
]

{ #category : 'accessing' }
PharoSharkIP6Protocol >> protocolNumber [ 
	^ protocolNumber 
]

{ #category : 'default' }
PharoSharkIP6Protocol >> shortName [ 
	^ 'IPv6'
]

{ #category : 'accessing' }
PharoSharkIP6Protocol >> srcIP [ 
	^ srcIP 
]
