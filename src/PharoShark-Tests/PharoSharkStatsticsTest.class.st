Class {
	#name : 'PharoSharkStatsticsTest',
	#superclass : 'TestCase',
	#category : 'PharoShark-Tests',
	#package : 'PharoShark-Tests'
}

{ #category : 'tests' }
PharoSharkStatsticsTest >> testDataLayerParsing [

	| bytes statistics |
	"Create packet with ethernet, IPv4 and TCP layer"
	bytes := ByteArray readHexFrom:
		         '10000000100000010100000003000000784476369819dc53602b6a4c080045000089e8dc400040067f14c0a8001e36afdb08ad2800502b4e3959fc740b8e801800e5c36e00000101080a0089d23ea32c77c2'
			         readStream.
	statistics := PharoSharkStatistics calculateFor:
		              { (PharoSharkPacket parseStream: bytes readStream) }.
	self assert: statistics ip4Ratio equals: 1.
	self assert: statistics ip6Ratio equals: 0.
	self assert: statistics tcpRatio equals: 1.
	self assert: statistics udpRatio equals: 0.
	self assert: statistics packetLengths equals: { 3 }.
	self assert: statistics flowPacketLengths values equals: { 1 }.
	self assert: statistics flowByteLengths values equals: { 3 }.
	self assert: statistics packetProtocols equals: (Dictionary new
			 at: 'TCP' put: 1;
			 yourself).
	self assert: statistics flowProtocols equals: (Dictionary new
			 at: 'TCP' put: 1;
			 yourself).
	self assert: statistics packetPorts equals: (Dictionary new
			 at: 80 put: 1;
			 at: 44328 put: 1;
			 yourself)
]
