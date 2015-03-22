object CustomRecordForm: TCustomRecordForm
  Left = 248
  Top = 296
  Width = 637
  Height = 306
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object registroLabel: TLabel
    Left = 0
    Top = 238
    Width = 629
    Height = 13
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
  end
  object EntOficOrigenLabel: TLabel
    Left = 24
    Top = 64
    Width = 108
    Height = 13
    Caption = 'Entidad-oficina origen :'
  end
  object EntOficDestinoLabel: TLabel
    Left = 313
    Top = 44
    Width = 77
    Height = 13
    Caption = 'Entidad/Oficina:'
  end
  object DivisaImporteOpLabel: TLabel
    Left = 40
    Top = 116
    Width = 91
    Height = 26
    Caption = 'Divisa operación /'#13#10'Importe operación :'
  end
  object ImporteOpEurosLabel: TLabel
    Left = 372
    Top = 124
    Width = 105
    Height = 13
    Caption = 'Contravalro en Euros :'
  end
  object NumCtaDestinoLabel: TLabel
    Left = 412
    Top = 44
    Width = 76
    Height = 13
    Caption = 'Número cuenta:'
  end
  object DestinoLabel: TLabel
    Left = 268
    Top = 64
    Width = 42
    Height = 13
    Caption = 'Destino :'
  end
  object DCEntOficDestinoLabel: TLabel
    Left = 392
    Top = 64
    Width = 6
    Height = 13
    Caption = '0'
  end
  object DCNumCtaDestinoLabel: TLabel
    Left = 400
    Top = 64
    Width = 6
    Height = 13
    Caption = '0'
  end
  object ClaveAutorizaLabel: TLabel
    Left = 24
    Top = 164
    Width = 108
    Height = 13
    Caption = 'Clave de autorización :'
  end
  object NombreOficinaCajaLabel: TLabel
    Left = 80
    Top = 88
    Width = 181
    Height = 13
    Alignment = taCenter
    AutoSize = False
  end
  object NombreEntidadDestinoLabel: TLabel
    Left = 319
    Top = 88
    Width = 273
    Height = 13
    AutoSize = False
  end
  object ReferencePanel: TPanel
    Left = 0
    Top = 0
    Width = 629
    Height = 25
    Align = alTop
    TabOrder = 10
    object OIDPanel: TPanel
      Left = 1
      Top = 1
      Width = 160
      Height = 23
      Align = alLeft
      BevelOuter = bvLowered
      TabOrder = 0
    end
    object OpRefPanel: TPanel
      Left = 161
      Top = 1
      Width = 160
      Height = 23
      Align = alLeft
      BevelOuter = bvLowered
      TabOrder = 1
    end
    object OpNatPanel: TPanel
      Left = 321
      Top = 1
      Width = 147
      Height = 23
      Align = alClient
      BevelOuter = bvLowered
      TabOrder = 2
    end
    object DateCreationPanel: TPanel
      Left = 468
      Top = 1
      Width = 160
      Height = 23
      Align = alRight
      BevelOuter = bvLowered
      TabOrder = 3
    end
  end
  object bottomPanel: TPanel
    Left = 0
    Top = 251
    Width = 629
    Height = 28
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 11
    object leftDocumentalLabel: TLabel
      Left = 4
      Top = 12
      Width = 101
      Height = 13
      Caption = 'Carácter documental:'
    end
    object CaracterDocumentalLabel: TLabel
      Left = 108
      Top = 12
      Width = 3
      Height = 13
    end
    object AceptarButton: TButton
      Left = 472
      Top = 1
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Aceptar'
      TabOrder = 0
      OnClick = AceptarButtonClick
    end
    object CancelarButton: TButton
      Left = 552
      Top = 1
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Cancelar'
      TabOrder = 1
      OnClick = CancelarButtonClick
    end
  end
  object cobroRadioBtn: TRadioButton
    Left = 92
    Top = 36
    Width = 61
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Cobro :'
    Checked = True
    TabOrder = 0
    TabStop = True
    OnClick = cobroRadioBtnClick
    OnExit = cobroRadioBtnClick
  end
  object pagoRadioBtn: TRadioButton
    Left = 168
    Top = 36
    Width = 57
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Pago :'
    TabOrder = 1
    OnClick = cobroRadioBtnClick
    OnExit = cobroRadioBtnClick
  end
  object EntidadOrigenEdit: TEdit
    Left = 140
    Top = 60
    Width = 33
    Height = 21
    TabStop = False
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 2
    Text = '2052'
  end
  object OficinaOrigenEdit: TMaskEdit
    Left = 180
    Top = 60
    Width = 33
    Height = 21
    EditMask = '9999;1; '
    MaxLength = 4
    TabOrder = 3
    Text = '    '
    OnExit = OficinaOrigenEditExit
  end
  object EntidadOficinaDestinoEdit: TMaskEdit
    Left = 316
    Top = 60
    Width = 69
    Height = 21
    EditMask = '!9999\-9999;0; '
    MaxLength = 9
    TabOrder = 4
    OnExit = EntidadOficinaDestinoEditExit
  end
  object DivisaOperacionComboBox: TComboBox
    Left = 140
    Top = 120
    Width = 65
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 6
    OnChange = DivisaOperacionComboBoxChange
    OnExit = DivisaOperacionComboBoxChange
    Items.Strings = (
      'EUR'
      'PTA')
  end
  object ImporteOrigenOperacionEdit: TRxCalcEdit
    Left = 216
    Top = 120
    Width = 121
    Height = 21
    AutoSize = False
    DecimalPlaces = 3
    DisplayFormat = ',0.###'
    FormatOnEditing = True
    NumGlyphs = 2
    TabOrder = 7
    OnExit = ImporteOrigenOperacionEditExit
  end
  object ImportePrincipalOperacionEurosEdit: TEdit
    Left = 484
    Top = 120
    Width = 109
    Height = 21
    TabStop = False
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 8
  end
  object numCtaDestinoEdit: TMaskEdit
    Left = 412
    Top = 60
    Width = 121
    Height = 21
    EditMask = '9999999999;0; '
    MaxLength = 10
    TabOrder = 5
    OnExit = numCtaDestinoEditExit
  end
  object claveAutorizaEdit: TMaskEdit
    Left = 140
    Top = 160
    Width = 121
    Height = 21
    EditMask = '999999999999999999;0; '
    MaxLength = 18
    TabOrder = 9
    OnExit = claveAutorizaEditExit
  end
end
