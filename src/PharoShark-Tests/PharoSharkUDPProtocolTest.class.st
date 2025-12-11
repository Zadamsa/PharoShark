Class {
	#name : 'PharoSharkUDPProtocolTest',
	#superclass : 'TestCase',
	#category : 'PharoShark-Tests',
	#package : 'PharoShark-Tests'
}

{ #category : 'tests' }
PharoSharkUDPProtocolTest >> testInvalidLength1 [

	| udpProtocol bytes |
	"UDP from too short payload"
	bytes := ByteArray readHexFrom: 'ABCDEF' readStream.
	udpProtocol := PharoSharkUDPProtocol parseStream: bytes readStream.
	self assert: udpProtocol isNil
]

{ #category : 'tests' }
PharoSharkUDPProtocolTest >> testParsing [

	| tcpProtocol bytes |
	"Valid UDP header with invalid next protocol ID to avoid subsequent parsing"
	bytes := ByteArray readHexFrom: 'b16a0035002ff0ed' readStream.
	tcpProtocol := PharoSharkUDPProtocol parseStream: bytes readStream.
	self assert: tcpProtocol notNil.
	self assert: tcpProtocol srcPort equals: 45418.
	self assert: tcpProtocol dstPort equals: 53.
	self assert: tcpProtocol shortName equals: 'UDP'.
	self assert: tcpProtocol checksum equals: 16rf0ed.
	self assert: tcpProtocol nextProtocol isNil
]
