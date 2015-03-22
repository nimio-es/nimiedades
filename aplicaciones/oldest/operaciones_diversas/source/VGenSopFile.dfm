object GenSopFileForm: TGenSopFileForm
  Left = 234
  Top = 110
  BorderStyle = bsDialog
  Caption = 'Generaci'#243'n del fichero...'
  ClientHeight = 403
  ClientWidth = 665
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 12
    Top = 16
    Width = 42
    Height = 13
    Caption = 'Destino :'
  end
  object Label2: TLabel
    Left = 12
    Top = 88
    Width = 144
    Height = 13
    Caption = 'Nombre del fichero resultante: '
  end
  object Label3: TLabel
    Left = 12
    Top = 48
    Width = 120
    Height = 13
    Caption = 'Fecha de compensaci'#243'n:'
  end
  object DirectorioDestinoEdit: TDirectoryEdit
    Left = 64
    Top = 12
    Width = 589
    Height = 21
    InitialDir = 'C:\'
    NumGlyphs = 1
    TabOrder = 0
    Text = 'C:\'
  end
  object ShowFileMemo: TMemo
    Left = 12
    Top = 136
    Width = 641
    Height = 253
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 3
    WordWrap = False
  end
  object procederBtn: TButton
    Left = 496
    Top = 52
    Width = 75
    Height = 25
    Caption = '&Proceder'
    TabOrder = 2
  end
  object cancelarBtn: TButton
    Left = 576
    Top = 52
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 4
  end
  object NombreFicheroResultanteEdit: TEdit
    Left = 164
    Top = 84
    Width = 121
    Height = 21
    TabStop = False
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 5
  end
  object Panel1: TPanel
    Left = 12
    Top = 116
    Width = 641
    Height = 21
    Alignment = taLeftJustify
    Caption = '  Imagen del soporte...'
    TabOrder = 6
  end
  object fechaCompensacionEdit: TDateEdit
    Left = 164
    Top = 44
    Width = 105
    Height = 21
    CheckOnExit = True
    DefaultToday = True
    DialogTitle = 'Seleccione una fecha'
    NumGlyphs = 2
    YearDigits = dyFour
    TabOrder = 1
    OnAcceptDate = fechaCompensacionEditAcceptDate
  end
end
