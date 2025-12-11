"
Helper class that provides possible next protocol numbers for IPv4 and IPv6 parsing.
"
Class {
	#name : 'PharoSharkIPNextProtocolTypes',
	#superclass : 'Object',
	#category : 'PharoShark-Model',
	#package : 'PharoShark',
	#tag : 'Model'
}

{ #category : 'as yet unclassified' }
PharoSharkIPNextProtocolTypes class >> icmp6Type [
	^ 58
]

{ #category : 'as yet unclassified' }
PharoSharkIPNextProtocolTypes class >> icmpType [
	^ 1
]

{ #category : 'as yet unclassified' }
PharoSharkIPNextProtocolTypes class >> ipv6HopByHopType [
	^ 0
]

{ #category : 'as yet unclassified' }
PharoSharkIPNextProtocolTypes class >> tcpType [
	^ 6
]

{ #category : 'as yet unclassified' }
PharoSharkIPNextProtocolTypes class >> udpType [
	^ 17
]
