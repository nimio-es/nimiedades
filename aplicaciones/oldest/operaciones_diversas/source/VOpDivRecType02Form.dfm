inherited OpDivRecType02Form: TOpDivRecType02Form
  Left = 229
  Top = 135
  Height = 542
  Caption = '02 - Cheques'
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  inherited registroLabel: TLabel
    Top = 467
  end
  inherited ClaveAutorizaLabel: TLabel
    Left = 388
    Top = 28
    Visible = False
  end
  object Label1: TLabel [10]
    Left = 32
    Top = 156
    Width = 98
    Height = 13
    Caption = 'Tipo de documento :'
  end
  object Label2: TLabel [11]
    Left = 168
    Top = 152
    Width = 315
    Height = 26
    Caption = 
      '( 01 - normalizado, 02 - no normalizado, 03 - solicitud de abono' +
      ' con'#13#10'garant'#237'a de  reposici'#243'n por extrav'#237'o, 04 - vales carburant' +
      'e )'
  end
  object Label3: TLabel [12]
    Left = 36
    Top = 188
    Width = 95
    Height = 13
    Caption = 'Cl'#225'usula de gastos :'
  end
  object Label4: TLabel [13]
    Left = 168
    Top = 188
    Width = 429
    Height = 13
    Caption = 
      '( 0 - sin protesto/sin declaraci'#243'n, 1 - con declaraci'#243'n equivale' +
      'nte, 2 - con protesto notarial )'
  end
  object CodigoDocumentoLabel: TLabel [14]
    Left = 20
    Top = 248
    Width = 112
    Height = 13
    Caption = 'C'#243'digo del documento :'
  end
  object ImporteOriginalLabel: TLabel [15]
    Left = 188
    Top = 312
    Width = 127
    Height = 13
    Caption = 'Importe original (en euros) :'
  end
  object ProvTomadoraLabel: TLabel [16]
    Left = 36
    Top = 344
    Width = 97
    Height = 13
    Caption = 'Provincia tomadora :'
  end
  object ProvinciaTomadoraLabel: TLabel [17]
    Left = 176
    Top = 344
    Width = 3
    Height = 13
  end
  object CodigoIdentificaLabel: TLabel [20]
    Left = 136
    Top = 212
    Width = 46
    Height = 26
    Caption = 'C'#243'digo'#13#10'Identifica.'
  end
  object CeroInterNumDocLabel: TLabel [21]
    Left = 184
    Top = 248
    Width = 6
    Height = 13
    Caption = '0'
  end
  object NumDocLabel: TLabel [22]
    Left = 196
    Top = 224
    Width = 37
    Height = 13
    Caption = 'N'#250'mero'
  end
  inherited buscarEntidadSpeedButton: TSpeedButton
    Left = 504
  end
  inherited observacionesLabel: TLabel
    Left = 76
    Top = 372
  end
  inherited ReferencePanel: TPanel
    TabOrder = 21
  end
  inherited bottomPanel: TPanel
    Top = 480
    TabOrder = 22
  end
  inherited cobroRadioBtn: TRadioButton
    Visible = False
  end
  inherited pagoRadioBtn: TRadioButton
    Visible = False
  end
  object TipoDocumentoEdit: TMaskEdit [35]
    Left = 140
    Top = 152
    Width = 21
    Height = 21
    EditMask = '99;0; '
    MaxLength = 2
    TabOrder = 9
    OnExit = TipoDocumentoEditExit
  end
  object ClausulaGastosEdit: TMaskEdit [36]
    Left = 140
    Top = 184
    Width = 17
    Height = 21
    EditMask = '9;0; '
    MaxLength = 1
    TabOrder = 10
    OnExit = ClausulaGastosEditExit
  end
  object NumDocumentoEdit: TMaskEdit [37]
    Left = 196
    Top = 244
    Width = 57
    Height = 21
    EditMask = '9999999;0; '
    MaxLength = 7
    TabOrder = 12
    OnExit = NumDocumentoEditExit
  end
  object residenteCheckBox: TCheckBox [38]
    Left = 8
    Top = 280
    Width = 177
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Residente (clave cuenta abono) :'
    TabOrder = 13
    OnClick = residenteCheckBoxClick
    OnExit = residenteCheckBoxClick
  end
  object JustificacionCobroExteriorCheckBox: TCheckBox [39]
    Left = 208
    Top = 280
    Width = 185
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Justificaci'#243'n de cobro del exterior :'
    TabOrder = 14
    OnClick = JustificacionCobroExteriorCheckBoxClick
    OnExit = JustificacionCobroExteriorCheckBoxClick
  end
  object PresentacionParcialCheckBox: TCheckBox [40]
    Left = 28
    Top = 312
    Width = 125
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Presentaci'#243'n parcial :'
    TabOrder = 15
    OnClick = PresentacionParcialCheckBoxClick
    OnExit = PresentacionParcialCheckBoxClick
  end
  object ImporteOriginalEdit: TRxCalcEdit [41]
    Left = 324
    Top = 308
    Width = 121
    Height = 21
    AutoSize = False
    DisplayFormat = ',0.00'
    FormatOnEditing = True
    NumGlyphs = 2
    PopupMenu = ConversionPopupMenu
    TabOrder = 16
    OnExit = ImporteOriginalEditExit
  end
  object ProvTomadoraEdit: TMaskEdit [42]
    Left = 140
    Top = 340
    Width = 25
    Height = 21
    EditMask = '99;0; '
    MaxLength = 2
    TabOrder = 17
    OnExit = ProvTomadoraEditExit
  end
  object CodigoIdentificaEdit: TMaskEdit [43]
    Left = 136
    Top = 244
    Width = 44
    Height = 21
    EditMask = '9999;0; '
    MaxLength = 4
    TabOrder = 11
    OnExit = CodigoIdentificaEditExit
  end
  inherited claveAutorizaEdit: TMaskEdit
    Left = 504
    Top = 24
    TabOrder = 20
    Visible = False
  end
  inherited IncluirSoporteCheckBox: TCheckBox
    Left = 444
    Top = 436
    TabOrder = 19
  end
  inherited observacionesMemo: TMemo
    Top = 372
    Height = 53
    TabOrder = 18
  end
end
