object ConfigSystemForm: TConfigSystemForm
  Left = 238
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Configuraci'#243'n...'
  ClientHeight = 397
  ClientWidth = 575
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 20
    Top = 24
    Width = 55
    Height = 13
    Caption = 'ID Estaci'#243'n'
  end
  object Label2: TLabel
    Left = 108
    Top = 24
    Width = 105
    Height = 13
    Caption = 'Directorio de los datos'
  end
  object BuscaDirSpeedBtn: TSpeedButton
    Left = 528
    Top = 40
    Width = 23
    Height = 22
    Caption = '...'
    OnClick = BuscaDirSpeedBtnClick
  end
  object Label3: TLabel
    Left = 20
    Top = 84
    Width = 208
    Height = 13
    Caption = 'Operaciones que puede realizar este puesto'
  end
  object Label4: TLabel
    Left = 20
    Top = 220
    Width = 499
    Height = 13
    Caption = 
      'Estaciones de las que puede leer su trabajo ( debe separse por c' +
      'omas sin espacios en blanco ; * = todas )'
  end
  object Label5: TLabel
    Left = 20
    Top = 284
    Width = 46
    Height = 13
    Caption = 'C'#243'digo A:'
  end
  object Label6: TLabel
    Left = 188
    Top = 284
    Width = 46
    Height = 13
    Caption = 'C'#243'digo B:'
  end
  object Label7: TLabel
    Left = 20
    Top = 312
    Width = 422
    Height = 13
    Caption = 
      '* Si no se le ha facilitado el c'#243'digo B, llame usted a CINCA par' +
      'a obtener un c'#243'digo v'#225'lido.'
  end
  object systemNameLabel: TLabel
    Left = 20
    Top = 364
    Width = 98
    Height = 13
    Caption = 'Nombre del sistema: '
    Visible = False
  end
  object StationIDEdit: TEdit
    Left = 20
    Top = 40
    Width = 61
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 6
    TabOrder = 0
    OnChange = StationIDEditChange
    OnExit = StationIDEditChange
  end
  object pathToDBFilesEdit: TEdit
    Left = 108
    Top = 40
    Width = 417
    Height = 21
    TabOrder = 1
    OnChange = StationIDEditChange
    OnExit = StationIDEditChange
  end
  object opTipo05CheckBox: TCheckBox
    Left = 20
    Top = 184
    Width = 61
    Height = 17
    Caption = 'Tipo 05'
    TabOrder = 6
    OnClick = StationIDEditChange
  end
  object opTipo06CheckBox: TCheckBox
    Left = 108
    Top = 104
    Width = 61
    Height = 17
    Caption = 'Tipo 06'
    TabOrder = 7
    OnClick = StationIDEditChange
  end
  object opTipo07CheckBox: TCheckBox
    Left = 108
    Top = 124
    Width = 61
    Height = 17
    Caption = 'Tipo 07'
    TabOrder = 8
    OnClick = StationIDEditChange
  end
  object opTipo08CheckBox: TCheckBox
    Left = 108
    Top = 144
    Width = 61
    Height = 17
    Caption = 'Tipo 08'
    TabOrder = 9
    OnClick = StationIDEditChange
  end
  object opTipo09CheckBox: TCheckBox
    Left = 108
    Top = 164
    Width = 61
    Height = 17
    Caption = 'Tipo 09'
    TabOrder = 10
    OnClick = StationIDEditChange
  end
  object opTipo10CheckBox: TCheckBox
    Left = 108
    Top = 184
    Width = 61
    Height = 17
    Caption = 'Tipo 10'
    TabOrder = 11
    OnClick = StationIDEditChange
  end
  object opTipo11CheckBox: TCheckBox
    Left = 196
    Top = 104
    Width = 61
    Height = 17
    Caption = 'Tipo 11'
    Enabled = False
    TabOrder = 12
    OnClick = StationIDEditChange
  end
  object opTipo12CheckBox: TCheckBox
    Left = 196
    Top = 124
    Width = 61
    Height = 17
    Caption = 'Tipo 12'
    TabOrder = 13
    OnClick = StationIDEditChange
  end
  object opTipo13CheckBox: TCheckBox
    Left = 196
    Top = 144
    Width = 61
    Height = 17
    Caption = 'Tipo 13'
    Enabled = False
    TabOrder = 14
    OnClick = StationIDEditChange
  end
  object opTipo14CheckBox: TCheckBox
    Left = 196
    Top = 164
    Width = 61
    Height = 17
    Caption = 'Tipo 14'
    TabOrder = 15
    OnClick = StationIDEditChange
  end
  object opFLECheckBox: TCheckBox
    Left = 284
    Top = 164
    Width = 137
    Height = 17
    BiDiMode = bdLeftToRight
    Caption = 'Generaci'#243'n soporte'
    ParentBiDiMode = False
    TabOrder = 18
    OnClick = StationIDEditChange
  end
  object opLSTCheckBox: TCheckBox
    Left = 284
    Top = 144
    Width = 109
    Height = 17
    Caption = 'Listado del d'#237'a'
    TabOrder = 17
    OnClick = StationIDEditChange
  end
  object canReadEdit: TEdit
    Left = 20
    Top = 236
    Width = 529
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 19
    OnChange = StationIDEditChange
    OnExit = StationIDEditChange
  end
  object codigoAEdit: TEdit
    Left = 76
    Top = 280
    Width = 77
    Height = 21
    CharCase = ecUpperCase
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 20
  end
  object codigoBEdit: TEdit
    Left = 244
    Top = 280
    Width = 77
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 6
    TabOrder = 21
    OnChange = codigoBEditChange
  end
  object AceptarBtn: TButton
    Left = 396
    Top = 356
    Width = 75
    Height = 25
    Caption = 'Aceptar'
    Enabled = False
    TabOrder = 22
    OnClick = AceptarBtnClick
  end
  object CancelarBtn: TButton
    Left = 476
    Top = 356
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancelar'
    ModalResult = 2
    TabOrder = 23
  end
  object opTipo01CheckBox: TCheckBox
    Left = 20
    Top = 104
    Width = 61
    Height = 17
    Caption = 'Tipo 01'
    Enabled = False
    TabOrder = 2
    OnClick = StationIDEditChange
  end
  object opTipo02CheckBox: TCheckBox
    Left = 20
    Top = 124
    Width = 61
    Height = 17
    Caption = 'Tipo 02'
    TabOrder = 3
    OnClick = StationIDEditChange
  end
  object opTipo03CheckBox: TCheckBox
    Left = 20
    Top = 144
    Width = 61
    Height = 17
    Caption = 'Tipo 03'
    TabOrder = 4
    OnClick = StationIDEditChange
  end
  object opTipo04CheckBox: TCheckBox
    Left = 20
    Top = 164
    Width = 61
    Height = 17
    Caption = 'Tipo 04'
    TabOrder = 5
    OnClick = StationIDEditChange
  end
  object opTipoDevCheckBox: TCheckBox
    Left = 284
    Top = 104
    Width = 93
    Height = 17
    Caption = 'Devoluciones'
    TabOrder = 16
    OnClick = StationIDEditChange
  end
end
