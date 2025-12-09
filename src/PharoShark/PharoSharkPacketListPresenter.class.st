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

{ #category : 'initialization' }
PharoSharkPacketListPresenter >> connectPresenters [

	packetsList
		whenSelectedDo: [ :selectedPacket | ];
		whenActivatedDo: [ :selectedPacket |
				| x indexes |
				indexes := (1 to: packetsList items size) select: [ :i |
						           (packetsList items at: i) flowKey
						           = selectedPacket selectedItem flowKey ].
				inspectPacketSubwindow inspectedPacket: selectedPacket selectedItem.
				UIManager default inform: 'x = ' , indexes printString.
				
				packetsList selectIndexes: indexes .
				packetsList refresh ]
]

{ #category : 'initialization' }
PharoSharkPacketListPresenter >> initializeLayout [

	self layout: (SpBoxLayout newVertical
			 add: packetsList;
			 add: inspectPacketSubwindow ;
			 spacing: 10;
			 yourself)
]

{ #category : 'initialization' }
PharoSharkPacketListPresenter >> initializePresenters [

	self instantiatePresenters.
	self initializeLayout
]

{ #category : 'as yet unclassified' }
PharoSharkPacketListPresenter >> instantiatePresenters [

	packetsList := self instantiate: SpTablePresenter new.
	packetsList beMultipleSelection.
	packetsList activateOnSingleClick .
	packetsList columns: {
			(SpStringTableColumn
				 title: 'No'
				 evaluated: [ :packet | packet relativeIndex ]).
			(SpStringTableColumn
				 title: 'FlowKey'
				 evaluated: [ :packet | packet flowKey ]).

			(SpStringTableColumn
				 title: 'Relative time (us)'
				 evaluated: [ :packet | packet relativeTs ]).

			(SpStringTableColumn
				 title: 'Source'
				 evaluated: [ :packet | packet srcIP ]).

			(SpStringTableColumn
				 title: 'Destination'
				 evaluated: [ :packet | packet dstIP ]).

			(SpStringTableColumn
				 title: 'Protocol'
				 evaluated: [ :packet | packet highestParsedProtocol shortName ]).

			(SpStringTableColumn
				 title: 'Length'
				 evaluated: [ :packet | packet realLength ]) }.
				
		inspectPacketSubwindow := self instantiate: PharoSharkInspectPacketPresenter .
]

{ #category : 'accessing' }
PharoSharkPacketListPresenter >> packets: aPackets [
	packetsList items: aPackets. 
	packetsList selectIndex: 1.
]
