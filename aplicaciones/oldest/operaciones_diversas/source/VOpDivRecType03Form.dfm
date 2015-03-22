inherited OpDivRecType03Form: TOpDivRecType03Form
  Left = 128
  Top = 185
  Width = 750
  Height = 580
  Caption = 
    '03 - Regularizaci'#243'n operaciones sistema intercambio con car'#225'cter' +
    ' documental'
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  inherited registroLabel: TLabel
    Top = 505
    Width = 742
  end
  inherited EntOficOrigenLabel: TLabel
    Top = 72
  end
  inherited EntOficDestinoLabel: TLabel
    Top = 52
  end
  inherited DivisaImporteOpLabel: TLabel
    Top = 124
  end
  inherited ImporteOpEurosLabel: TLabel
    Top = 132
  end
  inherited NumCtaDestinoLabel: TLabel
    Top = 52
  end
  inherited DestinoLabel: TLabel
    Top = 72
  end
  inherited DCEntOficDestinoLabel: TLabel
    Top = 72
  end
  inherited DCNumCtaDestinoLabel: TLabel
    Top = 72
  end
  inherited ClaveAutorizaLabel: TLabel
    Left = 28
    Top = 336
  end
  object Label1: TLabel [10]
    Left = 12
    Top = 168
    Width = 122
    Height = 13
    Caption = 'Indicador del subsistema :'
  end
  object Label2: TLabel [11]
    Left = 172
    Top = 168
    Width = 474
    Height = 13
    Caption = 
      '( 3 - Transferencias, 4 - Cheques, 5 - Adeudos, 6 - Carburantes ' +
      '/ Viaje, 7 - Efectos, 8 - Op. Diversas )'
  end
  object RefInicialLabel: TLabel [12]
    Left = 48
    Top = 200
    Width = 87
    Height = 13
    Caption = 'Referencia inicial :'
  end
  object refAdeudoLabel: TLabel [13]
    Left = 512
    Top = 200
    Width = 90
    Height = 13
    Caption = 'Referencia recibo :'
  end
  object NifSufijoLabel: TLabel [14]
    Left = 280
    Top = 200
    Width = 117
    Height = 13
    Caption = 'N.I.F / Sufijo ordenante :'
  end
  object numChequeLabel: TLabel [15]
    Left = 60
    Top = 228
    Width = 73
    Height = 26
    Caption = 'N'#250'm. Cheque /'#13#10'Pagar'#233' CC :'
  end
  object Label7: TLabel [16]
    Left = 268
    Top = 228
    Width = 86
    Height = 26
    Caption = 'Fecha de '#13#10'intercambio inicial:'
  end
  inherited NombreOficinaCajaLabel: TLabel
    Left = 28
    Top = 96
    Width = 233
  end
  inherited NombreEntidadDestinoLabel: TLabel
    Top = 96
  end
  object Label8: TLabel [19]
    Left = 36
    Top = 268
    Width = 99
    Height = 13
    Caption = 'Concepto operaci'#243'n:'
  end
  object Label9: TLabel [20]
    Left = 176
    Top = 268
    Width = 556
    Height = 26
    Caption = 
      '( 1 - Rechazo de devoluci'#243'n, 2- Devoluci'#243'n inicial (caso S.N.C.E' +
      '. 006), 3 - Devoluci'#243'n fuera de plazo y extraordinarias'#13#10'  4 - R' +
      'eclamaci'#243'n de la devoluci'#243'n, 5 - Regularizaci'#243'n mayores / menore' +
      's importes )'
  end
  object ConceptoComplementaLabel: TLabel [21]
    Left = 8
    Top = 304
    Width = 126
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Concepto complementario:'
  end
  object NominalInicialLabel: TLabel [22]
    Left = 60
    Top = 368
    Width = 73
    Height = 13
    Caption = 'Nominal inicial :'
  end
  object ComisionesDevolucionLabel: TLabel [23]
    Left = 280
    Top = 368
    Width = 166
    Height = 13
    Caption = 'Comisiones iniciales de devoluci'#243'n:'
  end
  object ComisionesReclamacionLabel: TLabel [24]
    Left = 312
    Top = 396
    Width = 131
    Height = 13
    Caption = 'Comisiones de reclamaci'#243'n:'
  end
  inherited buscarEntidadSpeedButton: TSpeedButton
    Left = 504
    Top = 68
  end
  inherited observacionesLabel: TLabel
    Left = 76
    Top = 424
  end
  inherited ReferencePanel: TPanel
    Width = 742
    TabOrder = 24
    inherited OpNatPanel: TPanel
      Width = 260
    end
    inherited DateCreationPanel: TPanel
      Left = 581
    end
  end
  inherited bottomPanel: TPanel
    Top = 518
    Width = 742
    TabOrder = 25
    DesignSize = (
      742
      28)
    inherited AceptarButton: TButton
      Left = 585
    end
    inherited CancelarButton: TButton
      Left = 665
    end
  end
  inherited EntidadOrigenEdit: TEdit
    Top = 68
  end
  inherited OficinaOrigenEdit: TMaskEdit
    Top = 68
  end
  inherited EntidadOficinaDestinoEdit: TMaskEdit
    Top = 68
  end
  inherited DivisaOperacionComboBox: TComboBox
    Top = 128
  end
  inherited ImporteOrigenOperacionEdit: TRxCalcEdit
    Top = 128
    DecimalPlaces = 2
    DisplayFormat = ',0.00'
  end
  inherited ImportePrincipalOperacionEurosEdit: TEdit
    Top = 128
  end
  object IndicadorSubsistemaEdit: TMaskEdit [37]
    Left = 144
    Top = 164
    Width = 17
    Height = 21
    EditMask = '0;0; '
    MaxLength = 1
    TabOrder = 9
    OnChange = IndicadorSubsistemaEditChange
    OnExit = IndicadorSubsistemaEditExit
  end
  object RefInicialEdit: TMaskEdit [38]
    Left = 144
    Top = 196
    Width = 105
    Height = 21
    EditMask = '9999999999999999;0; '
    MaxLength = 16
    TabOrder = 10
    Text = '0000000000000000'
    OnExit = RefInicialEditExit
  end
  object refAdeudoEdit: TEdit [39]
    Left = 608
    Top = 196
    Width = 85
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 12
    TabOrder = 12
    OnExit = refAdeudoEditExit
  end
  object nifOrdenanteEdit: TEdit [40]
    Left = 408
    Top = 196
    Width = 85
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 12
    TabOrder = 11
    OnExit = nifOrdenanteEditExit
  end
  object numChequeEdit: TMaskEdit [41]
    Left = 144
    Top = 232
    Width = 61
    Height = 21
    EditMask = '99999999;0; '
    MaxLength = 8
    TabOrder = 13
    Text = '00000000'
    OnExit = numChequeEditExit
  end
  object fechaIntercambioEdit: TDateEdit [42]
    Left = 364
    Top = 232
    Width = 97
    Height = 21
    CheckOnExit = True
    NumGlyphs = 2
    YearDigits = dyFour
    TabOrder = 14
    OnExit = fechaIntercambioEditExit
  end
  object conceptoOperacionEdit: TMaskEdit [43]
    Left = 144
    Top = 264
    Width = 21
    Height = 21
    EditMask = '0;0; '
    MaxLength = 1
    TabOrder = 15
    OnExit = conceptoOperacionEditExit
  end
  object conceptoComplementarioEdit: TEdit [44]
    Left = 144
    Top = 300
    Width = 589
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 80
    TabOrder = 16
    OnExit = conceptoComplementarioEditExit
  end
  object nominaInicialEdit: TRxCalcEdit [45]
    Left = 144
    Top = 364
    Width = 117
    Height = 21
    AutoSize = False
    DisplayFormat = ',0.00'
    FormatOnEditing = True
    NumGlyphs = 2
    PopupMenu = ConversionPopupMenu
    TabOrder = 18
    OnExit = nominaInicialEditExit
  end
  object ComisionesDevolucionEdit: TRxCalcEdit [46]
    Left = 456
    Top = 364
    Width = 117
    Height = 21
    AutoSize = False
    DisplayFormat = ',0.00'
    FormatOnEditing = True
    NumGlyphs = 2
    PopupMenu = ConversionPopupMenu
    TabOrder = 19
    OnExit = ComisionesDevolucionEditExit
  end
  object ComisionesReclamacionEdit: TRxCalcEdit [47]
    Left = 456
    Top = 392
    Width = 117
    Height = 21
    AutoSize = False
    DisplayFormat = ',0.00'
    FormatOnEditing = True
    NumGlyphs = 2
    PopupMenu = ConversionPopupMenu
    TabOrder = 20
    OnExit = ComisionesReclamacionEditExit
  end
  object Sumar2ImporteOpButton: TButton [48]
    Left = 588
    Top = 392
    Width = 109
    Height = 21
    Caption = 'Calcular importe...'
    TabOrder = 23
    TabStop = False
    OnClick = Sumar2ImporteOpButtonClick
  end
  inherited numCtaDestinoEdit: TMaskEdit
    Top = 68
  end
  inherited claveAutorizaEdit: TMaskEdit
    Left = 144
    Top = 332
    TabOrder = 17
  end
  inherited IncluirSoporteCheckBox: TCheckBox
    Left = 136
    Top = 480
    TabOrder = 22
  end
  inherited observacionesMemo: TMemo
    Left = 144
    Top = 424
    Width = 589
    Height = 49
    TabOrder = 21
  end
  inherited ConversionPopupMenu: TPopupMenu
    Left = 704
    Top = 344
  end
end
