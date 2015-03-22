object GenConfigForm: TGenConfigForm
  Left = 244
  Top = 193
  BorderStyle = bsDialog
  Caption = 'Generar archivo de configuraci'#243'n'
  ClientHeight = 388
  ClientWidth = 579
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 20
    Top = 48
    Width = 55
    Height = 13
    Caption = 'ID Estaci'#243'n'
  end
  object Label2: TLabel
    Left = 108
    Top = 48
    Width = 105
    Height = 13
    Caption = 'Directorio de los datos'
  end
  object Label3: TLabel
    Left = 20
    Top = 108
    Width = 208
    Height = 13
    Caption = 'Operaciones que puede realizar este puesto'
  end
  object Label4: TLabel
    Left = 20
    Top = 244
    Width = 499
    Height = 13
    Caption = 
      'Estaciones de las que puede leer su trabajo ( debe separse por c' +
      'omas sin espacios en blanco ; * = todas )'
  end
  object Label5: TLabel
    Left = 20
    Top = 308
    Width = 46
    Height = 13
    Caption = 'C'#243'digo A:'
  end
  object Label6: TLabel
    Left = 188
    Top = 308
    Width = 46
    Height = 13
    Caption = 'C'#243'digo B:'
  end
  object Label7: TLabel
    Left = 20
    Top = 16
    Width = 92
    Height = 13
    Caption = 'Nombre del equipo:'
  end
  object StationIDEdit: TEdit
    Left = 20
    Top = 64
    Width = 61
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 6
    TabOrder = 1
    OnChange = StationIDEditChange
  end
  object opTipo05CheckBox: TCheckBox
    Left = 20
    Top = 208
    Width = 61
    Height = 17
    Caption = 'Tipo 05'
    TabOrder = 7
    OnClick = opTipo02CheckBoxClick
  end
  object opTipo06CheckBox: TCheckBox
    Left = 108
    Top = 128
    Width = 61
    Height = 17
    Caption = 'Tipo 06'
    TabOrder = 8
    OnClick = opTipo02CheckBoxClick
  end
  object opTipo07CheckBox: TCheckBox
    Left = 108
    Top = 148
    Width = 61
    Height = 17
    Caption = 'Tipo 07'
    TabOrder = 9
    OnClick = opTipo02CheckBoxClick
  end
  object opTipo08CheckBox: TCheckBox
    Left = 108
    Top = 168
    Width = 61
    Height = 17
    Caption = 'Tipo 08'
    TabOrder = 10
    OnClick = opTipo02CheckBoxClick
  end
  object opTipo09CheckBox: TCheckBox
    Left = 108
    Top = 188
    Width = 61
    Height = 17
    Caption = 'Tipo 09'
    TabOrder = 11
    OnClick = opTipo02CheckBoxClick
  end
  object opTipo10CheckBox: TCheckBox
    Left = 108
    Top = 208
    Width = 61
    Height = 17
    Caption = 'Tipo 10'
    TabOrder = 12
    OnClick = opTipo02CheckBoxClick
  end
  object opTipo11CheckBox: TCheckBox
    Left = 196
    Top = 128
    Width = 61
    Height = 17
    Caption = 'Tipo 11'
    Enabled = False
    TabOrder = 13
    OnClick = opTipo02CheckBoxClick
  end
  object opTipo12CheckBox: TCheckBox
    Left = 196
    Top = 148
    Width = 61
    Height = 17
    Caption = 'Tipo 12'
    TabOrder = 14
    OnClick = opTipo02CheckBoxClick
  end
  object opTipo13CheckBox: TCheckBox
    Left = 196
    Top = 168
    Width = 61
    Height = 17
    Caption = 'Tipo 13'
    Enabled = False
    TabOrder = 15
    OnClick = opTipo02CheckBoxClick
  end
  object opTipo14CheckBox: TCheckBox
    Left = 196
    Top = 188
    Width = 61
    Height = 17
    Caption = 'Tipo 14'
    TabOrder = 16
    OnClick = opTipo02CheckBoxClick
  end
  object opFLECheckBox: TCheckBox
    Left = 284
    Top = 188
    Width = 137
    Height = 17
    BiDiMode = bdLeftToRight
    Caption = 'Generaci'#243'n soporte'
    ParentBiDiMode = False
    TabOrder = 19
    OnClick = opTipo02CheckBoxClick
  end
  object opLSTCheckBox: TCheckBox
    Left = 284
    Top = 168
    Width = 109
    Height = 17
    Caption = 'Listado del d'#237'a'
    TabOrder = 18
    OnClick = opTipo02CheckBoxClick
  end
  object canReadEdit: TEdit
    Left = 20
    Top = 260
    Width = 529
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 20
    OnChange = canReadEditChange
  end
  object codigoAEdit: TEdit
    Left = 76
    Top = 304
    Width = 77
    Height = 21
    TabStop = False
    CharCase = ecUpperCase
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 21
  end
  object codigoBEdit: TEdit
    Left = 244
    Top = 304
    Width = 77
    Height = 21
    TabStop = False
    CharCase = ecUpperCase
    Color = clBtnFace
    MaxLength = 6
    ReadOnly = True
    TabOrder = 22
  end
  object GuardarConfButton: TButton
    Left = 376
    Top = 350
    Width = 91
    Height = 25
    Caption = 'Guardar archivo'
    TabOrder = 23
    OnClick = GuardarConfButtonClick
  end
  object SalirButton: TButton
    Left = 492
    Top = 350
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Salir'
    ModalResult = 2
    TabOrder = 24
    OnClick = SalirButtonClick
  end
  object opTipo01CheckBox: TCheckBox
    Left = 20
    Top = 128
    Width = 61
    Height = 17
    Caption = 'Tipo 01'
    Enabled = False
    TabOrder = 3
    OnClick = opTipo02CheckBoxClick
  end
  object opTipo02CheckBox: TCheckBox
    Left = 20
    Top = 148
    Width = 61
    Height = 17
    Caption = 'Tipo 02'
    TabOrder = 4
    OnClick = opTipo02CheckBoxClick
  end
  object opTipo03CheckBox: TCheckBox
    Left = 20
    Top = 168
    Width = 61
    Height = 17
    Caption = 'Tipo 03'
    TabOrder = 5
    OnClick = opTipo02CheckBoxClick
  end
  object opTipo04CheckBox: TCheckBox
    Left = 20
    Top = 188
    Width = 61
    Height = 17
    Caption = 'Tipo 04'
    TabOrder = 6
    OnClick = opTipo02CheckBoxClick
  end
  object opTipoDevCheckBox: TCheckBox
    Left = 284
    Top = 128
    Width = 93
    Height = 17
    Caption = 'Devoluciones'
    TabOrder = 17
    OnClick = opTipo02CheckBoxClick
  end
  object nombreEquipoEdit: TEdit
    Left = 120
    Top = 12
    Width = 105
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 0
    OnChange = nombreEquipoEditChange
  end
  object CargarConfButton: TButton
    Left = 284
    Top = 350
    Width = 87
    Height = 25
    Caption = 'Cargar archivo'
    TabOrder = 25
    OnClick = CargarConfButtonClick
  end
  object PathToDBFilesEdit: TDirectoryEdit
    Left = 108
    Top = 64
    Width = 445
    Height = 21
    NumGlyphs = 1
    TabOrder = 2
    OnChange = PathToDBFilesEditChange
  end
end
