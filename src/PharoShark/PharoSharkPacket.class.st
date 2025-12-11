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

{ #category : 'parsing' }
PharoSharkPacket class >> minimalHeaderSize [ 
	"tsSec u32 + tsUsec u32 + captured length u32 + on-wire length u32"
	^  16
]

{ #category : 'formatt' }
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
	"Calculates (probably) unique flow ID for given packet. Identifies packets that belong to same flow - same src and dst IP addresses, same ports, same IP protocol value. Packets both from A->B and B->A belongs to the same flow."

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
PharoSharkPacket >> dstIP [
	"Returns destination IP as a string. IPv4 or IPv6 formatted, - if no IP layer."

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
	"Returns the flow key of this packet. The result of calculation _calculateHash_."

	^ flowKey
]

{ #category : 'accessing' }
PharoSharkPacket >> highestParsedProtocol [
	"Return the most inner sucessfully parsed protocol of this packet."

	| protocol |
	ethernetProtocol ifNil: [ ^ nil ].
	protocol := ethernetProtocol.
	[ protocol nextProtocol ] whileNotNil: [
		protocol := protocol nextProtocol ].
	^ protocol
]

{ #category : 'initialization' }
PharoSharkPacket >> initializeFromStream: aStream [

	| savedPos tsSec |
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
	"Returns captured length of the packet(part of the payload that was saved to the file)."

	^ presentLength
]

{ #category : 'accessing' }
PharoSharkPacket >> rawBytes [
	"Returns array of packet bytes starting from ethernet header."

	^ rawBytes
]

{ #category : 'accessing' }
PharoSharkPacket >> realLength [
	"Returns on-wire length of the packet (the real length of the packet when it was initially seen in the network)."

	^ realLength
]

{ #category : 'accessing' }
PharoSharkPacket >> relativeIndex [
	"Returns realtive index of the packet(counting from the beginning of the PCAP)."

	^ relativeIndex
]

{ #category : 'accessing' }
PharoSharkPacket >> relativeIndex: aRelativeIndex [
	"Setter for realtive index of the packet(counting from the beginning of the PCAP)."

	relativeIndex := aRelativeIndex
]

{ #category : 'accessing' }
PharoSharkPacket >> relativeTs [
	"Return relative timestamp(timediff with first packet of the PCAP)."

	^ relativeTs
]

{ #category : 'accessing' }
PharoSharkPacket >> relativeTs: aTs [
	"Sets relative timestamp of this packet(timediff with the first packet of given PCAP)."

	relativeTs := aTs
]

{ #category : 'accessing' }
PharoSharkPacket >> shortName [

	^ 'Captured packet'
]

{ #category : 'accessing' }
PharoSharkPacket >> srcIP [
	"Returns source IP as a string. IPv4 or IPv6 formatted, - if no IP layer."

	ethernetProtocol
		ifNil: [ ^ '-' ]
		ifNotNil: [ ^ ethernetProtocol srcIP ]
]

{ #category : 'accessing' }
PharoSharkPacket >> tsUsec [
	"Returns timestamp of the given packet in microseconds."

	^ tsUsec
]
