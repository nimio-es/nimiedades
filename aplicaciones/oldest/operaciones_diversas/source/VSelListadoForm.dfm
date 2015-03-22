object SelListadoForm: TSelListadoForm
  Left = 230
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Selecci'#243'n del tipo de listado....'
  ClientHeight = 183
  ClientWidth = 506
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
    Left = 16
    Top = 20
    Width = 163
    Height = 13
    Caption = 'Indique qu'#233' listado desea generar.'
  end
  object Bevel1: TBevel
    Left = 208
    Top = 16
    Width = 9
    Height = 149
    Shape = bsLeftLine
    Style = bsRaised
  end
  object Label2: TLabel
    Left = 228
    Top = 20
    Width = 208
    Height = 13
    Caption = #191'Entre qu'#233' fechas quiere generar el listado?'
  end
  object Label3: TLabel
    Left = 228
    Top = 52
    Width = 37
    Height = 13
    Caption = 'Desde :'
  end
  object Label4: TLabel
    Left = 228
    Top = 84
    Width = 34
    Height = 13
    Caption = 'Hasta :'
  end
  object Label5: TLabel
    Left = 392
    Top = 52
    Width = 47
    Height = 13
    Caption = '(inclusive)'
  end
  object Label6: TLabel
    Left = 392
    Top = 84
    Width = 47
    Height = 13
    Caption = '(inclusive)'
  end
  object tiposOperacionesRadioButton: TRadioButton
    Left = 40
    Top = 52
    Width = 133
    Height = 17
    Caption = 'Tipos de operaciones'
    Checked = True
    TabOrder = 0
    TabStop = True
  end
  object soportesRadioButton: TRadioButton
    Left = 40
    Top = 84
    Width = 65
    Height = 21
    Caption = 'Soportes'
    TabOrder = 1
    TabStop = True
  end
  object fechaDesdeEdit: TDateEdit
    Left = 272
    Top = 48
    Width = 105
    Height = 21
    NumGlyphs = 2
    YearDigits = dyFour
    TabOrder = 2
  end
  object fechaHastaEdit: TDateEdit
    Left = 272
    Top = 80
    Width = 105
    Height = 21
    NumGlyphs = 2
    YearDigits = dyFour
    TabOrder = 3
  end
  object AceptarButton: TButton
    Left = 332
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Aceptar'
    TabOrder = 4
  end
  object CancelarButton: TButton
    Left = 412
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Terminar'
    TabOrder = 5
  end
end
