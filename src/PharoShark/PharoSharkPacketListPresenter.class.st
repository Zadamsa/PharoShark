"
Presenter for packet list window. Shows packet list with some key info from each packet. Allows to sort packet by all key fields. Selects all packets that belong to same flow on click.
"
Class {
	#name : 'PharoSharkPacketListPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'parseFileCallaback',
		'packets',
		'packetsList',
		'inspectPacketSubwindow'
	],
	#category : 'PharoShark-Present',
	#package : 'PharoShark',
	#tag : 'Present'
}

{ #category : 'gui' }
PharoSharkPacketListPresenter class >> makeColumns [

	| idColumn flowKeyColumn relativeTimeColumn sourceColumn destinationColumn protocolColumn lengthColumn |
	idColumn := SpStringTableColumn
		            title: 'No'
		            evaluated: [ :packet | packet relativeIndex ].
	idColumn sortFunction: [ :a :b | a relativeIndex - b relativeIndex ].

	flowKeyColumn := SpStringTableColumn
		                 title: 'FlowKey'
		                 evaluated: [ :packet | packet flowKey ].

	relativeTimeColumn := SpStringTableColumn
		                      title: 'Relative time (us)'
		                      evaluated: [ :packet | packet relativeTs ].
	relativeTimeColumn sortFunction: [ :a :b |
		a relativeTs - b relativeTs ].

	sourceColumn := SpStringTableColumn
		                title: 'Source'
		                evaluated: [ :packet | packet srcIP ].
	sourceColumn sortFunction: [ :a :b | a srcIP compare: b srcIP ].

	destinationColumn := SpStringTableColumn
		                     title: 'Destination'
		                     evaluated: [ :packet | packet dstIP ].
	destinationColumn sortFunction: [ :a :b | a dstIP compare: b dstIP ].

	protocolColumn := SpStringTableColumn
		                  title: 'Protocol'
		                  evaluated: [ :packet |
		                  packet highestParsedProtocol shortName ].
	protocolColumn sortFunction: [ :a :b |
			a highestParsedProtocol shortName compare:
				b highestParsedProtocol shortName ].

	lengthColumn := SpStringTableColumn
		                title: 'Length'
		                evaluated: [ :packet | packet realLength ].
	lengthColumn sortFunction: [ :a :b | a realLength - b realLength ].

	^ {
		  idColumn.
		  relativeTimeColumn.
		  sourceColumn.
		  destinationColumn.
		  protocolColumn.
		  lengthColumn }
]

{ #category : 'initialization' }
PharoSharkPacketListPresenter >> connectPresenters [

	packetsList
		whenSelectedDo: [ :selectedPacket |  ];
		whenActivatedDo: [ :selectedPacket |
				| indexes |
				indexes := (1 to: packetsList items size) select: [ :i |
							           (packetsList adapter elementAt: i) flowKey
							           = selectedPacket selectedItem flowKey and:
									           selectedPacket selectedItem flowKey ~= 0 ].
				inspectPacketSubwindow inspectedPacket:
						selectedPacket selectedItem.
				packetsList selectIndexes: indexes.
				packetsList refresh ]
]

{ #category : 'initialization' }
PharoSharkPacketListPresenter >> initializeLayout [

	self layout: (SpBoxLayout newVertical
			 add: packetsList;
			 add: inspectPacketSubwindow;
			 spacing: 10;
			 yourself)
]

{ #category : 'initialization' }
PharoSharkPacketListPresenter >> initializePresenters [

	self instantiatePresenters.
	self initializeLayout
]

{ #category : 'initialization' }
PharoSharkPacketListPresenter >> instantiatePresenters [

	packetsList := self instantiate: SpTablePresenter new.
	packetsList beMultipleSelection.
	packetsList activateOnSingleClick.
	packetsList columns: self class makeColumns.

	inspectPacketSubwindow := self instantiate:
		                          PharoSharkInspectPacketPresenter
]

{ #category : 'accessing' }
PharoSharkPacketListPresenter >> packets: aPackets [

	packetsList items: aPackets
]
