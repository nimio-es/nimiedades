inherited OpDivRecType10Form: TOpDivRecType10Form
  Left = 247
  Top = 251
  Height = 462
  Caption = '10 - Reembolsos'
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  inherited registroLabel: TLabel
    Top = 387
  end
  inherited ClaveAutorizaLabel: TLabel
    Left = 384
    Top = 28
    Visible = False
  end
  object Label1: TLabel [10]
    Left = 8
    Top = 148
    Width = 124
    Height = 13
    Caption = 'Ordenante del reembolso :'
  end
  object DescReembolsoLabel: TLabel [11]
    Left = 180
    Top = 148
    Width = 3
    Height = 13
    Visible = False
  end
  object Label2: TLabel [12]
    Left = 12
    Top = 196
    Width = 120
    Height = 13
    Caption = 'Concepto del reembolso :'
  end
  object ConceptoDescLabel: TLabel [13]
    Left = 175
    Top = 196
    Width = 3
    Height = 13
  end
  object Label3: TLabel [14]
    Left = 0
    Top = 224
    Width = 129
    Height = 13
    Caption = 'Concepto complementario :'
  end
  object Label4: TLabel [15]
    Left = 28
    Top = 252
    Width = 101
    Height = 13
    Caption = 'Indicador residencia :'
  end
  object Label5: TLabel [16]
    Left = 168
    Top = 252
    Width = 161
    Height = 13
    Caption = '( 1 - Residente / 2 - No residente )'
  end
  object Label6: TLabel [19]
    Left = 176
    Top = 148
    Width = 359
    Height = 39
    Caption = 
      '01 - "SERMEPA",    02 - "4B",    03 - "RED 6000", '#13#10'04 - "VISA I' +
      'NTERNACIONAL",    05 - "MASTERCARD INTERNACIONAL",'#13#10'06 - "Otros ' +
      'Ordenantes"'
  end
  inherited buscarEntidadSpeedButton: TSpeedButton
    Left = 504
  end
  inherited observacionesLabel: TLabel
    Left = 76
    Top = 284
  end
  inherited ReferencePanel: TPanel
    TabOrder = 15
  end
  inherited bottomPanel: TPanel
    Top = 400
    TabOrder = 16
  end
  inherited cobroRadioBtn: TRadioButton
    Top = 32
  end
  inherited pagoRadioBtn: TRadioButton
    Top = 32
  end
  object OrdenanteReembolsoEdit: TMaskEdit [32]
    Left = 140
    Top = 144
    Width = 25
    Height = 21
    EditMask = '99;0; '
    MaxLength = 2
    TabOrder = 9
    OnExit = OrdenanteReembolsoEditExit
  end
  object ConceptoReembolsoEdit: TMaskEdit [33]
    Left = 140
    Top = 192
    Width = 25
    Height = 21
    EditMask = '99;0; '
    MaxLength = 2
    TabOrder = 10
    OnExit = ConceptoReembolsoEditExit
  end
  object conceptoComplementaEdit: TEdit [34]
    Left = 140
    Top = 220
    Width = 461
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 80
    TabOrder = 11
    OnExit = conceptoComplementaEditExit
  end
  object IndicadorResidenciaEdit: TMaskEdit [35]
    Left = 140
    Top = 248
    Width = 17
    Height = 21
    EditMask = '9;0; '
    MaxLength = 1
    TabOrder = 12
    OnExit = IndicadorResidenciaEditExit
  end
  inherited claveAutorizaEdit: TMaskEdit
    Left = 500
    Top = 24
    TabOrder = 17
    Visible = False
  end
  inherited IncluirSoporteCheckBox: TCheckBox
    Top = 360
    TabOrder = 14
  end
  inherited observacionesMemo: TMemo
    Top = 284
    TabOrder = 13
  end
  inherited ConversionPopupMenu: TPopupMenu
    Top = 216
  end
end
