inherited OpDivRecType09Form: TOpDivRecType09Form
  Top = 186
  Width = 645
  Height = 471
  Caption = '09 - Compraventa de moneda extranjera'
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  inherited registroLabel: TLabel
    Top = 396
    Width = 637
  end
  object Label3: TLabel [1]
    Left = 24
    Top = 184
    Width = 112
    Height = 26
    Caption = 'Fecha de contrataci'#243'n'#13#10'de la operaci'#243'n            :'
  end
  object Label4: TLabel [2]
    Left = 240
    Top = 228
    Width = 97
    Height = 13
    Caption = 'Importe de la divisa :'
  end
  object Label6: TLabel [3]
    Left = 52
    Top = 228
    Width = 83
    Height = 13
    Caption = 'Divisa (c'#243'd. ISO):'
  end
  object Label7: TLabel [4]
    Left = 260
    Top = 256
    Width = 79
    Height = 13
    Caption = 'Tipo de cambio :'
  end
  inherited ClaveAutorizaLabel: TLabel
    Top = 156
  end
  inherited buscarEntidadSpeedButton: TSpeedButton
    Left = 504
  end
  object Label1: TLabel [17]
    Left = 476
    Top = 256
    Width = 136
    Height = 13
    Caption = '(1 Euro = ? Uds. de la divisa)'
  end
  inherited observacionesLabel: TLabel
    Left = 80
    Top = 308
  end
  object fechaContratacionEdit: TDateEdit [19]
    Left = 144
    Top = 188
    Width = 101
    Height = 21
    NumGlyphs = 2
    YearDigits = dyFour
    TabOrder = 10
    OnExit = fechaContratacionEditExit
  end
  object tipoCambioEdit: TRxCalcEdit [20]
    Left = 348
    Top = 252
    Width = 121
    Height = 21
    AutoSize = False
    DecimalPlaces = 6
    DisplayFormat = ',0.######'
    FormatOnEditing = True
    NumGlyphs = 2
    PopupMenu = ConversionPopupMenu
    TabOrder = 13
    OnExit = tipoCambioEditExit
  end
  object divisaEdit: TEdit [21]
    Left = 144
    Top = 224
    Width = 33
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 3
    TabOrder = 11
    OnExit = divisaEditExit
  end
  object importeDivisaEdit: TRxCalcEdit [22]
    Left = 348
    Top = 224
    Width = 121
    Height = 21
    AutoSize = False
    DecimalPlaces = 4
    DisplayFormat = ',0.####'
    FormatOnEditing = True
    NumGlyphs = 2
    PopupMenu = ConversionPopupMenu
    TabOrder = 12
    OnExit = importeDivisaEditExit
  end
  inherited ReferencePanel: TPanel
    Width = 637
    TabOrder = 18
    inherited OpNatPanel: TPanel
      Width = 155
    end
    inherited DateCreationPanel: TPanel
      Left = 476
    end
  end
  inherited bottomPanel: TPanel
    Top = 409
    Width = 637
    TabOrder = 17
    inherited AceptarButton: TButton
      Left = 480
    end
    inherited CancelarButton: TButton
      Left = 560
    end
  end
  inherited cobroRadioBtn: TRadioButton
    Top = 32
  end
  inherited pagoRadioBtn: TRadioButton
    Top = 32
  end
  inherited claveAutorizaEdit: TMaskEdit
    Top = 152
  end
  object calcularImporteOp: TButton [35]
    Left = 348
    Top = 280
    Width = 119
    Height = 17
    Caption = 'Calcular Importe Op.'
    TabOrder = 16
    TabStop = False
    OnClick = calcularImporteOpClick
  end
  inherited IncluirSoporteCheckBox: TCheckBox
    Left = 464
    Top = 376
    TabOrder = 15
  end
  inherited observacionesMemo: TMemo
    Left = 144
    Top = 308
    Width = 473
    TabOrder = 14
  end
end
