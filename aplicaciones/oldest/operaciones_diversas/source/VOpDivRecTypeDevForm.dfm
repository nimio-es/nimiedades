inherited OpDivRecTypeDevForm: TOpDivRecTypeDevForm
  Left = 239
  Top = 182
  Height = 502
  Caption = 'Devoluciones'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited registroLabel: TLabel
    Top = 427
  end
  inherited EntOficOrigenLabel: TLabel
    Left = 16
    Top = 116
  end
  inherited EntOficDestinoLabel: TLabel
    Left = 321
    Top = 96
  end
  inherited DivisaImporteOpLabel: TLabel
    Left = 8
    Top = 168
  end
  inherited ImporteOpEurosLabel: TLabel
    Left = 340
    Top = 176
  end
  inherited NumCtaDestinoLabel: TLabel
    Left = 420
    Top = 96
    Visible = False
  end
  inherited DestinoLabel: TLabel
    Left = 276
    Top = 116
  end
  inherited DCEntOficDestinoLabel: TLabel
    Left = 400
    Top = 116
  end
  inherited DCNumCtaDestinoLabel: TLabel
    Left = 408
    Top = 116
    Visible = False
  end
  inherited ClaveAutorizaLabel: TLabel
    Left = 344
    Top = 408
    Visible = False
  end
  inherited NombreOficinaCajaLabel: TLabel
    Left = 4
    Top = 140
  end
  inherited NombreEntidadDestinoLabel: TLabel
    Left = 271
    Top = 140
  end
  object Label1: TLabel [12]
    Left = 4
    Top = 200
    Width = 93
    Height = 26
    Alignment = taRightJustify
    Caption = 'Fecha de'#13#10'presentaci'#243'n inicial:'
  end
  object ImporteInicialLabel: TLabel [13]
    Left = 144
    Top = 240
    Width = 146
    Height = 13
    Caption = 'Importe de la operaci'#243'n inicial :'
  end
  object Label3: TLabel [14]
    Left = 8
    Top = 272
    Width = 90
    Height = 13
    Caption = 'Motivo devoluci'#243'n:'
  end
  object Label4: TLabel [15]
    Left = 48
    Top = 304
    Width = 49
    Height = 13
    Caption = 'Concepto:'
  end
  object Label5: TLabel [16]
    Left = 4
    Top = 44
    Width = 121
    Height = 13
    Caption = 'Tipo de operaci'#243'n inicial :'
  end
  object Label6: TLabel [17]
    Left = 200
    Top = 44
    Width = 160
    Height = 13
    Caption = 'Referencia de la operaci'#243'n inicial:'
  end
  object MotivoDevDescLabel: TLabel [18]
    Left = 148
    Top = 272
    Width = 3
    Height = 13
  end
  inherited buscarEntidadSpeedButton: TSpeedButton
    Left = 408
    Top = 112
  end
  inherited observacionesLabel: TLabel
    Left = 44
    Top = 332
  end
  inherited ReferencePanel: TPanel
    TabOrder = 19
  end
  inherited bottomPanel: TPanel
    Top = 440
    TabOrder = 20
  end
  inherited cobroRadioBtn: TRadioButton
    Left = 88
    Top = 76
    TabOrder = 2
  end
  inherited pagoRadioBtn: TRadioButton
    Left = 164
    Top = 76
    TabOrder = 3
  end
  inherited EntidadOrigenEdit: TEdit
    Left = 136
    Top = 112
    TabOrder = 4
  end
  inherited OficinaOrigenEdit: TMaskEdit
    Left = 176
    Top = 112
    TabOrder = 5
  end
  inherited EntidadOficinaDestinoEdit: TMaskEdit
    Left = 324
    Top = 112
    TabOrder = 6
  end
  inherited DivisaOperacionComboBox: TComboBox
    Left = 108
    Top = 172
    TabOrder = 8
  end
  inherited ImporteOrigenOperacionEdit: TRxCalcEdit
    Left = 188
    Top = 172
    TabOrder = 9
  end
  inherited ImportePrincipalOperacionEurosEdit: TEdit
    Left = 452
    Top = 172
    TabOrder = 10
  end
  object FechaPresentaEdit: TDateEdit [31]
    Left = 108
    Top = 204
    Width = 101
    Height = 21
    NumGlyphs = 2
    YearDigits = dyFour
    TabOrder = 11
    OnExit = FechaPresentaEditExit
  end
  object DevParcialCheckBox: TCheckBox [32]
    Left = 8
    Top = 240
    Width = 113
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Devoluci'#243'n parcial: '
    TabOrder = 12
    OnClick = DevParcialCheckBoxClick
    OnExit = DevParcialCheckBoxClick
  end
  object ImporteInicialEdit: TRxCalcEdit [33]
    Left = 300
    Top = 236
    Width = 129
    Height = 21
    AutoSize = False
    DecimalPlaces = 3
    DisplayFormat = ',0.###'
    FormatOnEditing = True
    NumGlyphs = 2
    PopupMenu = ConversionPopupMenu
    TabOrder = 13
    OnExit = ImporteInicialEditExit
  end
  object MotivoDevEdit: TMaskEdit [34]
    Left = 108
    Top = 268
    Width = 28
    Height = 21
    EditMask = '99;0; '
    MaxLength = 2
    TabOrder = 14
    OnExit = MotivoDevEditExit
  end
  object ConceptoEdit: TEdit [35]
    Left = 108
    Top = 300
    Width = 509
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 80
    TabOrder = 15
    OnExit = ConceptoEditExit
  end
  object TipoOperacionEdit: TMaskEdit [36]
    Left = 136
    Top = 40
    Width = 29
    Height = 21
    EditMask = '99;0; '
    MaxLength = 2
    TabOrder = 0
    OnExit = TipoOperacionEditExit
  end
  object ReferenciaInicialEdit: TMaskEdit [37]
    Left = 376
    Top = 40
    Width = 136
    Height = 21
    EditMask = '9999999999999999;0; '
    MaxLength = 16
    TabOrder = 1
    OnExit = ReferenciaInicialEditExit
  end
  inherited numCtaDestinoEdit: TMaskEdit
    Left = 420
    Top = 112
    TabOrder = 7
    Visible = False
  end
  inherited claveAutorizaEdit: TMaskEdit
    Left = 460
    Top = 404
    TabOrder = 18
    Visible = False
  end
  inherited IncluirSoporteCheckBox: TCheckBox
    Left = 12
    Top = 404
    TabOrder = 17
  end
  inherited observacionesMemo: TMemo
    Left = 108
    Top = 332
    Width = 509
    TabOrder = 16
  end
  inherited ConversionPopupMenu: TPopupMenu
    Top = 232
  end
end
