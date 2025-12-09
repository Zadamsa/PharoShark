Class {
	#name : 'PharoSharkLabelNode',
	#superclass : 'Object',
	#instVars : [
		'label'
	],
	#category : 'PharoShark-Present',
	#package : 'PharoShark',
	#tag : 'Present'
}

{ #category : 'converting' }
PharoSharkLabelNode >> asPresenterOn: aBuilder [

	^ SpLabelPresenter new
		  label: label;
		  textStyle: (SpTextStyle new
				   fontName: 'Arial';
				   pointSize: 55;
				   bold: true;
				   yourself);
			addStyle: 'font-size: 30px;';
		  yourself
]

{ #category : 'accessing' }
PharoSharkLabelNode >> children [ 
	^ {  }
]

{ #category : 'displaying' }
PharoSharkLabelNode >> displayString [
	^ label 
]

{ #category : 'accessing' }
PharoSharkLabelNode >> label: aLabel [
	label := aLabel 
]

{ #category : 'accessing' }
PharoSharkLabelNode >> textStyle [
    ^ SpTextStyle new
        fontName: 'Arial';
        pointSize: 132;
        yourself.

]
