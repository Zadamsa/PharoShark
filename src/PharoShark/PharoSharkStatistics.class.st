"
Statistics calculating class. Calculates all required statistics from given list of PCAP packets. Calculates IPv4/IPv6, TCP/UDP ratios. Matches top level protocols, flow lengths (in packets and bytes) to flows.
"
Class {
	#name : 'PharoSharkStatistics',
	#superclass : 'Object',
	#instVars : [
		'packetLengths',
		'flowPacketLengths',
		'flowByteLengths',
		'packetProtocols',
		'flowProtocols',
		'packetPorts',
		'ip4Ratio',
		'ip6Ratio',
		'tcpRatio',
		'udpRatio',
		'icmpRatio',
		'icmp6Ratio'
	],
	#category : 'PharoShark-Model',
	#package : 'PharoShark',
	#tag : 'Model'
}

{ #category : 'as yet unclassified' }
PharoSharkStatistics class >> calculateFor: aPackets [
	^ self new initializeFrom: aPackets ; yourself . 
 
]

{ #category : 'as yet unclassified' }
PharoSharkStatistics class >> dictionaryToValueFrequencyDictionary: aDictionary [

	| frequencyDictionary |
	frequencyDictionary := Dictionary new.
	aDictionary valuesDo: [ :value |
			frequencyDictionary at: value ifAbsentPut: [ 0 ].
			frequencyDictionary
				at: value
				put: (frequencyDictionary at: value) + 1 ].
	^ frequencyDictionary
]

{ #category : 'calcu' }
PharoSharkStatistics >> calculateRatios: aPackets [
	"Calculates protocol ratios of given packets."

	ip4Ratio := (aPackets count: [ :packet | packet contains: 'IPv4' ])
		            asFloat / aPackets size.
	ip6Ratio := (aPackets count: [ :packet | packet contains: 'IPv6' ])
		            asFloat / aPackets size.
	icmpRatio := (aPackets count: [ :packet | packet contains: 'ICMP' ])
		             asFloat / aPackets size.
	icmp6Ratio := (aPackets count: [ :packet | packet contains: 'ICMPv6' ])
		              asFloat / aPackets size.
	tcpRatio := (aPackets count: [ :packet | packet contains: 'TCP' ])
		            asFloat / aPackets size.
	udpRatio := (aPackets count: [ :packet | packet contains: 'UDP' ])
		            asFloat / aPackets size
]

{ #category : 'accessing' }
PharoSharkStatistics >> flowByteLengths [
	"Returns dictionary of flowKey->total count of bytes in this flow."

	^ flowByteLengths
]

{ #category : 'accessing' }
PharoSharkStatistics >> flowPacketLengths [
	"Returns dictionary of flowKey->count of packets in this flow."

	^ flowPacketLengths
]

{ #category : 'accessing' }
PharoSharkStatistics >> flowProtocols [
	"Returns dictionary of protocol short name -> count of flows with this protocol as highest."

	^ flowProtocols
]

{ #category : 'accessing' }
PharoSharkStatistics >> icmp6Ratio [
	"Returns ratio of ICMPv6 packets."

	^ icmp6Ratio
]

{ #category : 'accessing' }
PharoSharkStatistics >> icmpRatio [
	"Returns ratio of ICMP packets."

	^ icmpRatio
]

{ #category : 'initialization' }
PharoSharkStatistics >> initializeFrom: aPackets [

	packetLengths := aPackets collect: #realLength.
	flowPacketLengths := Dictionary new.
	flowByteLengths := Dictionary new.
	packetProtocols := Dictionary new.
	flowProtocols := Dictionary new.
	packetPorts := Dictionary new.

	aPackets do: [ :packet | self updatePacketData: packet ].
	flowProtocols := self class dictionaryToValueFrequencyDictionary:
		                 flowProtocols.

	self calculateRatios: aPackets
]

{ #category : 'accessing' }
PharoSharkStatistics >> ip4Ratio [
	"Returns ratio of IPv4 packets."

	^ ip4Ratio
]

{ #category : 'accessing' }
PharoSharkStatistics >> ip6Ratio [
	"Returns ratio of IPv6 packets."

	^ ip6Ratio
]

{ #category : 'accessing' }
PharoSharkStatistics >> packetLengths [
	"Returns array of packet lengths in original order."

	^ packetLengths
]

{ #category : 'accessing' }
PharoSharkStatistics >> packetPorts [
	^ packetPorts
]

{ #category : 'accessing' }
PharoSharkStatistics >> packetProtocols [
	"Returns dictionary of protocol short name -> count of packets with this protocol as highest."

	^ packetProtocols
]

{ #category : 'accessing' }
PharoSharkStatistics >> tcpRatio [
	"Returns ratio of TCP packets."

	^ tcpRatio
]

{ #category : 'accessing' }
PharoSharkStatistics >> udpRatio [
	"Returns ratio of UDP packets."

	^ udpRatio
]

{ #category : 'calcu' }
PharoSharkStatistics >> updatePacketData: aPacket [

	flowPacketLengths at: aPacket flowKey ifAbsentPut: [ 0 ].
	flowPacketLengths
		at: aPacket flowKey
		put: (flowPacketLengths at: aPacket flowKey) + 1.

	flowByteLengths at: aPacket flowKey ifAbsentPut: [ 0 ].
	flowByteLengths
		at: aPacket flowKey
		put: (flowByteLengths at: aPacket flowKey) + aPacket realLength.

	packetProtocols
		at: aPacket highestParsedProtocol shortName
		ifAbsentPut: [ 0 ].
	packetProtocols
		at: aPacket highestParsedProtocol shortName
		put:
		(packetProtocols at: aPacket highestParsedProtocol shortName) + 1.

	flowProtocols
		at: aPacket flowKey
		ifAbsentPut: [ aPacket highestParsedProtocol shortName ].

	self updatePortData: aPacket
]

{ #category : 'calcu' }
PharoSharkStatistics >> updatePortData: aPacket [

	(aPacket highestParsedProtocol shortName = 'UDP' or:
		 aPacket highestParsedProtocol shortName = 'TCP') ifFalse: [ ^ nil ].

	packetPorts
		at: aPacket highestParsedProtocol srcPort
		ifAbsentPut: [ 0 ].
	packetPorts
		at: aPacket highestParsedProtocol srcPort
		put: (packetPorts at: aPacket highestParsedProtocol srcPort) + 1.

	packetPorts
		at: aPacket highestParsedProtocol dstPort
		ifAbsentPut: [ 0 ].
	packetPorts
		at: aPacket highestParsedProtocol dstPort
		put: (packetPorts at: aPacket highestParsedProtocol dstPort) + 1
]
