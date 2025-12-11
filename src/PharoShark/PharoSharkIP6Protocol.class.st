"
Represents 3(network) layer of ISO/OSI model. Parses and exposes: source and destination IP addresses, flow label, hop limit, traffic class.
"
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

{ #category : 'as yet unclassified' }
PharoSharkIP6Protocol class >> minimalHeaderSize [ 
	"Minimal possible IPv6 header size from specification"
	^  40
]

{ #category : 'accessing' }
PharoSharkIP6Protocol >> dstIP [

	^ ':' join: (dstIP asArray collect: [ :each |
			   (each printStringBase: 16) padLeftTo: 2 with: $0 ])
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
		  ('Destination address: ' , self dstIP) }
]

{ #category : 'accessing' }
PharoSharkIP6Protocol >> flowLabel [
	^ flowLabel 
]

{ #category : 'accessing' }
PharoSharkIP6Protocol >> hopLimit [ 
	^ hopLimit 
]

{ #category : 'initialization' }
PharoSharkIP6Protocol >> initializeFromStream: aStream [

	| firstWord |
	firstWord := (aStream next: 4) asInteger.

	version := firstWord >> 28.
	version = 6 ifFalse: [ ^ false ].
	trafficClass := (firstWord >> 20) bitAnd: 16rFF.
	flowLabel := firstWord bitAnd: 16rFFFFF.

	payloadLength := (aStream next: 2) asInteger.
	protocolNumber := aStream next.
	hopLimit := aStream next.

	srcIP := aStream next: 16.

	dstIP := aStream next: 16.

	protocolNumber = PharoSharkIPNextProtocolTypes ipv6HopByHopType
		ifTrue: [
				| restLength |
				protocolNumber := aStream next.
				restLength := aStream next + 1.
				restLength := restLength * 8 - 2.
				(self class enoughBytesLeftIn: aStream bytes: restLength)
					ifFalse: [ ^ false ].
				aStream skip: restLength ].

	protocolNumber = PharoSharkIPNextProtocolTypes tcpType ifTrue: [
		nextProtocol := PharoSharkTCPProtocol parseStream: aStream ].

	protocolNumber = PharoSharkIPNextProtocolTypes udpType ifTrue: [
		nextProtocol := PharoSharkUDPProtocol parseStream: aStream ].

	protocolNumber = PharoSharkIPNextProtocolTypes icmp6Type ifTrue: [
		nextProtocol := PharoSharkICMP6Protocol parseStream: aStream ].

	^ true
]

{ #category : 'accessing' }
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

	^ ':' join: (srcIP asArray collect: [ :each |
			   (each printStringBase: 16) padLeftTo: 2 with: $0 ])
]

{ #category : 'accessing' }
PharoSharkIP6Protocol >> trafficClass [ 
	^ trafficClass 
]
