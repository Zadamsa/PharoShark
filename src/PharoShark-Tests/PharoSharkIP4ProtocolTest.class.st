Class {
	#name : 'PharoSharkIP4ProtocolTest',
	#superclass : 'TestCase',
	#category : 'PharoShark-Tests',
	#package : 'PharoShark-Tests'
}

{ #category : 'tests' }
PharoSharkIP4ProtocolTest >> testInvalidLength1 [

	| pcapPacket bytes |
	"IPv4 from too short payload"
	bytes := ByteArray readHexFrom: 'ABCDEF' readStream.
	pcapPacket := PharoSharkIP4Protocol parseStream: bytes readStream.
	self assert: pcapPacket isNil
]

{ #category : 'tests' }
PharoSharkIP4ProtocolTest >> testParsing [

	| ip4Protocol bytes |
	"Valid IPv4 header with invalid next protocol ID to avoid subsequent parsing"
	bytes := ByteArray readHexFrom:
		         '45000089e8dc400040097f14c0a8001e36afdb08' readStream.
	ip4Protocol := PharoSharkIP4Protocol parseStream: bytes readStream.
	self assert: ip4Protocol notNil.
	self assert: ip4Protocol srcIP equals: '192.168.0.30'.
	self assert: ip4Protocol dstIP equals: '54.175.219.8'.
	self assert: ip4Protocol shortName equals: 'IPv4'.
	self assert: ip4Protocol protocolNumber equals: 9.
	self assert: ip4Protocol nextProtocol isNil
]
