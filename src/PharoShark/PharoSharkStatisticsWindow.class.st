"
The presenter for window that opens on ""Statistics"" button click. Displays calculated statistics for given PCAP file. 
"
Class {
	#name : 'PharoSharkStatisticsWindow',
	#superclass : 'SpPresenter',
	#instVars : [
		'packetLengthHistogram',
		'flowPacketLengthHistogram',
		'flowByteLengthsHistogram',
		'packetPortsHistogram',
		'textStatisticsWindow',
		'protocolsStatisticsWindow'
	],
	#category : 'PharoShark-Present',
	#package : 'PharoShark',
	#tag : 'Present'
}

{ #category : 'gui' }
PharoSharkStatisticsWindow class >> buildBarPlotFromDictionary: aDictionary title: aTitle [

	| xValues yValues plot |
	aDictionary size <= 1 ifTrue: [
		^ SpLabelPresenter new label: aTitle , ' cannot be build' ].

	xValues := aDictionary keys asSortedCollection asArray.
	yValues := xValues collect: [ :x | aDictionary at: x ].
	plot := RSBarPlot new
		        x: xValues y: yValues;
		        title: aTitle;
		        yourself.

	^ plot asPresenter
]

{ #category : 'gui' }
PharoSharkStatisticsWindow class >> buildHistogramFromArray: anArray title: aTitle [

	anArray size <= 1 ifTrue: [
		^ SpLabelPresenter new label: aTitle , ' cannot be build' ].
	^ (RSHistogramPlot new
		   x: anArray;
		   title: aTitle;
		   yourself) asPresenter
]

{ #category : 'gui' }
PharoSharkStatisticsWindow class >> buildHistogramFromDictionary: aDictionary title: aTitle [

	aDictionary size <= 1 ifTrue: [
		^ SpLabelPresenter new label: aTitle , ' cannot be build. Only one value' ].
	^ (RSHistogramPlot new
		   x: aDictionary keys y: aDictionary values;
		   title: aTitle;
		   yourself) asPresenter
]

{ #category : 'gui' }
PharoSharkStatisticsWindow class >> buildHistogramFromDictionaryValues: aDictionary title: aTitle [

	^ self
		  buildHistogramFromArray:
		  (aDictionary keys collect: [ :k | aDictionary at: k ])
		  title: aTitle
]

{ #category : 'gui' }
PharoSharkStatisticsWindow class >> createProtocolStatisticsText: aStatistics [

	| packetsTotal flowsTotal strings |
	packetsTotal := aStatistics packetLengths size.
	flowsTotal := aStatistics flowPacketLengths size.
	strings := { 'Highest parsed packet protocols of the provided PCAP file:' }
		           asOrderedCollection.

	aStatistics packetProtocols keysAndValuesDo: [ :key :value |
			strings add: key , ' seen ' , value asString , ' times('
				, ((value asFloat roundUpTo: 0.01) / packetsTotal * 100) asString , '%)' ].

	strings add: ''.
	strings add:
		'Highest parsed flow protocols of the provided PCAP file:'.
	aStatistics flowProtocols keysAndValuesDo: [ :key :value |
			strings add: key , ' seen ' , value asString , ' times('
				, (value asFloat / flowsTotal * 100) asString , '%)' ].

	^ String cr join: strings
]

{ #category : 'gui' }
PharoSharkStatisticsWindow class >> createRatioStatisticsText: aStatistics [

	^ String cr join: {
			  'Ratios of packets containing given protocols; '.
			  ('IPv4 ratio: ' , (aStatistics ip4Ratio * 100) asString , '%').
			  ('IPv6 ratio: ' , (aStatistics ip6Ratio * 100) asString , '%').
			  ('TCP ratio: ' , (aStatistics tcpRatio * 100) asString , '%').
			  ('UDP ratio: ' , (aStatistics udpRatio * 100) asString , '%').
			  ('ICMP ratio: ' , (aStatistics icmpRatio * 100) asString , '%').
			  ('ICMPv6 ratio: ' , (aStatistics icmp6Ratio * 100) asString , '%') }
]

{ #category : 'initialization' }
PharoSharkStatisticsWindow >> initializeLayout [

	| graphLayout textWindowLayout |
	graphLayout := SpBoxLayout newVertical
		               spacing: 5;
		               add: (SpBoxLayout newHorizontal
				                spacing: 5;
				                add: packetLengthHistogram;
				                add: flowPacketLengthHistogram);
		               add: (SpBoxLayout newHorizontal
				                spacing: 5;
				                add: flowByteLengthsHistogram;
				                add: packetPortsHistogram);
		               yourself.
	textWindowLayout := SpBoxLayout newHorizontal
		                    add: textStatisticsWindow;
		                    add: protocolsStatisticsWindow;
		                    yourself.

	self layout: (SpBoxLayout newVertical
			 add: textWindowLayout;
			 add: graphLayout;
			 spacing: 10;
			 yourself)
]

{ #category : 'initialization' }
PharoSharkStatisticsWindow >> initializePresenters [

	self instantiatePresenters.
	self initializeLayout
]

{ #category : 'initialization' }
PharoSharkStatisticsWindow >> instantiatePresenters [

	packetLengthHistogram := self instantiate: SpNullPresenter.
	protocolsStatisticsWindow := self instantiate: SpNullPresenter.
	flowPacketLengthHistogram := self instantiate: SpNullPresenter.
	flowByteLengthsHistogram := self instantiate: SpNullPresenter.
	packetPortsHistogram := self instantiate: SpNullPresenter.
	textStatisticsWindow := self instantiate: SpNullPresenter
]

{ #category : 'sette' }
PharoSharkStatisticsWindow >> packetStatistics: aStatistics [

	packetLengthHistogram := self class
		                         buildHistogramFromArray:
		                         aStatistics packetLengths
		                         title: 'Packet length histogram'.
	flowPacketLengthHistogram := self class
		                             buildHistogramFromDictionaryValues:
		                             aStatistics flowPacketLengths
		                             title: 'Flow length histogram(packets)'.
	flowByteLengthsHistogram := self class
		                            buildHistogramFromDictionaryValues:
		                            aStatistics flowByteLengths
		                            title: 'Flow length histogram(bytes)'.
	packetPortsHistogram := self class
		                        buildBarPlotFromDictionary:
		                        aStatistics packetPorts
		                        title: 'Ports frequence histogram'.

	textStatisticsWindow := self instantiate: SpTextPresenter.
	textStatisticsWindow text:
		(self class createRatioStatisticsText: aStatistics).
	textStatisticsWindow editable: false.

	protocolsStatisticsWindow := self instantiate: SpTextPresenter.
	protocolsStatisticsWindow text:
		(self class createProtocolStatisticsText: aStatistics).
	protocolsStatisticsWindow editable: false.
	self initializeLayout
]
