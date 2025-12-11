Class {
	#name : 'PharoSharkIP6ProtocolTest',
	#superclass : 'TestCase',
	#category : 'PharoShark-Tests',
	#package : 'PharoShark-Tests'
}

{ #category : 'tests' }
PharoSharkIP6ProtocolTest >> testInvalidLength1 [

	| ip6Protocol bytes |
	"IPv6 from too short payload"
	bytes := ByteArray readHexFrom: 'ABCDEF' readStream.
	ip6Protocol := PharoSharkIP6Protocol parseStream: bytes readStream.
	self assert: ip6Protocol isNil
]

{ #category : 'tests' }
PharoSharkIP6ProtocolTest >> testParsing [

	| ip6Protocol bytes |
	"Valid IPv6 header with invalid next protocol ID to avoid subsequent parsing"
	bytes := ByteArray readHexFrom:
		         '6000000000b400ff00000000000000000000000000000000ff0200000000000000000000000000023a010000000000000502000000000000'
			         readStream.
	ip6Protocol := PharoSharkIP6Protocol parseStream: bytes readStream.
	self assert: ip6Protocol notNil.
	self
		assert: ip6Protocol srcIP
		equals: '00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00'.
	self
		assert: ip6Protocol dstIP
		equals: 'FF:02:00:00:00:00:00:00:00:00:00:00:00:00:00:02'.
	self assert: ip6Protocol shortName equals: 'IPv6'.
	self assert: ip6Protocol protocolNumber equals: 58.
	self assert: ip6Protocol flowLabel equals: 0.
	self assert: ip6Protocol trafficClass equals: 0.
	self assert: ip6Protocol hopLimit equals: 255.
	self assert: ip6Protocol nextProtocol isNil
]
