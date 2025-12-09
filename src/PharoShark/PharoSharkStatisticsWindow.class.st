Class {
	#name : 'PharoSharkStatisticsWindow',
	#superclass : 'SpPresenter',
	#instVars : [
		'packetLengthStatistics',
		'textStatisticsWindow'
	],
	#category : 'PharoShark-Present',
	#package : 'PharoShark',
	#tag : 'Present'
}

{ #category : 'initialization' }
PharoSharkStatisticsWindow >> initializeLayout [

	| graphLayout |
	graphLayout := SpBoxLayout new.
	graphLayout layout: (SpGridLayout new: 3).

	graphLayout add: (SpLabelPresenter new label: '1').
	graphLayout add: (SpLabelPresenter new label: '2').
	graphLayout add: (SpLabelPresenter new label: '3').
	graphLayout add: (SpLabelPresenter new label: '4').
	graphLayout add: (SpLabelPresenter new label: '5').
	graphLayout add: (SpLabelPresenter new label: '6').
	graphLayout spacing: 10.

	self layout: (SpBoxLayout newVertical
			 add: textStatisticsWindow;
			 add: graphLayout;
			 spacing: 10;
			 yourself)
]

{ #category : 'initialization' }
PharoSharkStatisticsWindow >> initializePresenters [

	self instantiatePresenters.
	self initializeLayout
]

{ #category : 'as yet unclassified' }
PharoSharkStatisticsWindow >> instantiatePresenters [

	packetLengthStatistics := self instantiate: SpNullPresenter.
	textStatisticsWindow := self instantiate: SpNullPresenter
]

{ #category : 'as yet unclassified' }
PharoSharkStatisticsWindow >> packetStatistics: aStatistics [

	packetLengthStatistics := (RSHistogramPlot new
		                           x: aStatistics packetLengths;
		                           title: 'Packet length histogram';
		                           yourself) asPresenter.
	textStatisticsWindow := self instantiate: SpTextPresenter.

	textStatisticsWindow text: (String cr join: {
			('IPv4 ratio: ' , aStatistics ip4Ratio).
			('IPv6 ratio: ' , aStatistics ip6Ratio).
			('TCP ratio: ' , aStatistics tcpRatio).
			('UDP ratio: ' , aStatistics udpRatio).
			('ICMP ratio: ' , aStatistics icmpRatio).
			('ICMPv6 ratio: ' , aStatistics icmp6Ratio) }).

	self initializeLayout
]
