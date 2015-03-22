inherited OpDivRecType07Form: TOpDivRecType07Form
  Left = 181
  Top = 164
  Width = 648
  Height = 573
  Caption = '07 - Pagos en notar'#237'a'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited registroLabel: TLabel
    Top = 498
    Width = 640
  end
  object vencimientoLabel: TLabel [1]
    Left = 206
    Top = 156
    Width = 64
    Height = 13
    Caption = 'Vencimiento :'
  end
  object Label6: TLabel [2]
    Left = 15
    Top = 184
    Width = 141
    Height = 26
    Caption = 
      'Identificaci'#243'n del subsistema'#13#10'de presentaci'#243'n inicial .........' +
      ' :'
  end
  object Label7: TLabel [3]
    Left = 212
    Top = 192
    Width = 382
    Height = 13
    Caption = 
      '( "0" = Desconocido; "1"= S.N.C.E. 004; "2"= S.N.C.E. 007; "3"= ' +
      'S.N.C.E. 008 )'
  end
  object Label8: TLabel [4]
    Left = 28
    Top = 228
    Width = 127
    Height = 13
    Caption = 'Ref. inicial del subsistema :'
  end
  object Label9: TLabel [5]
    Left = 56
    Top = 376
    Width = 101
    Height = 26
    Caption = 'Figura de la entidad'#13#10'presentadora            :'
  end
  object Label4: TLabel [6]
    Left = 212
    Top = 388
    Width = 205
    Height = 13
    Caption = '( "1"= Tercera entidad; "2"= Domiciliataria )'
  end
  object nominalInicialLabel: TLabel [7]
    Left = 256
    Top = 252
    Width = 168
    Height = 13
    Caption = 'Nominal presentaci'#243'n inical (Euros):'
  end
  object Label12: TLabel [8]
    Left = 44
    Top = 284
    Width = 113
    Height = 13
    Caption = 'Importe pagado (Euros):'
  end
  object Label13: TLabel [9]
    Left = 38
    Top = 316
    Width = 120
    Height = 13
    Caption = 'Fecha devoluci'#243'n inicial :'
  end
  object Label15: TLabel [10]
    Left = 296
    Top = 316
    Width = 130
    Height = 13
    Caption = 'Devoluci'#243'n de comisiones :'
  end
  object Label16: TLabel [11]
    Left = 28
    Top = 348
    Width = 129
    Height = 13
    Caption = 'Concepto complementario :'
  end
  inherited DivisaImporteOpLabel: TLabel
    Top = 112
  end
  inherited ImporteOpEurosLabel: TLabel
    Top = 120
  end
  inherited ClaveAutorizaLabel: TLabel
    Left = 32
    Top = 28
    Visible = False
  end
  inherited buscarEntidadSpeedButton: TSpeedButton
    Left = 504
  end
  inherited observacionesLabel: TLabel
    Left = 104
    Top = 412
  end
  inherited ReferencePanel: TPanel
    Width = 640
    TabOrder = 22
    inherited OpNatPanel: TPanel
      Width = 158
    end
    inherited DateCreationPanel: TPanel
      Left = 479
    end
  end
  inherited bottomPanel: TPanel
    Top = 511
    Width = 640
    TabOrder = 23
    inherited AceptarButton: TButton
      Left = 483
    end
    inherited CancelarButton: TButton
      Left = 563
    end
  end
  inherited cobroRadioBtn: TRadioButton
    TabOrder = 20
    Visible = False
  end
  inherited pagoRadioBtn: TRadioButton
    TabOrder = 21
    Visible = False
  end
  inherited EntidadOrigenEdit: TEdit
    TabOrder = 0
  end
  inherited OficinaOrigenEdit: TMaskEdit
    TabOrder = 1
  end
  inherited EntidadOficinaDestinoEdit: TMaskEdit
    TabOrder = 2
  end
  inherited DivisaOperacionComboBox: TComboBox
    Top = 116
    TabOrder = 4
  end
  inherited ImporteOrigenOperacionEdit: TRxCalcEdit
    Top = 116
    DecimalPlaces = 2
    TabOrder = 5
  end
  inherited ImportePrincipalOperacionEurosEdit: TEdit
    Top = 116
    TabOrder = 6
  end
  object IdSubsistemaPresentacionEdit: TMaskEdit [35]
    Left = 168
    Top = 188
    Width = 21
    Height = 21
    EditMask = '9;0; '
    MaxLength = 1
    TabOrder = 9
    OnExit = IdSubsistemaPresentacionEditExit
  end
  object RefInicSubsEdit: TMaskEdit [36]
    Left = 168
    Top = 220
    Width = 109
    Height = 21
    EditMask = '9999999999999999;0; '
    MaxLength = 16
    TabOrder = 10
    Text = '0000000000000000'
    OnExit = RefInicSubsEditExit
  end
  object FigEntidadPresentaEdit: TMaskEdit [37]
    Left = 168
    Top = 384
    Width = 21
    Height = 21
    EditMask = '9;0; '
    MaxLength = 1
    TabOrder = 17
    OnExit = FigEntidadPresentaEditExit
  end
  object pagoParcialCheckBox: TCheckBox [38]
    Left = 88
    Top = 252
    Width = 93
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Pago Parcial :'
    TabOrder = 11
    OnClick = pagoParcialCheckBoxClick
    OnExit = pagoParcialCheckBoxClick
  end
  object NominalInicialEdit: TRxCalcEdit [39]
    Left = 436
    Top = 248
    Width = 121
    Height = 21
    AutoSize = False
    FormatOnEditing = True
    NumGlyphs = 2
    PopupMenu = ConversionPopupMenu
    TabOrder = 12
    OnExit = NominalInicialEditExit
  end
  object ImportePagadoEdit: TRxCalcEdit [40]
    Left = 168
    Top = 280
    Width = 121
    Height = 21
    AutoSize = False
    FormatOnEditing = True
    NumGlyphs = 2
    PopupMenu = ConversionPopupMenu
    TabOrder = 13
    OnExit = ImportePagadoEditExit
  end
  object vencimientoEdit: TDateEdit [41]
    Left = 284
    Top = 152
    Width = 101
    Height = 21
    CheckOnExit = True
    NumGlyphs = 2
    YearDigits = dyFour
    TabOrder = 8
    OnExit = vencimientoEditExit
  end
  object devolucionEdit: TDateEdit [42]
    Left = 168
    Top = 312
    Width = 101
    Height = 21
    CheckOnExit = True
    NumGlyphs = 2
    YearDigits = dyFour
    TabOrder = 14
    OnExit = devolucionEditExit
  end
  object ComisionDevolucionEdit: TRxCalcEdit [43]
    Left = 436
    Top = 312
    Width = 121
    Height = 21
    AutoSize = False
    FormatOnEditing = True
    NumGlyphs = 2
    PopupMenu = ConversionPopupMenu
    TabOrder = 15
    OnExit = ComisionDevolucionEditExit
  end
  object conceptoComplementarioEdit: TEdit [44]
    Left = 168
    Top = 344
    Width = 449
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 80
    TabOrder = 16
    OnExit = conceptoComplementarioEditExit
  end
  inherited numCtaDestinoEdit: TMaskEdit
    TabOrder = 3
  end
  inherited claveAutorizaEdit: TMaskEdit
    Left = 148
    Top = 24
    TabOrder = 24
    Visible = False
  end
  object vencimientoALaVistaCheckBox: TCheckBox [47]
    Left = 48
    Top = 156
    Width = 133
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Vencimiento a la vista :'
    TabOrder = 7
    OnClick = vencimientoALaVistaCheckBoxClick
    OnExit = vencimientoALaVistaCheckBoxClick
  end
  inherited IncluirSoporteCheckBox: TCheckBox
    Left = 24
    Top = 472
    TabOrder = 19
  end
  inherited observacionesMemo: TMemo
    Left = 168
    Top = 412
    Width = 449
    Height = 53
    TabOrder = 18
  end
end
