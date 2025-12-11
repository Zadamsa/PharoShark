Class {
	#name : 'PharoSharkTCPProtocolTest',
	#superclass : 'TestCase',
	#category : 'PharoShark-Tests',
	#package : 'PharoShark-Tests'
}

{ #category : 'tests' }
PharoSharkTCPProtocolTest >> testInvalidLength1 [

	| tcpProtocol bytes |
	"TCP from too short payload"
	bytes := ByteArray readHexFrom: 'ABCDEF' readStream.
	tcpProtocol := PharoSharkTCPProtocol parseStream: bytes readStream.
	self assert: tcpProtocol isNil
]

{ #category : 'tests' }
PharoSharkTCPProtocolTest >> testParsing [

	| tcpProtocol bytes |
	"Valid TCP header with invalid next protocol ID to avoid subsequent parsing"
	bytes := ByteArray readHexFrom:
		         'ad2800502b4e3959fc740b8e801800e5c36e00000101080a0089d23ea32c77c2'
			         readStream.
	tcpProtocol := PharoSharkTCPProtocol parseStream: bytes readStream.
	self assert: tcpProtocol notNil.
	self assert: tcpProtocol srcPort equals: 44328.
	self assert: tcpProtocol dstPort equals: 80.
	self assert: tcpProtocol shortName equals: 'TCP'.
	self assert: tcpProtocol window equals: 229.
	self assert: tcpProtocol flags equals: 16r18.
	self assert: tcpProtocol checksum equals: 16rc36e.
	self assert: tcpProtocol nextProtocol isNil
]
