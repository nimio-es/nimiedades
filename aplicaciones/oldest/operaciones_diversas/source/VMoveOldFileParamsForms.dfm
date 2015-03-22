object MoveOldFilesParamsForm: TMoveOldFilesParamsForm
  Left = 244
  Top = 232
  BorderStyle = bsDialog
  Caption = 'Mover registros viejos'
  ClientHeight = 127
  ClientWidth = 377
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
    Top = 28
    Width = 78
    Height = 13
    Caption = 'Fecha de corte :'
  end
  object borrarOLDCheckBox: TCheckBox
    Left = 224
    Top = 28
    Width = 125
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Borrar archivos OLD'
    TabOrder = 1
  end
  object borrarDELCheckBox: TCheckBox
    Left = 224
    Top = 52
    Width = 125
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Borrar archivos DEL'
    TabOrder = 2
  end
  object fechaCorteEdit: TDateEdit
    Left = 104
    Top = 24
    Width = 93
    Height = 21
    DialogTitle = 'Seleccione una fecha'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    NumGlyphs = 2
    ParentFont = False
    YearDigits = dyFour
    TabOrder = 0
    OnChange = fechaCorteEditChange
  end
  object aceptarButton: TButton
    Left = 196
    Top = 84
    Width = 75
    Height = 25
    Caption = 'Aceptar'
    ModalResult = 1
    TabOrder = 3
  end
  object cancelarButton: TButton
    Left = 276
    Top = 84
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    ModalResult = 2
    TabOrder = 4
  end
end
