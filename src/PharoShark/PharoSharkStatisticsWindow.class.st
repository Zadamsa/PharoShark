Class {
	#name : 'PharoSharkStatisticsWindow',
	#superclass : 'SpPresenter',
	#instVars : [
		'packetLengthHistogram',
		'flowPacketLengthHistogram',
		'flowByteLengthsHistogram',
		'packetProtocolsHistogram',
		'flowProtocolsHistogram',
		'textStatisticsWindow'
	],
	#category : 'PharoShark-Present',
	#package : 'PharoShark',
	#tag : 'Present'
}

{ #category : 'as yet unclassified' }
PharoSharkStatisticsWindow class >> buildBarPlotFromDictionary: aDictionary title: aTitle [

	| xValues plot labels |
	labels := aDictionary keys asArray.
	xValues := (1 to: aDictionary size) asArray.
	plot := RSBarPlot new
		        x: xValues y: aDictionary values;
		        title: aTitle;
		        yourself.

	1 to: xValues size do: [ :i |
			| textMorph |
			textMorph := TextMorph new contents: (labels keys at: i).
			"позиция под графиком; координаты нужно подобрать под твой график"
			textMorph position: 50 * i @ 10.
			plot addMorph: textMorph ].


	^ plot asPresenter
]

{ #category : 'as yet unclassified' }
PharoSharkStatisticsWindow class >> buildHistogramFromArray: anArray title: aTitle [

	anArray size <= 1 ifTrue: [
		^ SpLabelPresenter new label: aTitle , ' cannot be build' ].
	^ (RSHistogramPlot new
		   x: anArray;
		   title: aTitle;
		   yourself) asPresenter
]

{ #category : 'as yet unclassified' }
PharoSharkStatisticsWindow class >> buildHistogramFromDictionaryValues: aDictionary title: aTitle [

	^ self
		  buildHistogramFromArray:
		  (aDictionary keys collect: [ :k | aDictionary at: k ])
		  title: aTitle
]

{ #category : 'initialization' }
PharoSharkStatisticsWindow >> initializeLayout [

	| graphLayout |
	graphLayout := SpBoxLayout newVertical
		               spacing: 5;
		               add: (SpBoxLayout newHorizontal
				                spacing: 5;
				                add: packetLengthHistogram;
				                add: packetLengthHistogram;
				                add: flowPacketLengthHistogram);
		               add: (SpBoxLayout newHorizontal
				                spacing: 5;
				                add: flowByteLengthsHistogram;
				                add: packetProtocolsHistogram;
				                add: flowProtocolsHistogram);
		               yourself.

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

	packetLengthHistogram := self instantiate: SpNullPresenter.
	flowPacketLengthHistogram := self instantiate: SpNullPresenter.
	flowByteLengthsHistogram := self instantiate: SpNullPresenter.
	packetProtocolsHistogram := self instantiate: SpNullPresenter.
	flowProtocolsHistogram := self instantiate: SpNullPresenter.
	textStatisticsWindow := self instantiate: SpNullPresenter
]

{ #category : 'as yet unclassified' }
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
	packetProtocolsHistogram := self class
		                            buildBarPlotFromDictionary:
		                            aStatistics packetProtocols
		                            title: 'Packet protocols'.
	"flowProtocolsHistogram := (RSHistogramPlot new
		                           x: aStatistics packetLengths;
		                           title: 'Packet length histogram';
		                           yourself) asPresenter."


	textStatisticsWindow := self instantiate: SpTextPresenter.
	textStatisticsWindow text: (String cr join: {
				 ('IPv4 ratio: ' , aStatistics ip4Ratio asString).
				 ('IPv6 ratio: ' , aStatistics ip6Ratio asString).
				 ('TCP ratio: ' , aStatistics tcpRatio asString).
				 ('UDP ratio: ' , aStatistics udpRatio asString).
				 ('ICMP ratio: ' , aStatistics icmpRatio asString).
				 ('ICMPv6 ratio: ' , aStatistics icmp6Ratio asString) }).

	self initializeLayout
]
