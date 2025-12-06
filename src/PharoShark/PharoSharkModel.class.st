Class {
	#name : 'PharoSharkModel',
	#superclass : 'Object',
	#instVars : [
		'packets'
	],
	#category : 'PharoShark-Model',
	#package : 'PharoShark',
	#tag : 'Model'
}

{ #category : 'initialization' }
PharoSharkModel >> initialize [ 
	packets :=  #(10 20 30) "OrderedCollection new".
]

{ #category : 'accessing' }
PharoSharkModel >> packets [

	^ packets
]

{ #category : 'parsing' }
PharoSharkModel >> parseFile: aFile [

	| parsedPackets packet header |
	parsedPackets := OrderedCollection new.

	header := PharoSharkPcapHeader parseStream: aFile binaryReadStream.
	header ifNil: [ ^ #( #error 'Failed to read header from file!' ) ].
	header magicNumber = 16rA1B2B3B4 ifFalse: [ ^ #( #error 'Invalid magic number found!') ].
	header major = 2 ifFalse: [ ^ #( #error 'Unsupported major version ', header major , '!') ].
	header minor = 4 ifFalse: [ ^ #( #error 'Invalid magic number found!') ].
	header etherType = 1 ifFalse: [ ^ #( #error 'Invalid magic number found!') ].

	[ packet := PharoSharkPacket parseStream: aFile readStream ]
		whileNotNil: [ parsedPackets append: packet ]
]
