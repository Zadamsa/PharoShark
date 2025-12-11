"
Represents PCAP file header. Parses and validates that header contains valid magic number, supported major and minor version, and checks that it contains supported ethernet version.
"
Class {
	#name : 'PharoSharkPcapHeader',
	#superclass : 'Object',
	#instVars : [
		'magicNumber',
		'major',
		'minor',
		'timeZone',
		'tsPrecision',
		'maxSnapshotLength',
		'etherType'
	],
	#category : 'PharoShark-Model',
	#package : 'PharoShark',
	#tag : 'Model'
}

{ #category : 'parsing' }
PharoSharkPcapHeader class >> parseStream: aStream [

	| pcapHeader magic major minor timeZone precision snapLength etherType |
	pcapHeader := self new.
	magic := (aStream next: 4) reversed asInteger.
	major := (aStream next: 2) reversed asInteger.
	minor := (aStream next: 2) reversed asInteger.
	timeZone := (aStream next: 4) reversed asInteger.
	precision := (aStream next: 4) reversed asInteger.
	snapLength := (aStream next: 4) reversed asInteger.
	etherType := (aStream next: 4) reversed asInteger.

	^ self new
		  initializeWithMagic: magic
		  versionMajor: major
		  versionMinor: minor
		  timeZone: timeZone
		  precision: precision
		  maxSnapshotLength: snapLength
		  etherType: etherType;
		  yourself
]

{ #category : 'accessing' }
PharoSharkPcapHeader >> etherType [
	"Returns ethernet type used by this PCAP file."

	^ etherType
]

{ #category : 'instance creation' }
PharoSharkPcapHeader >> initializeWithMagic: aMagicNumber versionMajor: aMajor versionMinor: aMinor timeZone: aTimeZone precision: aTsPrecision maxSnapshotLength: aMaxSnapshotLength etherType: anEtherType [

	magicNumber := aMagicNumber.
	major := aMajor.
	minor := aMinor.
	timeZone := aTimeZone.
	tsPrecision := aTsPrecision.
	maxSnapshotLength := aMaxSnapshotLength.
	etherType := anEtherType
]

{ #category : 'accessing' }
PharoSharkPcapHeader >> magicNumber [
	"Returns magic number from PCAP file header."

	^ magicNumber
]

{ #category : 'accessing' }
PharoSharkPcapHeader >> major [
	"Returns major number of PCAP file."

	^ major
]

{ #category : 'accessing' }
PharoSharkPcapHeader >> maxSnapshotLength [
	"Returns maximal snapshot length from PCAP file header."

	^ maxSnapshotLength
]

{ #category : 'accessing' }
PharoSharkPcapHeader >> minor [
	"Return the minor version from PCAP file header."

	^ minor
]

{ #category : 'accessing' }
PharoSharkPcapHeader >> timeZone [
	"Returns timezone from the PCAP file header."

	^ timeZone
]
