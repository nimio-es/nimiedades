inherited OpDivRecType06Form: TOpDivRecType06Form
  Left = 186
  Top = 144
  Width = 666
  Height = 572
  Caption = '06 - Comisiones y gastos de Cr'#233'ditos y/o Remesas documentarias'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited registroLabel: TLabel
    Top = 497
    Width = 658
  end
  inherited EntOficOrigenLabel: TLabel
    Top = 60
  end
  inherited EntOficDestinoLabel: TLabel
    Top = 40
  end
  inherited DivisaImporteOpLabel: TLabel
    Top = 164
  end
  inherited ImporteOpEurosLabel: TLabel
    Top = 172
  end
  inherited NumCtaDestinoLabel: TLabel
    Top = 40
  end
  object Label6: TLabel [6]
    Left = 79
    Top = 112
    Width = 77
    Height = 13
    Caption = 'Tipo operaci'#243'n :'
  end
  object Label7: TLabel [7]
    Left = 208
    Top = 112
    Width = 146
    Height = 13
    Caption = '( "1" = Cr'#233'dito; "2" = Remesa )'
  end
  object Label8: TLabel [8]
    Left = 30
    Top = 260
    Width = 126
    Height = 13
    Caption = 'Referencia del ordenante :'
  end
  object Label9: TLabel [9]
    Left = 308
    Top = 248
    Width = 94
    Height = 26
    Caption = 'N'#250'mero del cr'#233'dito'#13#10' o remesa ............. :'
  end
  object Label10: TLabel [10]
    Left = 70
    Top = 288
    Width = 86
    Height = 13
    Caption = 'Fecha operaci'#243'n :'
  end
  object Label11: TLabel [11]
    Left = 75
    Top = 320
    Width = 81
    Height = 13
    Caption = 'Entidad emisora :'
  end
  inherited DestinoLabel: TLabel
    Top = 60
  end
  object Label13: TLabel [13]
    Left = 61
    Top = 376
    Width = 95
    Height = 13
    Caption = 'Cliente beneficiario :'
  end
  inherited DCEntOficDestinoLabel: TLabel
    Top = 60
  end
  object ImporteCreditoLabel: TLabel [15]
    Left = 228
    Top = 140
    Width = 139
    Height = 13
    Caption = 'Importe del cr'#233'dito o remesa :'
  end
  object Label16: TLabel [16]
    Left = 40
    Top = 208
    Width = 219
    Height = 13
    Caption = 'Detalle comisi'#243'n (en euros)........   Comisiones :'
  end
  object Label17: TLabel [17]
    Left = 388
    Top = 208
    Width = 39
    Height = 13
    Caption = 'Gastos :'
  end
  object Label18: TLabel [18]
    Left = 72
    Top = 476
    Width = 31
    Height = 13
    Caption = 'Otros :'
    Visible = False
  end
  inherited DCNumCtaDestinoLabel: TLabel
    Top = 60
  end
  inherited ClaveAutorizaLabel: TLabel
    Left = 524
    Top = 32
    Visible = False
  end
  object Label19: TLabel [21]
    Left = 0
    Top = 140
    Width = 157
    Height = 13
    Caption = 'Divisa del cr'#233'dito o remesa (ISO):'
  end
  object Label1: TLabel [22]
    Left = 80
    Top = 348
    Width = 73
    Height = 13
    Caption = 'Clliente emisor :'
  end
  inherited buscarEntidadSpeedButton: TSpeedButton
    Left = 504
    Top = 56
  end
  inherited observacionesLabel: TLabel
    Left = 100
    Top = 408
  end
  inherited ReferencePanel: TPanel
    Width = 658
    TabOrder = 23
    inherited OpNatPanel: TPanel
      Width = 176
    end
    inherited DateCreationPanel: TPanel
      Left = 497
    end
  end
  inherited bottomPanel: TPanel
    Top = 510
    Width = 658
    TabOrder = 24
    inherited AceptarButton: TButton
      Left = 501
    end
    inherited CancelarButton: TButton
      Left = 581
    end
  end
  inherited cobroRadioBtn: TRadioButton
    Left = 104
    Top = 32
    TabOrder = 21
    Visible = False
  end
  inherited pagoRadioBtn: TRadioButton
    Left = 152
    Top = 32
    TabOrder = 22
    Visible = False
  end
  inherited EntidadOrigenEdit: TEdit
    Top = 56
    TabOrder = 20
  end
  inherited OficinaOrigenEdit: TMaskEdit
    Top = 56
    TabOrder = 0
  end
  inherited EntidadOficinaDestinoEdit: TMaskEdit
    Top = 56
    TabOrder = 1
  end
  inherited DivisaOperacionComboBox: TComboBox
    Top = 168
  end
  inherited ImporteOrigenOperacionEdit: TRxCalcEdit
    Top = 168
    PopupMenu = ConversionPopupMenu
  end
  inherited ImportePrincipalOperacionEurosEdit: TEdit
    Top = 168
  end
  object tipoOpEdit: TMaskEdit [37]
    Left = 164
    Top = 108
    Width = 21
    Height = 21
    EditMask = '9;0; '
    MaxLength = 1
    TabOrder = 3
    OnExit = tipoOpEditExit
  end
  object refOrdenanteEdit: TEdit [38]
    Left = 164
    Top = 256
    Width = 129
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 16
    TabOrder = 11
    OnExit = refOrdenanteEditExit
  end
  object numCreditoEdit: TEdit [39]
    Left = 412
    Top = 256
    Width = 129
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 16
    TabOrder = 12
    OnExit = numCreditoEditExit
  end
  object entidadEmisoraEdit: TEdit [40]
    Left = 164
    Top = 316
    Width = 317
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 35
    TabOrder = 14
    OnExit = entidadEmisoraEditExit
  end
  object clienteEmisorEdit: TEdit [41]
    Left = 164
    Top = 344
    Width = 317
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 35
    TabOrder = 15
    OnExit = clienteEmisorEditExit
  end
  object clienteBeneficiarioEdit: TEdit [42]
    Left = 164
    Top = 372
    Width = 317
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 35
    TabOrder = 16
    OnExit = clienteBeneficiarioEditChange
  end
  object importeCreditoEdit: TRxCalcEdit [43]
    Left = 380
    Top = 136
    Width = 137
    Height = 21
    AutoSize = False
    DisplayFormat = ',0.00'
    FormatOnEditing = True
    NumGlyphs = 2
    TabOrder = 5
    OnExit = importeCreditoEditExit
  end
  object divisaCreditoEdit: TMaskEdit [44]
    Left = 164
    Top = 136
    Width = 37
    Height = 21
    CharCase = ecUpperCase
    EditMask = 'lll;0; '
    MaxLength = 3
    TabOrder = 4
    OnExit = divisaCreditoEditExit
  end
  object comisionesEdit: TRxCalcEdit [45]
    Left = 272
    Top = 204
    Width = 89
    Height = 21
    AutoSize = False
    DisplayFormat = ',0.00'
    FormatOnEditing = True
    NumGlyphs = 2
    PopupMenu = ConversionPopupMenu
    TabOrder = 9
    OnExit = comisionesEditExit
  end
  object gastosEdit: TRxCalcEdit [46]
    Left = 436
    Top = 204
    Width = 89
    Height = 21
    AutoSize = False
    DisplayFormat = ',0.00'
    FormatOnEditing = True
    NumGlyphs = 2
    PopupMenu = ConversionPopupMenu
    TabOrder = 10
    OnExit = gastosEditExit
  end
  object disponibleEdit: TEdit [47]
    Left = 112
    Top = 488
    Width = 469
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 66
    TabOrder = 17
    Visible = False
    OnExit = disponibleEditChange
  end
  object fechaOpEdit: TDateEdit [48]
    Left = 164
    Top = 284
    Width = 105
    Height = 21
    CheckOnExit = True
    NumGlyphs = 2
    YearDigits = dyFour
    TabOrder = 13
    OnExit = fechaOpEditExit
  end
  inherited numCtaDestinoEdit: TMaskEdit
    Top = 56
    TabOrder = 2
  end
  inherited claveAutorizaEdit: TMaskEdit
    Left = 520
    Top = 28
    TabOrder = 25
    Visible = False
  end
  inherited IncluirSoporteCheckBox: TCheckBox
    Left = 20
    Top = 472
    TabOrder = 19
  end
  inherited observacionesMemo: TMemo
    Left = 164
    Top = 408
    Width = 469
    Height = 53
    TabOrder = 18
  end
end
