object Principal: TPrincipal
  Left = 417
  Top = 249
  Width = 264
  Height = 199
  Caption = 'Código B'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 36
    Width = 46
    Height = 13
    Caption = 'Código A:'
  end
  object Label2: TLabel
    Left = 24
    Top = 68
    Width = 46
    Height = 13
    Caption = 'Código B:'
  end
  object CodigoAEdit: TEdit
    Left = 80
    Top = 32
    Width = 121
    Height = 21
    MaxLength = 6
    TabOrder = 0
  end
  object codigoBEdit: TEdit
    Left = 80
    Top = 64
    Width = 121
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 1
  end
  object Button1: TButton
    Left = 92
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Calcular'
    TabOrder = 2
    OnClick = Button1Click
  end
end
