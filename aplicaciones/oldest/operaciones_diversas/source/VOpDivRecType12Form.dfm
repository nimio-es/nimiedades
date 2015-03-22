inherited OpDivRecType12Form: TOpDivRecType12Form
  Left = 260
  Top = 191
  Width = 638
  Height = 568
  Caption = '12 - Comisiones'
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  inherited registroLabel: TLabel
    Top = 493
    Width = 630
  end
  object numTarjetaLabel: TLabel [1]
    Left = 420
    Top = 144
    Width = 90
    Height = 13
    Caption = 'N'#250'mero de tarjeta :'
  end
  object Label4: TLabel [2]
    Left = 420
    Top = 224
    Width = 85
    Height = 13
    Caption = 'Importe comisi'#243'n :'
  end
  object ImporteImpuestoLabel: TLabel [3]
    Left = 232
    Top = 316
    Width = 86
    Height = 13
    Caption = 'Importe impuesto :'
  end
  object ImporteRecompensaLabel: TLabel [4]
    Left = 420
    Top = 316
    Width = 102
    Height = 13
    Caption = 'Importe recompensa :'
  end
  object Label8: TLabel [5]
    Left = 28
    Top = 368
    Width = 129
    Height = 13
    Caption = 'Concepto complementario :'
  end
  inherited NumCtaDestinoLabel: TLabel
    Visible = False
  end
  inherited DCNumCtaDestinoLabel: TLabel
    Visible = False
  end
  inherited ClaveAutorizaLabel: TLabel
    Left = 376
    Top = 28
    Visible = False
  end
  inherited buscarEntidadSpeedButton: TSpeedButton
    Left = 400
  end
  inherited observacionesLabel: TLabel
    Left = 28
    Top = 412
  end
  inherited ReferencePanel: TPanel
    Width = 630
    TabOrder = 18
    inherited OpNatPanel: TPanel
      Width = 148
    end
    inherited DateCreationPanel: TPanel
      Left = 469
    end
  end
  inherited bottomPanel: TPanel
    Top = 506
    Width = 630
    TabOrder = 19
    inherited AceptarButton: TButton
      Left = 473
    end
    inherited CancelarButton: TButton
      Left = 553
    end
  end
  inherited cobroRadioBtn: TRadioButton
    Visible = False
  end
  inherited pagoRadioBtn: TRadioButton
    Visible = False
  end
  object ConceptoRadioGroup: TRadioGroup [29]
    Left = 28
    Top = 148
    Width = 365
    Height = 121
    Caption = 'Concepto'
    ItemIndex = 0
    Items.Strings = (
      'Recuperaci'#243'n de tarjeta en Entidad de Cr'#233'dito'
      'Recuperaci'#243'n de tarjeta en Comercio'
      
        'Comisiones compensatorias por canalizaci'#243'n indebida de documento' +
        's'
      'Solicitud de truncados'
      'Avales entre Entidades'
      'Otras comisiones')
    TabOrder = 9
    OnClick = ConceptoRadioGroupClick
    OnExit = ConceptoRadioGroupClick
  end
  object numTarjetaEdit: TMaskEdit [30]
    Left = 420
    Top = 160
    Width = 109
    Height = 21
    EditMask = '9999999999999999;0; '
    MaxLength = 16
    TabOrder = 10
    OnExit = numTarjetaEditExit
  end
  object ImporteComisionEdit: TRxCalcEdit [31]
    Left = 420
    Top = 240
    Width = 109
    Height = 21
    AutoSize = False
    DecimalPlaces = 3
    DisplayFormat = ',0.###'
    FormatOnEditing = True
    NumGlyphs = 2
    PopupMenu = ConversionPopupMenu
    TabOrder = 11
    OnExit = ImporteComisionEditExit
  end
  object TipoImpuestoRadioGroup: TRadioGroup [32]
    Left = 28
    Top = 284
    Width = 185
    Height = 69
    Caption = 'Tipo impuesto'
    ItemIndex = 1
    Items.Strings = (
      'I.V.A.'
      'I.G.I.C.'
      'I.P.S.I.C.C.M.')
    TabOrder = 12
    OnClick = TipoImpuestoRadioGroupClick
    OnExit = TipoImpuestoRadioGroupClick
  end
  object importeImpuestoEdit: TRxCalcEdit [33]
    Left = 232
    Top = 332
    Width = 109
    Height = 21
    AutoSize = False
    DecimalPlaces = 3
    DisplayFormat = ',0.###'
    FormatOnEditing = True
    NumGlyphs = 2
    PopupMenu = ConversionPopupMenu
    TabOrder = 13
    OnExit = importeImpuestoEditExit
  end
  object ImporteRecompensaEdit: TRxCalcEdit [34]
    Left = 420
    Top = 332
    Width = 109
    Height = 21
    AutoSize = False
    DecimalPlaces = 3
    DisplayFormat = ',0.###'
    FormatOnEditing = True
    NumGlyphs = 2
    PopupMenu = ConversionPopupMenu
    TabOrder = 14
    OnExit = ImporteRecompensaEditExit
  end
  object conceptoComplementarioEdit: TEdit [35]
    Left = 28
    Top = 384
    Width = 573
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 80
    TabOrder = 15
    OnExit = conceptoComplementarioEditExit
  end
  inherited numCtaDestinoEdit: TMaskEdit
    Visible = False
  end
  inherited claveAutorizaEdit: TMaskEdit
    Left = 492
    Top = 24
    TabOrder = 20
    Visible = False
  end
  inherited IncluirSoporteCheckBox: TCheckBox
    Left = 28
    Top = 472
    TabOrder = 17
  end
  inherited observacionesMemo: TMemo
    Left = 88
    Top = 412
    Width = 513
    Height = 49
    TabOrder = 16
  end
end
