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
	^ flowByteLengths
]

{ #category : 'accessing' }
PharoSharkStatistics >> flowPacketLengths [
	^ flowPacketLengths
]

{ #category : 'accessing' }
PharoSharkStatistics >> flowProtocols [
	^ flowProtocols
]

{ #category : 'accessing' }
PharoSharkStatistics >> icmp6Ratio [
	^ icmp6Ratio
]

{ #category : 'accessing' }
PharoSharkStatistics >> icmpRatio [
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
	^ ip4Ratio
]

{ #category : 'accessing' }
PharoSharkStatistics >> ip6Ratio [
	^ ip6Ratio
]

{ #category : 'accessing' }
PharoSharkStatistics >> packetLengths [
	^ packetLengths 
]

{ #category : 'accessing' }
PharoSharkStatistics >> packetPorts [
	^ packetPorts
]

{ #category : 'accessing' }
PharoSharkStatistics >> packetProtocols [
	^ packetProtocols
]

{ #category : 'accessing' }
PharoSharkStatistics >> tcpRatio [
	^ tcpRatio
]

{ #category : 'accessing' }
PharoSharkStatistics >> udpRatio [
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
