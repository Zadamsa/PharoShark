"
Represents PCAP packet layer. Not a real ISO/OSI layer. Parses and exposes: microseconds timestamp, captured(presented in file) part of packet and on-wire(original, may be longer than caplen).
"
Class {
	#name : 'PharoSharkPacket',
	#superclass : 'PharoSharkAbstractProtocol',
	#instVars : [
		'tsUsec',
		'relativeTs',
		'relativeIndex',
		'presentLength',
		'realLength',
		'ethernetProtocol',
		'flowKey',
		'rawBytes'
	],
	#category : 'PharoShark-Model',
	#package : 'PharoShark',
	#tag : 'Model'
}

{ #category : 'as yet unclassified' }
PharoSharkPacket class >> minimalHeaderSize [ 
	"tsSec u32 + tsUsec u32 + captured length u32 + on-wire length u32"
	^  16
]

{ #category : 'as yet unclassified' }
PharoSharkPacket class >> usecTsToString: aTs [

	| usecToSec |
	usecToSec := 1_000_000.
	^ (aTs / usecToSec) floor asString , '.' , (aTs % usecToSec) asString
	  , '('
	  , (DateAndTime fromUnixTime: (aTs / usecToSec) floor) printString
	  , ')'
]

{ #category : 'accessing' }
PharoSharkPacket >> calculateHash [

	| portHash ipProtocol |
	"No ethernet layer - No hash"
	ethernetProtocol ifNil: [ ^ 0 ].
	"No IP layer - No hash"
	ethernetProtocol nextProtocol
		ifNil: [ ^ 0 ]
		ifNotNil: [ :ipLayer | ipProtocol := ipLayer protocolNumber ].
	"No transport layer - set ports to 0"
	portHash := ethernetProtocol nextProtocol nextProtocol
		            ifNil: [ 1 ]
		            ifNotNil: [ :transportLayer |
				            (transportLayer shortName = 'UDP' or:
					             transportLayer shortName = 'TCP')
					            ifTrue: [
					            transportLayer srcPort bitXor: transportLayer dstPort ]
					            ifFalse: [ 1 ] ].
	^ (self srcIP hash bitXor: self dstIP hash) * portHash * ipProtocol
]

{ #category : 'accessing' }
PharoSharkPacket >> children [
	^ { }
]

{ #category : 'displaying' }
PharoSharkPacket >> displayString [
	^ 'Captured packet:'
]

{ #category : 'accessing' }
PharoSharkPacket >> dstIP [

	ethernetProtocol
		ifNil: [ ^ '-' ]
		ifNotNil: [ ^ ethernetProtocol dstIP ]
]

{ #category : 'accessing' }
PharoSharkPacket >> fieldsInfo [

	^ { ('Timestamp :' , (self class usecTsToString: tsUsec)).
		('Captured length: ' , (presentLength asString )).
		('Onwire length: ' , (realLength asString)) }
]

{ #category : 'accessing' }
PharoSharkPacket >> flowKey [
	^ flowKey 
]

{ #category : 'accessing' }
PharoSharkPacket >> highestParsedProtocol [

	| protocol |
	ethernetProtocol ifNil: [ ^ nil ].
	protocol := ethernetProtocol.
	[ protocol nextProtocol ] whileNotNil: [
		protocol := protocol nextProtocol ].
	^ protocol
]

{ #category : 'initialization' }
PharoSharkPacket >> initializeFromStream: aStream [

	| savedPos tsSec x |
	tsSec := (aStream next: 4) reversed asInteger.
	tsUsec := (aStream next: 4) reversed asInteger + (tsSec * 1_000_000).
	presentLength := (aStream next: 4) reversed asInteger.
	realLength := (aStream next: 4) reversed asInteger.
	savedPos := aStream position.
	ethernetProtocol := PharoSharkEthernetProtocol parseStream: aStream.
	flowKey := self calculateHash.
	aStream position: savedPos.
	rawBytes := aStream upToEnd.
	aStream position: savedPos.
	(self class enoughBytesLeftIn: aStream bytes: presentLength)
		ifFalse: [ ^ false ].
	aStream skip: presentLength.

	^ true
]

{ #category : 'accessing' }
PharoSharkPacket >> nextProtocol [ 
	^ ethernetProtocol 
]

{ #category : 'accessing' }
PharoSharkPacket >> presentLength [
	^ presentLength 
]

{ #category : 'accessing' }
PharoSharkPacket >> rawBytes [
	^ rawBytes 
]

{ #category : 'accessing' }
PharoSharkPacket >> realLength [ 
	^ realLength 
]

{ #category : 'accessing' }
PharoSharkPacket >> relativeIndex [
	^ relativeIndex 
]

{ #category : 'accessing' }
PharoSharkPacket >> relativeIndex: aRelativeIndex [
	relativeIndex := aRelativeIndex 
]

{ #category : 'accessing' }
PharoSharkPacket >> relativeTs [
	^ relativeTs 
]

{ #category : 'accessing' }
PharoSharkPacket >> relativeTs: aTs [
	relativeTs := aTs 
]

{ #category : 'default' }
PharoSharkPacket >> shortName [
 	^ 'Captured packet'
]

{ #category : 'accessing' }
PharoSharkPacket >> srcIP [

	ethernetProtocol
		ifNil: [ ^ '-' ]
		ifNotNil: [ ^ ethernetProtocol srcIP ]
]

{ #category : 'accessing' }
PharoSharkPacket >> tsUsec [
	^ tsUsec 
]
